import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

/// Minimal AWS SigV4 PUT for Tripo STS uploads (us-west-2).
abstract final class AwsS3Put {
  static Future<void> upload({
    required String accessKey,
    required String secretKey,
    required String sessionToken,
    required String bucket,
    required String key,
    required String host,
    required List<int> body,
    required String contentType,
  }) async {
    const region = 'us-west-2';
    const service = 's3';
    final now = DateTime.now().toUtc();
    final dateStamp = _formatDate(now);
    final amzDate = '${dateStamp}T${_formatTime(now)}Z';
    final payloadHash = sha256.convert(body).toString();

    final normalizedKey = key.startsWith('/') ? key.substring(1) : key;
    final canonicalUri = _canonicalUri(normalizedKey);
    final hostHeader = '$bucket.$host';

    final canonicalHeaders = [
      'content-type:$contentType',
      'host:$hostHeader',
      'x-amz-content-sha256:$payloadHash',
      'x-amz-date:$amzDate',
      'x-amz-security-token:$sessionToken',
    ].join('\n');

    final signedHeaders =
        'content-type;host;x-amz-content-sha256;x-amz-date;x-amz-security-token';

    final canonicalRequest = [
      'PUT',
      canonicalUri,
      '',
      '$canonicalHeaders\n',
      signedHeaders,
      payloadHash,
    ].join('\n');

    final credentialScope = '$dateStamp/$region/$service/aws4_request';
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      credentialScope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');

    final signingKey = _signingKey(secretKey, dateStamp, region, service);
    final signature = Hmac(sha256, signingKey)
        .convert(utf8.encode(stringToSign))
        .toString();

    final authorization = [
      'AWS4-HMAC-SHA256 Credential=$accessKey/$credentialScope,',
      'SignedHeaders=$signedHeaders,',
      'Signature=$signature',
    ].join(' ');

    final url = Uri.https(hostHeader, normalizedKey);
    final response = await http.put(
      url,
      headers: {
        'Content-Type': contentType,
        'Host': hostHeader,
        'x-amz-content-sha256': payloadHash,
        'x-amz-date': amzDate,
        'x-amz-security-token': sessionToken,
        'Authorization': authorization,
      },
      body: body,
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AwsS3PutException(
        'S3 upload failed (${response.statusCode}): ${response.body}',
      );
    }
  }

  static List<int> _signingKey(
    String secretKey,
    String dateStamp,
    String region,
    String service,
  ) {
    List<int> key = utf8.encode('AWS4$secretKey');
    for (final data in [dateStamp, region, service, 'aws4_request']) {
      key = Hmac(sha256, key).convert(utf8.encode(data)).bytes;
    }
    return key;
  }

  static String _formatDate(DateTime dt) {
    return '${dt.year.toString().padLeft(4, '0')}'
        '${dt.month.toString().padLeft(2, '0')}'
        '${dt.day.toString().padLeft(2, '0')}';
  }

  static String _formatTime(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}'
        '${dt.minute.toString().padLeft(2, '0')}'
        '${dt.second.toString().padLeft(2, '0')}';
  }

  /// AWS SigV4: encode each path segment, keep `/` between segments.
  static String _canonicalUri(String key) {
    if (key.isEmpty) return '/';
    final segments = key.split('/');
    return '/${segments.map((s) => _uriEncode(s)).join('/')}';
  }

  static String _uriEncode(String input) {
    final buffer = StringBuffer();
    for (final unit in input.codeUnits) {
      final char = String.fromCharCode(unit);
      if ((unit >= 0x41 && unit <= 0x5A) ||
          (unit >= 0x61 && unit <= 0x7A) ||
          (unit >= 0x30 && unit <= 0x39) ||
          unit == 0x2D ||
          unit == 0x2E ||
          unit == 0x5F ||
          unit == 0x7E) {
        buffer.write(char);
      } else {
        buffer
          ..write('%')
          ..write(unit.toRadixString(16).toUpperCase().padLeft(2, '0'));
      }
    }
    return buffer.toString();
  }
}

final class AwsS3PutException implements Exception {
  AwsS3PutException(this.message);
  final String message;

  @override
  String toString() => message;
}
