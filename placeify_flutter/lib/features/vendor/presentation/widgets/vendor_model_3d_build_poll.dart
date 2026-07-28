import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:placeify_flutter/features/vendor/data/vendor_3d_model_store.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_products_provider.dart';

/// Polls the server while any vendor product has [model3dStatus] `building`.
///
/// Tripo runs in a server FutureCall, so the Build 3D screen returns before
/// the GLB is ready. This keeps [Vendor3dModelStore] and [vendorProductsProvider]
/// in sync when push notifications are delayed or missed.
class VendorModel3dBuildPoll extends ConsumerStatefulWidget {
  const VendorModel3dBuildPoll({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  ConsumerState<VendorModel3dBuildPoll> createState() =>
      _VendorModel3dBuildPollState();
}

class _VendorModel3dBuildPollState extends ConsumerState<VendorModel3dBuildPoll> {
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _hasBuildingProduct(List<VendorProduct> products) {
    for (final product in products) {
      if (product.model3dStatus == 'building') return true;
    }
    return false;
  }

  void _syncLocalStore(List<VendorProduct> products) {
    for (final product in products) {
      switch (product.model3dStatus) {
        case 'ready':
          Vendor3dModelStore.preloadFromProduct(product);
        case 'failed':
          Vendor3dModelStore.markFailed(
            product.id,
            product.model3dError.trim().isEmpty
                ? '3D generation failed. Try again.'
                : product.model3dError.trim(),
          );
        case 'building':
          Vendor3dModelStore.markProcessing(product.id);
        default:
          break;
      }
    }
  }

  void _configurePolling(List<VendorProduct> products) {
    _syncLocalStore(products);

    if (!_hasBuildingProduct(products)) {
      _timer?.cancel();
      _timer = null;
      return;
    }

    if (_timer != null) return;

    _timer = Timer.periodic(const Duration(seconds: 8), (_) async {
      await ref.read(vendorProductsProvider.notifier).refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<List<VendorProduct>>>(
      vendorProductsProvider,
      (_, next) {
        next.whenData(_configurePolling);
      },
    );

    final products = ref.watch(vendorProductsProvider).value;
    if (products != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _configurePolling(products);
      });
    }

    return widget.child;
  }
}
