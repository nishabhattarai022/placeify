import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import '../../../shared/tripo_api_key_config.dart';
import 'aws_s3_put.dart';

/// Tripo OpenAPI client for image-to-3D generation.
///
/// API key: [TripoApiKeyConfig.configFileName] or [TripoApiKeyConfig.apiKeyEnv].
abstract final class TripoClient {
  static const _baseUrl = 'https://api.tripo3d.ai/v2/openapi';
  /// H3 multiview — better geometry/texture than v2.5 for furniture.
  static const _modelVersion = 'v3.1-20260211';
  static const _pollInterval = Duration(seconds: 3);
  static const _maxPollAttempts = 120;

  /// Guides shape + materials for furniture multiview reconstruction.
  static const multiviewPrompt =
      'Reconstruct this exact furniture piece from the multi-view photos. '
      'Match the true proportions, silhouette, backrest shape, armrest curves, '
      'seat depth, leg style, and all distinctive design features visible in '
      'the photos. Preserve wood grain, fabric weave, stitching, seams, '
      'patterns, and material characteristics. Do not simplify, smooth, or '
      'genericize the design. The result must look like the same real product '
      'for e-commerce and AR.';

  static const multiviewNegativePrompt =
      'wrong proportions, generic chair, simplified shape, missing back cutout, '
      'smooth texture, blurred texture, plastic appearance, toy-like, stylized, '
      'cartoon, low detail, averaged texture, different furniture design';

  /// Maximum texture fidelity — no autofix, low-poly, PBR regen, or compression.
  static const _baseTextureParams = <String, dynamic>{
    'texture': true,
    'pbr': false,
    'texture_alignment': 'original_image',
    'orientation': 'align_image',
    'enable_image_autofix': false,
    'smart_low_poly': false,
    'quad': false,
    'generate_parts': false,
    'geometry_quality': 'detailed',
    'prompt': multiviewPrompt,
    'negative_prompt': multiviewNegativePrompt,
  };

  /// Tripo task params tuned for furniture multiview texture fidelity.
  static Map<String, dynamic> taskParamsForLogging({required int viewCount}) {
    return _taskParams(viewCount: viewCount);
  }

  static Map<String, dynamic> _taskParams({required int viewCount}) {
    return {
      ..._baseTextureParams,
      'face_limit': viewCount >= 5 ? 800000 : 600000,
      'texture_quality': 'extreme',
    };
  }

  /// Uploads [imageBytes] to Tripo, runs image_to_model, returns a GLB download URL.
  static Future<String> generateModelFromImage(
    Session session, {
    required List<int> imageBytes,
    required String imageFormat,
  }) async {
    final apiKey = _requireApiKey();
    final uploaded = await _uploadImage(
      session,
      apiKey: apiKey,
      imageBytes: imageBytes,
      imageFormat: imageFormat,
    );

    final taskId = await _createImageToModelTask(
      apiKey,
      bucket: uploaded.bucket,
      key: uploaded.key,
      fileType: uploaded.fileType,
      viewCount: 1,
    );

    session.log('Tripo image_to_model task created: $taskId', level: LogLevel.info);

    return _pollForModelUrl(session, apiKey, taskId);
  }

