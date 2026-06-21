/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:placeify_server/src/generated/protocol.dart' as _i2;

/// Public shop card shown in consumer shop discovery.
abstract class ShopListingSummary
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ShopListingSummary._({
    required this.vendorId,
    required this.businessName,
    required this.locality,
    required this.tags,
    this.logoUrl,
    this.bannerUrl,
    required this.productCount,
    required this.averageRating,
  });

  factory ShopListingSummary({
    required _i1.UuidValue vendorId,
    required String businessName,
    required String locality,
    required List<String> tags,
    String? logoUrl,
    String? bannerUrl,
    required int productCount,
    required double averageRating,
  }) = _ShopListingSummaryImpl;

  factory ShopListingSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return ShopListingSummary(
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      businessName: jsonSerialization['businessName'] as String,
      locality: jsonSerialization['locality'] as String,
      tags: _i2.Protocol().deserialize<List<String>>(jsonSerialization['tags']),
      logoUrl: jsonSerialization['logoUrl'] as String?,
      bannerUrl: jsonSerialization['bannerUrl'] as String?,
      productCount: jsonSerialization['productCount'] as int,
      averageRating: (jsonSerialization['averageRating'] as num).toDouble(),
    );
  }

  _i1.UuidValue vendorId;

  String businessName;

  String locality;

  List<String> tags;

  String? logoUrl;

  String? bannerUrl;

  int productCount;

  double averageRating;

  /// Returns a shallow copy of this [ShopListingSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ShopListingSummary copyWith({
    _i1.UuidValue? vendorId,
    String? businessName,
    String? locality,
    List<String>? tags,
    String? logoUrl,
    String? bannerUrl,
    int? productCount,
    double? averageRating,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ShopListingSummary',
      'vendorId': vendorId.toJson(),
      'businessName': businessName,
      'locality': locality,
      'tags': tags.toJson(),
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (bannerUrl != null) 'bannerUrl': bannerUrl,
      'productCount': productCount,
      'averageRating': averageRating,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ShopListingSummary',
      'vendorId': vendorId.toJson(),
      'businessName': businessName,
      'locality': locality,
      'tags': tags.toJson(),
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (bannerUrl != null) 'bannerUrl': bannerUrl,
      'productCount': productCount,
      'averageRating': averageRating,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShopListingSummaryImpl extends ShopListingSummary {
  _ShopListingSummaryImpl({
    required _i1.UuidValue vendorId,
    required String businessName,
    required String locality,
    required List<String> tags,
    String? logoUrl,
    String? bannerUrl,
    required int productCount,
    required double averageRating,
  }) : super._(
         vendorId: vendorId,
         businessName: businessName,
         locality: locality,
         tags: tags,
         logoUrl: logoUrl,
         bannerUrl: bannerUrl,
         productCount: productCount,
         averageRating: averageRating,
       );

  /// Returns a shallow copy of this [ShopListingSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ShopListingSummary copyWith({
    _i1.UuidValue? vendorId,
    String? businessName,
    String? locality,
    List<String>? tags,
    Object? logoUrl = _Undefined,
    Object? bannerUrl = _Undefined,
    int? productCount,
    double? averageRating,
  }) {
    return ShopListingSummary(
      vendorId: vendorId ?? this.vendorId,
      businessName: businessName ?? this.businessName,
      locality: locality ?? this.locality,
      tags: tags ?? this.tags.map((e0) => e0).toList(),
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      bannerUrl: bannerUrl is String? ? bannerUrl : this.bannerUrl,
      productCount: productCount ?? this.productCount,
      averageRating: averageRating ?? this.averageRating,
    );
  }
}
