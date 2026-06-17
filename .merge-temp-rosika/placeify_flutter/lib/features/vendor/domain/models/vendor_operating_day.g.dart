// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_operating_day.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_VendorOperatingDay _$VendorOperatingDayFromJson(Map<String, dynamic> json) =>
    _VendorOperatingDay(
      dayKey: json['dayKey'] as String,
      isClosed: json['isClosed'] as bool? ?? false,
      openTime: json['openTime'] as String? ?? '09:00',
      closeTime: json['closeTime'] as String? ?? '17:00',
    );

Map<String, dynamic> _$VendorOperatingDayToJson(_VendorOperatingDay instance) =>
    <String, dynamic>{
      'dayKey': instance.dayKey,
      'isClosed': instance.isClosed,
      'openTime': instance.openTime,
      'closeTime': instance.closeTime,
    };