  /// Uploads up to four views in Tripo order [front, left, back, right].
  ///
  /// [views] must contain at least two non-null entries; index 0 (front) is required.
  static Future<String> generateModelFromMultiview(
    Session session, {
    required List<TripoViewImage?> views,
    int? sourceViewCount,
    List<String>? slotLabels,
  }) async {
    if (views.length != 4) {
      throw TripoClientException(
        'Tripo multiview expects exactly 4 view slots [front, left, back, right].',
      );
    }
    if (views.first == null) {
      throw TripoClientException('Tripo multiview requires a front image.');
    }

    final provided = views.whereType<TripoViewImage>().length;
    if (provided < 2) {
      throw TripoClientException(
        'Tripo multiview needs at least two images (front plus one side or back).',
      );
    }

    final apiKey = _requireApiKey();
    final uploadedViews = <_UploadedTripoImage?>[];
    for (final view in views) {
      if (view == null) {
        uploadedViews.add(null);
        continue;
      }
      uploadedViews.add(
        await _uploadImage(
          session,
          apiKey: apiKey,
          imageBytes: view.bytes,
          imageFormat: view.format,
        ),
      );
    }

    final taskParams = _taskParams(viewCount: sourceViewCount ?? provided);
    _logTextureGenerationSettings(
      session,
      taskType: 'multiview_to_model',
      viewCount: sourceViewCount ?? provided,
      taskParams: taskParams,
      views: views,
      slotLabels: slotLabels,
    );

    final taskId = await _createMultiviewToModelTask(
      apiKey,
      uploadedViews,
      taskParams: taskParams,
    );
    session.log(
      'Tripo multiview_to_model task created: $taskId ($provided/4 slots filled, '
      '${sourceViewCount ?? provided} vendor photos)',
      level: LogLevel.info,
    );

    return _pollForModelUrl(session, apiKey, taskId);
  }

  static void _logTextureGenerationSettings(
    Session session, {
    required String taskType,
    required int viewCount,
    required Map<String, dynamic> taskParams,
    required List<TripoViewImage?> views,
    List<String>? slotLabels,
  }) {
    session.log(
      'Tripo $taskType texture settings (viewCount=$viewCount): '
      '${jsonEncode(taskParams)}',
      level: LogLevel.info,
    );
    for (var i = 0; i < views.length; i++) {
      final view = views[i];
      if (view == null) continue;
      final label = slotLabels != null && i < slotLabels.length
          ? slotLabels[i]
          : 'slot_$i';
      session.log(
        'Tripo input $label: format=${view.format}, '
        'bytes=${view.bytes.length}',
        level: LogLevel.info,
      );
    }
  }

  static String _requireApiKey() {
    final apiKey = TripoApiKeyConfig.apiKey();
    if (apiKey == null || apiKey.isEmpty) {
      throw TripoClientException(
        'Tripo API key is not configured. Copy config/tripo_api_key.example.yaml '
        'to config/tripo_api_key.yaml and add your key.',
      );
    }
    return apiKey;
  }

  static Future<_UploadedTripoImage> _uploadImage(
    Session session, {
    required String apiKey,
    required List<int> imageBytes,
    required String imageFormat,
  }) async {
    final stsFormat = _stsFormatForImage(imageFormat);
    final taskFileType = _taskFileTypeForImage(imageFormat);

    final sts = await _requestStsToken(apiKey, stsFormat);
    try {
      await AwsS3Put.upload(
        accessKey: sts.stsAk,
        secretKey: sts.stsSk,
        sessionToken: sts.sessionToken,
        bucket: sts.resourceBucket,
        key: sts.resourceUri,
        host: sts.s3Host,
        body: imageBytes,
        contentType: _contentTypeForFormat(imageFormat),
      );
    } on AwsS3PutException catch (error) {
      throw TripoClientException('Image upload to Tripo failed: ${error.message}');
    }

    session.log(
      'Uploaded image to Tripo S3 (${imageBytes.length} bytes, $imageFormat)',
      level: LogLevel.info,
    );

    return _UploadedTripoImage(
      bucket: sts.resourceBucket,
      key: sts.resourceUri,
      fileType: taskFileType,
    );
  }

  static Future<_StsCredentials> _requestStsToken(
    String apiKey,
    String format,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/upload/sts/token'),
      headers: _headers(apiKey),
      body: jsonEncode({'format': format}),
    );
    final body = _decodeResponse(response);
    final data = _dataMap(body);

