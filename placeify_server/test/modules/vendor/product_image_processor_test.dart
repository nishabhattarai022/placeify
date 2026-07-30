import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'package:placeify_server/src/modules/vendor/product_image_processor.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

void main() {
  final session = _FakeSession();
  group('ProcessedProductImage', () {
    test('stores extension and flag', () {
      final result = ProcessedProductImage(
        bytes: Uint8List(0),
        extension: '.jpg',
        backgroundRemoved: true,
      );
      expect(result.extension, '.jpg');
      expect(result.backgroundRemoved, isTrue);
    });
  });

  group('ProductImageProcessor background removal', () {
    test('uses product mode only and never retries with auto', () async {
      final inputJpeg = _minimalJpeg();
      final cutoutPng = _minimalCutoutPng();
      final requestedTypes = <String>[];

      final processor = ProductImageProcessor(
        httpClient: _RecordingRemoveBgClient(
          onRequest: (fields) {
            requestedTypes.add(fields['type'] ?? '');
            if (fields['type'] == 'product') {
              return http.Response.bytes(cutoutPng, 200);
            }
            return http.Response(
              jsonEncode({
                'errors': [
                  {'title': 'Could not identify foreground'},
                ],
              }),
              400,
              headers: {'content-type': 'application/json'},
            );
          },
        ),
        apiKeyOverride: 'test-key',
      );

      final result = await processor.processForVendorUpload(
        session,
        inputJpeg,
        'chair_front.jpg',
        fileExtension: '.jpg',
      );

      expect(requestedTypes, ['product']);
      expect(result.catalog.backgroundRemoved, isTrue);
      expect(result.tripoSource.backgroundRemoved, isFalse);
    });

    test('falls back to original catalog when product segmentation fails', () async {
      final inputJpeg = _minimalJpeg();

      final processor = ProductImageProcessor(
        httpClient: _RecordingRemoveBgClient(
          onRequest: (_) => http.Response(
            jsonEncode({
              'errors': [
                {'title': 'Could not identify foreground'},
              ],
            }),
            422,
            headers: {'content-type': 'application/json'},
          ),
        ),
        apiKeyOverride: 'test-key',
      );

      final result = await processor.processForVendorUpload(
        session,
        inputJpeg,
        'chair_left.jpg',
        fileExtension: '.jpg',
      );

      expect(result.catalog.backgroundRemoved, isFalse);
      expect(result.tripoSource.bytes, inputJpeg);
    });

    test('remove.bg request keeps product settings for furniture photos', () async {
      final inputJpeg = _minimalJpeg();
      final cutoutPng = _minimalCutoutPng();
      Map<String, String>? capturedFields;

      final processor = ProductImageProcessor(
        httpClient: _RecordingRemoveBgClient(
          onRequest: (fields) {
            capturedFields = fields;
            return http.Response.bytes(cutoutPng, 200);
          },
        ),
        apiKeyOverride: 'test-key',
      );

      await processor.processForVendorUpload(
        session,
        inputJpeg,
        'chair.jpg',
        fileExtension: '.jpg',
      );

      expect(capturedFields, isNotNull);
      expect(capturedFields!['type'], 'product');
      expect(capturedFields!['crop'], 'false');
      expect(capturedFields!['semitransparency'], 'true');
      expect(capturedFields!.containsKey('bg_color'), isFalse);
    });
  });
}

Uint8List _minimalJpeg() {
  final image = img.Image(width: 8, height: 8);
  img.fill(image, color: img.ColorRgb8(240, 240, 240));
  for (var y = 2; y < 6; y++) {
    for (var x = 2; x < 6; x++) {
      image.setPixelRgb(x, y, 20, 30, 180);
    }
  }
  return Uint8List.fromList(img.encodeJpg(image));
}

Uint8List _minimalCutoutPng() {
  final image = img.Image(width: 8, height: 8);
  img.fill(image, color: img.ColorRgba8(255, 255, 255, 0));
  for (var y = 2; y < 6; y++) {
    for (var x = 2; x < 6; x++) {
      image.setPixelRgba(x, y, 20, 30, 180, 255);
    }
  }
  return Uint8List.fromList(img.encodePng(image));
}

class _RecordingRemoveBgClient extends http.BaseClient {
  _RecordingRemoveBgClient({required this.onRequest});

  final http.Response Function(Map<String, String> fields) onRequest;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final fields = <String, String>{};
    if (request is http.MultipartRequest) {
      fields.addAll(request.fields);
    }

    final response = onRequest(fields);
    return http.StreamedResponse(
      Stream.value(response.bodyBytes),
      response.statusCode,
      headers: response.headers,
    );
  }
}

class _FakeSession implements Session {
  @override
  dynamic noSuchMethod(Invocation invocation) => null;
}
