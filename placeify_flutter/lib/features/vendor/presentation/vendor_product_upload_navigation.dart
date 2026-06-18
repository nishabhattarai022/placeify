import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/toast_overlay.dart';
import '../domain/constants/vendor_routes.dart';
import '../domain/constants/vendor_strings.dart';

/// Opens the product upload form and shows a success toast when upload completes.
Future<void> openVendorProductUpload(BuildContext context) async {
  final uploaded = await context.push<bool>(VendorRoutes.productsUpload);
  if (!context.mounted) return;
  if (uploaded == true) {
    PlaceifyToast.show(context, VendorStrings.productUploaded);
  }
}