    return _StsCredentials(
      s3Host: data['s3_host'] as String? ?? 's3.us-west-2.amazonaws.com',
      resourceBucket: data['resource_bucket'] as String? ?? 'tripo-data',
      resourceUri: data['resource_uri'] as String? ?? '',
      sessionToken: data['session_token'] as String? ?? '',
      stsAk: data['sts_ak'] as String? ?? '',
      stsSk: data['sts_sk'] as String? ?? '',
    );
  }

  static Future<String> _createImageToModelTask(
    String apiKey, {
    required String bucket,
    required String key,
    required String fileType,
    required int viewCount,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/task'),
      headers: _headers(apiKey),
      body: jsonEncode({
        'type': 'image_to_model',
        'model_version': _modelVersion,
        'file': {
          'type': fileType,
          'object': {
            'bucket': bucket,
            'key': key,
          },
        },
        ..._taskParams(viewCount: viewCount),
      }),
    );
    final body = _decodeResponse(response);
    final data = _dataMap(body);
    final taskId = data['task_id'] as String?;
    if (taskId == null || taskId.isEmpty) {
      throw TripoClientException('Tripo did not return a task id.');
    }
    return taskId;
  }

  static Future<String> _createMultiviewToModelTask(
    String apiKey,
    List<_UploadedTripoImage?> uploadedViews, {
    required Map<String, dynamic> taskParams,
  }) async {
    final files = <Map<String, dynamic>>[];
    for (final uploaded in uploadedViews) {
      if (uploaded == null) {
        files.add(<String, dynamic>{});
        continue;
      }
      files.add({
        'type': uploaded.fileType,
        'object': {
          'bucket': uploaded.bucket,
          'key': uploaded.key,
        },
      });
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/task'),
      headers: _headers(apiKey),
      body: jsonEncode({
        'type': 'multiview_to_model',
        'model_version': _modelVersion,
        'files': files,
        ...taskParams,
      }),
    );
    final body = _decodeResponse(response);
    final data = _dataMap(body);
    final taskId = data['task_id'] as String?;
    if (taskId == null || taskId.isEmpty) {
      throw TripoClientException('Tripo did not return a task id.');
    }
    return taskId;
  }

  static Future<String> _pollForModelUrl(
    Session session,
    String apiKey,
    String taskId,
  ) async {
    for (var attempt = 0; attempt < _maxPollAttempts; attempt++) {
      if (attempt > 0) {
        await Future<void>.delayed(_pollInterval);
      }

      final response = await http.get(
        Uri.parse('$_baseUrl/task/$taskId'),
        headers: _headers(apiKey),
      );
      final body = _decodeResponse(response);
      final data = _dataMap(body);
      final status = data['status'] as String? ?? 'unknown';
      final progress = data['progress'];

      if (progress != null) {
        session.log(
          'Tripo task $taskId: $status ($progress%)',
          level: LogLevel.info,
        );
      }

      switch (status) {
        case 'success':
          final consumed = data['consumed_credit'] ?? data['consumed_credits'];
          if (consumed != null) {
            session.log(
              'Tripo task $taskId consumed $consumed credits',
              level: LogLevel.info,
            );
          }
          final outputRaw = data['output'];
          final outputMap = outputRaw is Map
              ? Map<String, dynamic>.from(outputRaw)
              : <String, dynamic>{};
          final modelUrl = _pickModelUrl(outputMap);
          if (modelUrl == null || modelUrl.isEmpty) {
            throw TripoClientException(
              'Tripo task succeeded but no model URL was returned.',
            );
          }
          return modelUrl;
        case 'failed':
        case 'banned':
        case 'expired':
        case 'cancelled':
          final message = data['message'] as String? ?? status;
          throw TripoClientException('Tripo generation failed: $message');
        case 'queued':
        case 'running':
          continue;
        default:
          continue;
      }
    }

    throw TripoClientException(
      'Tripo generation timed out. Try again in a few minutes.',
    );
  }

  static String? _pickModelUrl(Map<String, dynamic> output) {
    // Prefer non-PBR textured model to keep photo-projected materials.
    for (final key in ['model', 'base_model']) {
      final url = _extractUrl(output[key]);
      if (url != null) return url;
    }
    return _extractUrl(output['pbr_model']);
  }

  static String? _extractUrl(dynamic value) {
    if (value is String && value.isNotEmpty) return value;
    if (value is Map) {
      for (final nestedKey in ['url', 'model_url', 'download_url']) {
        final nested = value[nestedKey];
        if (nested is String && nested.isNotEmpty) return nested;
      }
    }
    return null;
  }

  static String _stsFormatForImage(String imageFormat) {
    return switch (imageFormat) {
      'png' => 'png',
      'webp' => 'webp',
      _ => 'jpeg',
    };
  }

  /// Tripo task API expects `jpg` for JPEG inputs (not `jpeg`).
  static String _taskFileTypeForImage(String imageFormat) {
    return switch (imageFormat) {
      'png' => 'png',
      'webp' => 'webp',
      _ => 'jpg',
    };
  }

  static String _friendlyTripoError(dynamic code, String message) {
    return switch (code) {
      2010 =>
        'Tripo API credits are used up. Create a new free key at '
        'platform.tripo3d.ai/api-keys or add credits to your account.',
      1004 => 'Tripo API key is invalid. Check config/tripo_api_key.yaml.',
      _ => '$message (Tripo code: $code)',
    };
  }

  static Map<String, dynamic> _dataMap(Map<String, dynamic> body) {
    final raw = body['data'] ?? body;
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return {};
  }

  static Map<String, String> _headers(String apiKey) => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

  static Map<String, dynamic> _decodeResponse(http.Response response) {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw TripoClientException(
        'Tripo API error (${response.statusCode}): invalid response',
      );
    }

    final code = body['code'];
    if (code != null && code != 0) {
      final message = body['message'] as String? ?? 'Tripo API error';
      throw TripoClientException(_friendlyTripoError(code, message));
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final message = body['message'] as String? ?? response.body;
      throw TripoClientException(
        'Tripo API error (${response.statusCode}): $message',
      );
    }

    return body;
  }

  static String _contentTypeForFormat(String format) {
    return switch (format) {
      'png' => 'image/png',
      'webp' => 'image/webp',
      _ => 'image/jpeg',
    };
  }

  /// Detects Tripo image format from file bytes.
  static String? detectImageFormat(List<int> bytes) {
    if (bytes.length >= 3 &&
        bytes[0] == 0xFF &&
        bytes[1] == 0xD8 &&
        bytes[2] == 0xFF) {
      return 'jpeg';
    }
    if (bytes.length >= 4 &&
        bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return 'png';
    }
    if (bytes.length >= 12 &&
        bytes[0] == 0x52 &&
        bytes[1] == 0x49 &&
        bytes[2] == 0x46 &&
        bytes[3] == 0x46 &&
        bytes[8] == 0x57 &&
        bytes[9] == 0x45 &&
        bytes[10] == 0x42 &&
        bytes[11] == 0x50) {
      return 'webp';
    }
    return null;
  }
}

/// One image slot for Tripo multiview generation.
final class TripoViewImage {
  const TripoViewImage({
    required this.bytes,
    required this.format,
  });

  final List<int> bytes;
  final String format;
}

final class _UploadedTripoImage {
  const _UploadedTripoImage({
    required this.bucket,
    required this.key,
    required this.fileType,
  });

  final String bucket;
  final String key;
  final String fileType;
}

final class _StsCredentials {
  const _StsCredentials({
    required this.s3Host,
    required this.resourceBucket,
    required this.resourceUri,
    required this.sessionToken,
    required this.stsAk,
    required this.stsSk,
  });

  final String s3Host;
  final String resourceBucket;
  final String resourceUri;
  final String sessionToken;
  final String stsAk;
  final String stsSk;
}

final class TripoClientException implements Exception {
  TripoClientException(this.message);
  final String message;

  @override
  String toString() => message;
}
