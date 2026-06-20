import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_registration.freezed.dart';
part 'vendor_registration.g.dart';

/// Step 1 — business identity and contact details.
@freezed
abstract class VendorBusinessInfo with _$VendorBusinessInfo {
  const factory VendorBusinessInfo({
    @Default('') String businessName,
    @Default('') String contactName,
    @Default('') String email,
    @Default('') String phone,
    @Default('') String taxId,
  }) = _VendorBusinessInfo;

  factory VendorBusinessInfo.fromJson(Map<String, dynamic> json) =>
      _$VendorBusinessInfoFromJson(json);
}

/// Step 2 — store / warehouse address.
@freezed
abstract class VendorAddress with _$VendorAddress {
  const factory VendorAddress({
    @Default('') String street,
    @Default('') String city,
    @Default('') String state,
    @Default('') String postalCode,
    @Default('') String country,
  }) = _VendorAddress;

  factory VendorAddress.fromJson(Map<String, dynamic> json) =>
      _$VendorAddressFromJson(json);
}

/// Step 3 — product categories and optional description.
@Freezed(fromJson: false, toJson: false)
abstract class VendorCategoryInfo with _$VendorCategoryInfo {
  const factory VendorCategoryInfo({
    @Default([]) List<String> categories,
    @Default('') String description,
  }) = _VendorCategoryInfo;

  factory VendorCategoryInfo.fromJson(Map<String, dynamic> json) {
    final raw = json['categories'];
    final categories = raw is List
        ? raw
            .map((e) => e.toString().trim())
            .where((name) => name.isNotEmpty)
            .toList()
        : <String>[];
    if (categories.isEmpty) {
      final legacy = json['category'] as String? ?? '';
      if (legacy.trim().isNotEmpty) {
        categories.add(legacy.trim());
      }
    }
    return VendorCategoryInfo(
      categories: categories,
      description: json['description'] as String? ?? '',
    );
  }

  @override
  Map<String, dynamic> toJson() => {
        'categories': categories,
        'description': description,
      };
}

extension VendorCategoryInfoX on VendorCategoryInfo {
  String get categoriesLabel => categories.join(', ');
}

/// Step 4 — uploaded document local paths (mock; real API would use remote URLs).
@freezed
abstract class VendorDocuments with _$VendorDocuments {
  const factory VendorDocuments({
    String? businessLicensePath,
    String? governmentIdPath,
    String? taxCertificatePath,
  }) = _VendorDocuments;

  factory VendorDocuments.fromJson(Map<String, dynamic> json) =>
      _$VendorDocumentsFromJson(json);
}

/// Step 5 — payout bank account details.
@freezed
abstract class VendorBankDetails with _$VendorBankDetails {
  const factory VendorBankDetails({
    @Default('') String accountHolderName,
    @Default('') String bankName,
    @Default('') String accountNumber,
    @Default('') String routingNumber,
  }) = _VendorBankDetails;

  factory VendorBankDetails.fromJson(Map<String, dynamic> json) =>
      _$VendorBankDetailsFromJson(json);
}

/// Aggregate registration form state persisted across the multi-step flow.
@freezed
abstract class VendorRegistration with _$VendorRegistration {
  const factory VendorRegistration({
    @Default(VendorBusinessInfo()) VendorBusinessInfo business,
    @Default(VendorAddress()) VendorAddress address,
    @Default(VendorCategoryInfo()) VendorCategoryInfo category,
    @Default(VendorDocuments()) VendorDocuments documents,
    @Default(VendorBankDetails()) VendorBankDetails bank,
  }) = _VendorRegistration;

  factory VendorRegistration.fromJson(Map<String, dynamic> json) =>
      _$VendorRegistrationFromJson(json);
}
