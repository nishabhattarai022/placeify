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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'user_account_status.dart' as _i2;
import 'notification_preference.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// Full vendor shop profile returned to the Flutter vendor profile screen.
abstract class VendorProfileDetail implements _i1.SerializableModel {
  VendorProfileDetail._({
    required this.id,
    required this.businessName,
    required this.email,
    required this.phone,
    required this.address,
    required this.city,
    required this.country,
    required this.category,
    this.logoUrl,
    required this.bio,
    this.bannerUrl,
    this.coverUrl,
    required this.instagramHandle,
    required this.facebookHandle,
    required this.operatingHours,
    required this.isOpen,
    required this.status,
    this.moderationNote,
    this.appealMessage,
    this.appealSubmittedAt,
    required this.totalProducts,
    required this.totalOrders,
    required this.totalRevenue,
    this.notificationPreferences,
    required this.createdAt,
  });

  factory VendorProfileDetail({
    required _i1.UuidValue id,
    required String businessName,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String country,
    required String category,
    String? logoUrl,
    required String bio,
    String? bannerUrl,
    String? coverUrl,
    required String instagramHandle,
    required String facebookHandle,
    required String operatingHours,
    required bool isOpen,
    required _i2.UserAccountStatus status,
    String? moderationNote,
    String? appealMessage,
    DateTime? appealSubmittedAt,
    required int totalProducts,
    required int totalOrders,
    required double totalRevenue,
    _i3.NotificationPreference? notificationPreferences,
    required DateTime createdAt,
  }) = _VendorProfileDetailImpl;

