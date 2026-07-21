import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/cart/data/product_id_codec.dart';
import 'package:placeify_flutter/features/home/presentation/providers/catalog_provider.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_product.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_products_provider.dart';

/// Listens for background Tripo completion and shows an in-app banner.
///
/// Mount under the vendor shell so the toast still appears after leaving
/// Build 3D (and after logout/login as vendor — notifications are user-scoped).
class VendorModel3dNotificationListener extends ConsumerStatefulWidget {
  const VendorModel3dNotificationListener({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  ConsumerState<VendorModel3dNotificationListener> createState() =>
      _VendorModel3dNotificationListenerState();
}

class _VendorModel3dNotificationListenerState
    extends ConsumerState<VendorModel3dNotificationListener> {
  StreamSubscription<InAppNotificationSummary>? _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = inAppNotificationEvents.listen(_onNotification);
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  bool get _isApprovedVendor {
    final user = ref.read(currentUserProvider).value;
    return user?.vendorStatus == VendorStatus.approved;
  }

  Future<void> _onNotification(InAppNotificationSummary notification) async {
    if (notification.type != InAppNotificationType.productUpdate) return;
    if (!_isApprovedVendor) return;

    final title = notification.title.trim();
    final isModelReady = title == '3D model ready';
    final isModelFailed = title == '3D model failed';
    if (!isModelReady && !isModelFailed) return;

    await ref.read(vendorProductsProvider.notifier).refresh();

    if (isModelReady) {
      await _syncReadyProductToCustomerCatalog(notification.referenceId);
    }

    if (!mounted) return;
    final message = notification.message.trim().isNotEmpty
        ? notification.message.trim()
        : title;
    PlaceifyToast.show(context, message);
  }

  Future<void> _syncReadyProductToCustomerCatalog(int? databaseProductId) async {
    if (databaseProductId == null) {
      await refreshCustomerCatalogFromWidget(ref);
      return;
    }

    final uiId = ProductIdCodec.fromDatabaseId(databaseProductId);
    final products = ref.read(vendorProductsProvider).value;
    VendorProduct? readyProduct;
    if (products != null) {
      for (final product in products) {
        if (product.id == uiId) {
          readyProduct = product;
          break;
        }
      }
    }

    if (readyProduct != null && readyProduct.model3dStatus == 'ready') {
      try {
        await publishProductToCustomerCatalogFromWidget(ref, readyProduct);
        return;
      } catch (_) {
        // Fall back to a full catalog refresh below.
      }
    }

    await refreshCustomerCatalogFromWidget(ref);
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
