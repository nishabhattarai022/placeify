import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/features/home/data/catalog_demo_image_catalog.dart';
import 'package:placeify_flutter/features/home/data/catalog_image_resolver.dart';
import 'package:placeify_flutter/features/home/data/mock_product_repository.dart';
import 'package:placeify_flutter/features/shops/data/vendor_product_mapper.dart';

void main() {
  test('mock product images are unique across the generated set', () {
    final urls = MockProductRepository.mockProductImageUrls();
    expect(urls, isNotEmpty);
    expect(urls.toSet().length, urls.length);
  });

  test('catalog demo image pool supports a 20-item unique generation', () {
    final images = CatalogDemoImageCatalog.uniqueImagesForCount(20);
    expect(images.length, 20);
    expect(images.toSet().length, 20);
  });

  test('vendor fallback varies by product id within the same category', () {
    final a = VendorProductMapper.fallbackImageForCategory(
      'chairs',
      productId: 'sku-a',
    );
    final b = VendorProductMapper.fallbackImageForCategory(
      'chairs',
      productId: 'sku-b',
    );
    // With a multi-image pool, different ids should not always collide.
    // Probe several pairs until we observe a difference.
    var foundDifference = a != b;
    if (!foundDifference) {
      for (var i = 0; i < 40; i++) {
        final left = VendorProductMapper.fallbackImageForCategory(
          'chairs',
          productId: 'chair-$i',
        );
        final right = VendorProductMapper.fallbackImageForCategory(
          'chairs',
          productId: 'chair-${i + 17}',
        );
        if (left != right) {
          foundDifference = true;
          break;
        }
      }
    }
    expect(foundDifference, isTrue);
  });

  test('catalog product fallback varies by product id within category', () {
    final a = CatalogImageResolver.fallbackForProduct(
      categoryId: 'chairs',
      productId: '101',
      productName: 'Alpha Chair',
    );
    final b = CatalogImageResolver.fallbackForProduct(
      categoryId: 'chairs',
      productId: '202',
      productName: 'Beta Chair',
    );
    expect(a, isNot(equals(b)));
  });

  test('name fallback disambiguates duplicate product names by id', () {
    final a = CatalogDemoImageCatalog.imageForName(
      'Harmony Chair',
      productId: 'p4',
    );
    final b = CatalogDemoImageCatalog.imageForName(
      'Harmony Chair',
      productId: 'p99',
    );
    expect(a, isNot(equals(b)));
  });

  test('harmony and harmony chair resolve to different fallbacks', () {
    final harmonyChair = CatalogDemoImageCatalog.imageForName(
      'Harmony Chair',
      productId: 'p4',
    );
    final harmony = CatalogDemoImageCatalog.imageForName(
      'Harmony',
      productId: 'p4',
    );
    expect(harmonyChair, isNotNull);
    expect(harmony, isNotNull);
    expect(harmonyChair, isNot(equals(harmony)));
  });
}
