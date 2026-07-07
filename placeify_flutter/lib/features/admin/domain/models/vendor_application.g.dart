// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorApplication _$VendorApplicationFromJson(Map<String, dynamic> json) =>
    _VendorApplication(
      vendorId: json['vendorId'] as String,
      userId: json['userId'] as String,
      businessName: json['businessName'] as String,
      contactEmail: json['contactEmail'] as String,
      submittedAt: DateTime.parse(json['submittedAt'] as String),
      registration: VendorRegistration.fromJson(
        json['registration'] as Map<String, dynamic>,
      ),
      status: $enumDecode(_$VendorStatusEnumMap, json['status']),
      moderationNote: json['moderationNote'] as String?,
      moderatedAt: json['moderatedAt'] == null
          ? null
          : DateTime.parse(json['moderatedAt'] as String),
      appealMessage: json['appealMessage'] as String?,
      appealSubmittedAt: json['appealSubmittedAt'] == null
          ? null
          : DateTime.parse(json['appealSubmittedAt'] as String),
    );

Map<String, dynamic> _$VendorApplicationToJson(_VendorApplication instance) =>
    <String, dynamic>{
      'vendorId': instance.vendorId,
      'userId': instance.userId,
      'businessName': instance.businessName,
      'contactEmail': instance.contactEmail,
      'submittedAt': instance.submittedAt.toIso8601String(),
      'registration': instance.registration,
      'status': _$VendorStatusEnumMap[instance.status]!,
      'moderationNote': instance.moderationNote,
      'moderatedAt': instance.moderatedAt?.toIso8601String(),
      'appealMessage': instance.appealMessage,
      'appealSubmittedAt': instance.appealSubmittedAt?.toIso8601String(),
    };

const _$VendorStatusEnumMap = {
  VendorStatus.none: 'none',
  VendorStatus.pending: 'pending',
  VendorStatus.approved: 'approved',
  VendorStatus.suspended: 'suspended',
};