  factory VendorProfileDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return VendorProfileDetail(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      businessName: jsonSerialization['businessName'] as String,
      email: jsonSerialization['email'] as String,
      phone: jsonSerialization['phone'] as String,
      address: jsonSerialization['address'] as String,
      city: jsonSerialization['city'] as String,
      country: jsonSerialization['country'] as String,
      category: jsonSerialization['category'] as String,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      bio: jsonSerialization['bio'] as String,
      bannerUrl: jsonSerialization['bannerUrl'] as String?,
      coverUrl: jsonSerialization['coverUrl'] as String?,
      instagramHandle: jsonSerialization['instagramHandle'] as String,
      facebookHandle: jsonSerialization['facebookHandle'] as String,
      operatingHours: jsonSerialization['operatingHours'] as String,
      isOpen: _i1.BoolJsonExtension.fromJson(jsonSerialization['isOpen']),
      status: _i2.UserAccountStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      moderationNote: jsonSerialization['moderationNote'] as String?,
      appealMessage: jsonSerialization['appealMessage'] as String?,
      appealSubmittedAt: jsonSerialization['appealSubmittedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['appealSubmittedAt'],
            ),
      totalProducts: jsonSerialization['totalProducts'] as int,
      totalOrders: jsonSerialization['totalOrders'] as int,
      totalRevenue: (jsonSerialization['totalRevenue'] as num).toDouble(),
      notificationPreferences:
          jsonSerialization['notificationPreferences'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.NotificationPreference>(
              jsonSerialization['notificationPreferences'],
            ),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  _i1.UuidValue id;

  String businessName;

  String email;

  String phone;

  String address;

  String city;

  String country;

  String category;

  String? logoUrl;

  String bio;

  String? bannerUrl;

  String? coverUrl;

  String instagramHandle;

  String facebookHandle;

  String operatingHours;

  bool isOpen;

  _i2.UserAccountStatus status;

  String? moderationNote;

  String? appealMessage;

  DateTime? appealSubmittedAt;

  int totalProducts;

  int totalOrders;

  double totalRevenue;

  _i3.NotificationPreference? notificationPreferences;

  DateTime createdAt;

  /// Returns a shallow copy of this [VendorProfileDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  VendorProfileDetail copyWith({
    _i1.UuidValue? id,
    String? businessName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? category,
    String? logoUrl,
    String? bio,
    String? bannerUrl,
    String? coverUrl,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
    bool? isOpen,
    _i2.UserAccountStatus? status,
    String? moderationNote,
    String? appealMessage,
    DateTime? appealSubmittedAt,
    int? totalProducts,
    int? totalOrders,
    double? totalRevenue,
    _i3.NotificationPreference? notificationPreferences,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VendorProfileDetail',
      'id': id.toJson(),
      'businessName': businessName,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'category': category,
      if (logoUrl != null) 'logoUrl': logoUrl,
      'bio': bio,
      if (bannerUrl != null) 'bannerUrl': bannerUrl,
      if (coverUrl != null) 'coverUrl': coverUrl,
      'instagramHandle': instagramHandle,
      'facebookHandle': facebookHandle,
      'operatingHours': operatingHours,
      'isOpen': isOpen,
      'status': status.toJson(),
      if (moderationNote != null) 'moderationNote': moderationNote,
      if (appealMessage != null) 'appealMessage': appealMessage,
      if (appealSubmittedAt != null)
        'appealSubmittedAt': appealSubmittedAt?.toJson(),
      'totalProducts': totalProducts,
      'totalOrders': totalOrders,
      'totalRevenue': totalRevenue,
      if (notificationPreferences != null)
        'notificationPreferences': notificationPreferences?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorProfileDetailImpl extends VendorProfileDetail {
  _VendorProfileDetailImpl({
    required _i1.UuidValue id,
    required String businessName,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String country,
    required String category,
    String? logoUrl,
    required String bio,
    String? bannerUrl,
    String? coverUrl,
    required String instagramHandle,
    required String facebookHandle,
    required String operatingHours,
    required bool isOpen,
    required _i2.UserAccountStatus status,
    String? moderationNote,
    String? appealMessage,
    DateTime? appealSubmittedAt,
    required int totalProducts,
    required int totalOrders,
    required double totalRevenue,
    _i3.NotificationPreference? notificationPreferences,
    required DateTime createdAt,
  }) : super._(
         id: id,
         businessName: businessName,
         email: email,
         phone: phone,
         address: address,
         city: city,
         country: country,
         category: category,
         logoUrl: logoUrl,
         bio: bio,
         bannerUrl: bannerUrl,
         coverUrl: coverUrl,
         instagramHandle: instagramHandle,
         facebookHandle: facebookHandle,
         operatingHours: operatingHours,
         isOpen: isOpen,
         status: status,
         moderationNote: moderationNote,
         appealMessage: appealMessage,
         appealSubmittedAt: appealSubmittedAt,
         totalProducts: totalProducts,
         totalOrders: totalOrders,
         totalRevenue: totalRevenue,
         notificationPreferences: notificationPreferences,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [VendorProfileDetail]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  VendorProfileDetail copyWith({
    _i1.UuidValue? id,
    String? businessName,
    String? email,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? category,
    Object? logoUrl = _Undefined,
    String? bio,
    Object? bannerUrl = _Undefined,
    Object? coverUrl = _Undefined,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
    bool? isOpen,
    _i2.UserAccountStatus? status,
    Object? moderationNote = _Undefined,
    Object? appealMessage = _Undefined,
    Object? appealSubmittedAt = _Undefined,
    int? totalProducts,
    int? totalOrders,
    double? totalRevenue,
    Object? notificationPreferences = _Undefined,
    DateTime? createdAt,
  }) {
    return VendorProfileDetail(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      city: city ?? this.city,
      country: country ?? this.country,
      category: category ?? this.category,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      bio: bio ?? this.bio,
      bannerUrl: bannerUrl is String? ? bannerUrl : this.bannerUrl,
      coverUrl: coverUrl is String? ? coverUrl : this.coverUrl,
      instagramHandle: instagramHandle ?? this.instagramHandle,
      facebookHandle: facebookHandle ?? this.facebookHandle,
      operatingHours: operatingHours ?? this.operatingHours,
      isOpen: isOpen ?? this.isOpen,
      status: status ?? this.status,
      moderationNote: moderationNote is String?
          ? moderationNote
          : this.moderationNote,
      appealMessage: appealMessage is String?
          ? appealMessage
          : this.appealMessage,
      appealSubmittedAt: appealSubmittedAt is DateTime?
          ? appealSubmittedAt
          : this.appealSubmittedAt,
      totalProducts: totalProducts ?? this.totalProducts,
      totalOrders: totalOrders ?? this.totalOrders,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      notificationPreferences:
          notificationPreferences is _i3.NotificationPreference?
          ? notificationPreferences
          : this.notificationPreferences?.copyWith(),
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
