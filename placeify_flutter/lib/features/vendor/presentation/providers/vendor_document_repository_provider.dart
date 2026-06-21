import 'package:placeify_flutter/features/vendor/data/serverpod_vendor_document_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_document_repository_provider.g.dart';

@Riverpod(keepAlive: true)
ServerpodVendorDocumentRepository vendorDocumentRepository(Ref ref) {
  return const ServerpodVendorDocumentRepository();
}
