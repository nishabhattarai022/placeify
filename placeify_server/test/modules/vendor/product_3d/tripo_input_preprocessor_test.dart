import 'package:image/image.dart' as img;
import 'package:test/test.dart';

import 'package:placeify_server/src/modules/vendor/product_3d/tripo_input_preprocessor.dart';

void main() {
  group('TripoInputPreprocessor.normalizeExposureAcrossViews', () {
    test('pulls darker side views toward front reference luminance', () {
      final front = _solidSubjectImage(
        subjectColor: img.ColorRgb8(120, 110, 100),
      );
      final left = _solidSubjectImage(
        subjectColor: img.ColorRgb8(80, 70, 60),
      );

      final preprocessor = TripoInputPreprocessor();
      final normalized = preprocessor.normalizeExposureAcrossViews(
        [front, left],
        viewLabels: ['front', 'left'],
      );

      final originalLeft = _meanSubjectLuminance(left);
      final frontStats = _meanSubjectLuminance(normalized[0]);
      final leftStats = _meanSubjectLuminance(normalized[1]);

      expect(leftStats, greaterThan(originalLeft));
      expect(
        (leftStats - frontStats).abs(),
        lessThan((frontStats - originalLeft).abs()),
      );
    });

    test('clamps extreme correction to ±40%', () {
      final front = _solidSubjectImage(
        subjectColor: img.ColorRgb8(200, 200, 200),
      );
      final right = _solidSubjectImage(
        subjectColor: img.ColorRgb8(40, 40, 40),
      );

      final preprocessor = TripoInputPreprocessor();
      final normalized = preprocessor.normalizeExposureAcrossViews(
        [front, right],
        viewLabels: ['front', 'right'],
      );

      final adjusted = _meanSubjectLuminance(normalized[1]);
      final uncorrectedTarget = _meanSubjectLuminance(right) *
          (200 / 40); // would be 5× without clamp
      expect(adjusted, lessThan(uncorrectedTarget));
      expect(adjusted, greaterThan(_meanSubjectLuminance(right) * 1.35));
    });
  });
}

img.Image _solidSubjectImage({required img.ColorRgb8 subjectColor}) {
  final image = img.Image(width: 120, height: 120);
  img.fill(image, color: img.ColorRgb8(255, 255, 255));
  for (var y = 30; y < 90; y++) {
    for (var x = 30; x < 90; x++) {
      image.setPixelRgb(x, y, subjectColor.r, subjectColor.g, subjectColor.b);
    }
  }
  return image;
}

double _meanSubjectLuminance(img.Image image) {
  var sum = 0.0;
  var count = 0;
  for (var y = 0; y < image.height; y++) {
    for (var x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      if (pixel.r > 245 && pixel.g > 245 && pixel.b > 245) continue;
      final r = pixel.r.toDouble();
      final g = pixel.g.toDouble();
      final b = pixel.b.toDouble();
      sum += (0.299 * r) + (0.587 * g) + (0.114 * b);
      count++;
    }
  }
  return count == 0 ? 0 : sum / count;
}
