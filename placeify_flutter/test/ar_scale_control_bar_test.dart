import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/features/home/domain/models/product.dart';
import 'package:placeify_flutter/features/product_detail/presentation/widgets/ar_placement_controls.dart';

void main() {
  testWidgets('shows dimensions adjusted by the selected AR scale', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ArScaleControlBar(
            dimensions: const ProductDimensions(
              widthCm: 60,
              depthCm: 40,
              heightCm: 80,
            ),
            scaleMultiplier: 1.25,
            minMultiplier: 0.5,
            maxMultiplier: 2,
            onScaleChanged: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('125%'), findsOneWidget);
    expect(
      find.text('Approx. size · W 75 × D 50 × H 100 cm'),
      findsOneWidget,
    );
  });
}
