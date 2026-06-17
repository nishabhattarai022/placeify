import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/toast_overlay.dart';
import '../domain/constants/vendor_routes.dart';
import '../domain/constants/vendor_strings.dart';

/// Opens the multiview product upload form (5–6 photos + Tripo 3D pipeline).
Future<void> openVendorProductUpload(BuildContext context) async {
  final uploaded = await context.push<bool>(VendorRoutes.productsUpload3d);
  if (!context.mounted) return;
  if (uploaded == true) {
    PlaceifyToast.show(context, VendorStrings.productUploaded);
  }
}
