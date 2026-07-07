import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/constants/vendor_routes.dart';
import '../domain/models/vendor_product.dart';
import 'providers/vendor_product_form_provider.dart';
import 'providers/vendor_products_provider.dart';
import 'widgets/build_3d_model_prompt_dialog.dart';

/// Guards vendor 3D / AR features until a product has a built model.
abstract final class Vendor3dModelAccess {
  /// `hasArView` is set when the server has a `model3dUrl` for the product.
  static bool hasBuiltModel(VendorProduct product) => product.hasArView;

  /// After a new product is saved without a 3D model, offer to open the builder.
  static Future<void> promptAfterProductSaved({
    required BuildContext context,
    required WidgetRef ref,
    required VendorProduct product,
  }) {
    if (hasBuiltModel(product)) return Future.value();
    return requestAccess(
      context: context,
      ref: ref,
      productId: product.id,
      hasModel: false,
      onAllowed: () {},
      message:
          'Your product was saved without a 3D model. Build one so customers '
          'can preview it in AR.',
    );
  }

  /// Shows [BuildModelPromptDialog] when no model exists; otherwise runs
  /// [onAllowed] (typically opens the 3D builder).
  static Future<void> requestAccess({
    required BuildContext context,
    required WidgetRef ref,
    required String productId,
    required bool hasModel,
    required VoidCallback onAllowed,
    String? message,
  }) async {
    if (hasModel) {
      onAllowed();
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => BuildModelPromptDialog(
        productId: productId,
        message: message,
        onBuildNow: () {
          Navigator.pop(dialogContext);
          unawaited(openBuilder(context, ref, productId));
        },
        onDismiss: () => Navigator.pop(dialogContext),
      ),
    );
  }

  /// Navigates to the 3D builder and refreshes product data on return.
  static Future<void> openBuilder(
    BuildContext context,
    WidgetRef ref,
    String productId,
  ) async {
    await context.push(VendorRoutes.productsBuild3dFor(productId));
    if (!context.mounted) return;

    await ref.read(vendorProductsProvider.notifier).refresh();
    await ref
        .read(vendorProductFormProvider.notifier)
        .prepareForRoute(productId: productId, forceReload: true);
  }
}
