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
import 'user.dart' as _i2;
import 'admin.dart' as _i3;
import 'package:placeify_client/src/protocol/protocol.dart' as _i4;

/// VendorProfile — vendor-specific data linked 1:1 to a User account.
abstract class Vendor implements _i1.SerializableModel {
  Vendor._({
    this.id,
    required this.userId,
    this.user,
    required this.shopName,
    this.description,
    this.businessAddress,
    this.city,
    this.country,
    this.shopCategory,
    this.contactEmail,
    this.logoUrl,
    this.bannerUrl,
    this.coverUrl,
    bool? isOpen,
    this.instagramHandle,
    this.facebookHandle,
    this.operatingHours,
    double? rating,
    this.approvedById,
    this.approvedBy,
    this.approvedAt,
    this.moderationNote,
    this.moderatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : isOpen = isOpen ?? true,
       rating = rating ?? 0.0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Vendor({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String shopName,
    String? description,
    String? businessAddress,
    String? city,
    String? country,
    String? shopCategory,
    String? contactEmail,
    String? logoUrl,
    String? bannerUrl,
    String? coverUrl,
    bool? isOpen,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
    double? rating,
    _i1.UuidValue? approvedById,
    _i3.Admin? approvedBy,
    DateTime? approvedAt,
    String? moderationNote,
    DateTime? moderatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _VendorImpl;

  factory Vendor.fromJson(Map<String, dynamic> jsonSerialization) {
    return Vendor(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      shopName: jsonSerialization['shopName'] as String,
      description: jsonSerialization['description'] as String?,
      businessAddress: jsonSerialization['businessAddress'] as String?,
      city: jsonSerialization['city'] as String?,
      country: jsonSerialization['country'] as String?,
      shopCategory: jsonSerialization['shopCategory'] as String?,
      contactEmail: jsonSerialization['contactEmail'] as String?,
      logoUrl: jsonSerialization['logoUrl'] as String?,
      bannerUrl: jsonSerialization['bannerUrl'] as String?,
      coverUrl: jsonSerialization['coverUrl'] as String?,
      isOpen: jsonSerialization['isOpen'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isOpen']),
      instagramHandle: jsonSerialization['instagramHandle'] as String?,
      facebookHandle: jsonSerialization['facebookHandle'] as String?,
      operatingHours: jsonSerialization['operatingHours'] as String?,
      rating: (jsonSerialization['rating'] as num?)?.toDouble(),
      approvedById: jsonSerialization['approvedById'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['approvedById'],
            ),
      approvedBy: jsonSerialization['approvedBy'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.Admin>(
              jsonSerialization['approvedBy'],
            ),
      approvedAt: jsonSerialization['approvedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['approvedAt']),
      moderationNote: jsonSerialization['moderationNote'] as String?,
      moderatedAt: jsonSerialization['moderatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['moderatedAt'],
            ),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue userId;

  _i2.User? user;

  String shopName;

  String? description;

  String? businessAddress;

  String? city;

  String? country;

  /// Vendor business type (e.g. furniture, decor) — not product Category.
  /// Multiple categories are stored as a JSON array string for backward compatibility.
  String? shopCategory;

  /// Shop contact email from vendor registration or profile edits.
  String? contactEmail;

  String? logoUrl;

  String? bannerUrl;

  String? coverUrl;

  /// Manual store open/closed toggle (independent of weekly schedule).
  bool isOpen;

  String? instagramHandle;

  String? facebookHandle;

  String? operatingHours;

  double rating;

  _i1.UuidValue? approvedById;

  /// Admin who approved this vendor shop.
  _i3.Admin? approvedBy;

  DateTime? approvedAt;

  /// Admin suspend reason or reinstate terms note.
  String? moderationNote;

  /// When the vendor was last suspended or reinstated by admin.
  DateTime? moderatedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Vendor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Vendor copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    String? shopName,
    String? description,
    String? businessAddress,
    String? city,
    String? country,
    String? shopCategory,
    String? contactEmail,
    String? logoUrl,
    String? bannerUrl,
    String? coverUrl,
    bool? isOpen,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
    double? rating,
    _i1.UuidValue? approvedById,
    _i3.Admin? approvedBy,
    DateTime? approvedAt,
    String? moderationNote,
    DateTime? moderatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Vendor',
      if (id != null) 'id': id?.toJson(),
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'shopName': shopName,
      if (description != null) 'description': description,
      if (businessAddress != null) 'businessAddress': businessAddress,
      if (city != null) 'city': city,
      if (country != null) 'country': country,
      if (shopCategory != null) 'shopCategory': shopCategory,
      if (contactEmail != null) 'contactEmail': contactEmail,
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (bannerUrl != null) 'bannerUrl': bannerUrl,
      if (coverUrl != null) 'coverUrl': coverUrl,
      'isOpen': isOpen,
      if (instagramHandle != null) 'instagramHandle': instagramHandle,
      if (facebookHandle != null) 'facebookHandle': facebookHandle,
      if (operatingHours != null) 'operatingHours': operatingHours,
      'rating': rating,
      if (approvedById != null) 'approvedById': approvedById?.toJson(),
      if (approvedBy != null) 'approvedBy': approvedBy?.toJson(),
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
      if (moderationNote != null) 'moderationNote': moderationNote,
      if (moderatedAt != null) 'moderatedAt': moderatedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VendorImpl extends Vendor {
  _VendorImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    required String shopName,
    String? description,
    String? businessAddress,
    String? city,
    String? country,
    String? shopCategory,
    String? contactEmail,
    String? logoUrl,
    String? bannerUrl,
    String? coverUrl,
    bool? isOpen,
    String? instagramHandle,
    String? facebookHandle,
    String? operatingHours,
    double? rating,
    _i1.UuidValue? approvedById,
    _i3.Admin? approvedBy,
    DateTime? approvedAt,
    String? moderationNote,
    DateTime? moderatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         shopName: shopName,
         description: description,
         businessAddress: businessAddress,
         city: city,
         country: country,
         shopCategory: shopCategory,
         contactEmail: contactEmail,
         logoUrl: logoUrl,
         bannerUrl: bannerUrl,
         coverUrl: coverUrl,
         isOpen: isOpen,
         instagramHandle: instagramHandle,
         facebookHandle: facebookHandle,
         operatingHours: operatingHours,
         rating: rating,
         approvedById: approvedById,
         approvedBy: approvedBy,
         approvedAt: approvedAt,
         moderationNote: moderationNote,
         moderatedAt: moderatedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Vendor]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Vendor copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    String? shopName,
    Object? description = _Undefined,
    Object? businessAddress = _Undefined,
    Object? city = _Undefined,
    Object? country = _Undefined,
    Object? shopCategory = _Undefined,
    Object? contactEmail = _Undefined,
    Object? logoUrl = _Undefined,
    Object? bannerUrl = _Undefined,
    Object? coverUrl = _Undefined,
    bool? isOpen,
    Object? instagramHandle = _Undefined,
    Object? facebookHandle = _Undefined,
    Object? operatingHours = _Undefined,
    double? rating,
    Object? approvedById = _Undefined,
    Object? approvedBy = _Undefined,
    Object? approvedAt = _Undefined,
    Object? moderationNote = _Undefined,
    Object? moderatedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Vendor(
      id: id is _i1.UuidValue? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      shopName: shopName ?? this.shopName,
      description: description is String? ? description : this.description,
      businessAddress: businessAddress is String?
          ? businessAddress
          : this.businessAddress,
      city: city is String? ? city : this.city,
      country: country is String? ? country : this.country,
      shopCategory: shopCategory is String? ? shopCategory : this.shopCategory,
      contactEmail: contactEmail is String? ? contactEmail : this.contactEmail,
      logoUrl: logoUrl is String? ? logoUrl : this.logoUrl,
      bannerUrl: bannerUrl is String? ? bannerUrl : this.bannerUrl,
      coverUrl: coverUrl is String? ? coverUrl : this.coverUrl,
      isOpen: isOpen ?? this.isOpen,
      instagramHandle: instagramHandle is String?
          ? instagramHandle
          : this.instagramHandle,
      facebookHandle: facebookHandle is String?
          ? facebookHandle
          : this.facebookHandle,
      operatingHours: operatingHours is String?
          ? operatingHours
          : this.operatingHours,
      rating: rating ?? this.rating,
      approvedById: approvedById is _i1.UuidValue?
          ? approvedById
          : this.approvedById,
      approvedBy: approvedBy is _i3.Admin?
          ? approvedBy
          : this.approvedBy?.copyWith(),
      approvedAt: approvedAt is DateTime? ? approvedAt : this.approvedAt,
      moderationNote: moderationNote is String?
          ? moderationNote
          : this.moderationNote,
      moderatedAt: moderatedAt is DateTime? ? moderatedAt : this.moderatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
