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
import 'package:placeify_client/src/protocol/protocol.dart' as _i3;

/// Per-user notification settings for the profile screen.
abstract class NotificationPreference implements _i1.SerializableModel {
  NotificationPreference._({
    this.id,
    required this.userId,
    this.user,
    bool? orderUpdates,
    bool? refundStatus,
    bool? arReminders,
    bool? priceDropAlerts,
    bool? vendorMessages,
    bool? promotions,
    DateTime? updatedAt,
  }) : orderUpdates = orderUpdates ?? true,
       refundStatus = refundStatus ?? true,
       arReminders = arReminders ?? true,
       priceDropAlerts = priceDropAlerts ?? false,
       vendorMessages = vendorMessages ?? true,
       promotions = promotions ?? false,
       updatedAt = updatedAt ?? DateTime.now();

  factory NotificationPreference({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    bool? orderUpdates,
    bool? refundStatus,
    bool? arReminders,
    bool? priceDropAlerts,
    bool? vendorMessages,
    bool? promotions,
    DateTime? updatedAt,
  }) = _NotificationPreferenceImpl;

  factory NotificationPreference.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return NotificationPreference(
      id: jsonSerialization['id'] as int?,
      userId: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      user: jsonSerialization['user'] == null
          ? null
          : _i3.Protocol().deserialize<_i2.User>(jsonSerialization['user']),
      orderUpdates: jsonSerialization['orderUpdates'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['orderUpdates']),
      refundStatus: jsonSerialization['refundStatus'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['refundStatus']),
      arReminders: jsonSerialization['arReminders'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['arReminders']),
      priceDropAlerts: jsonSerialization['priceDropAlerts'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['priceDropAlerts'],
            ),
      vendorMessages: jsonSerialization['vendorMessages'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['vendorMessages']),
      promotions: jsonSerialization['promotions'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['promotions']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i1.UuidValue userId;

  _i2.User? user;

  bool orderUpdates;

  bool refundStatus;

  bool arReminders;

  bool priceDropAlerts;

  bool vendorMessages;

  bool promotions;

  DateTime updatedAt;

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  NotificationPreference copyWith({
    int? id,
    _i1.UuidValue? userId,
    _i2.User? user,
    bool? orderUpdates,
    bool? refundStatus,
    bool? arReminders,
    bool? priceDropAlerts,
    bool? vendorMessages,
    bool? promotions,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'NotificationPreference',
      if (id != null) 'id': id,
      'userId': userId.toJson(),
      if (user != null) 'user': user?.toJson(),
      'orderUpdates': orderUpdates,
      'refundStatus': refundStatus,
      'arReminders': arReminders,
      'priceDropAlerts': priceDropAlerts,
      'vendorMessages': vendorMessages,
      'promotions': promotions,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _NotificationPreferenceImpl extends NotificationPreference {
  _NotificationPreferenceImpl({
    int? id,
    required _i1.UuidValue userId,
    _i2.User? user,
    bool? orderUpdates,
    bool? refundStatus,
    bool? arReminders,
    bool? priceDropAlerts,
    bool? vendorMessages,
    bool? promotions,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         userId: userId,
         user: user,
         orderUpdates: orderUpdates,
         refundStatus: refundStatus,
         arReminders: arReminders,
         priceDropAlerts: priceDropAlerts,
         vendorMessages: vendorMessages,
         promotions: promotions,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [NotificationPreference]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  NotificationPreference copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? userId,
    Object? user = _Undefined,
    bool? orderUpdates,
    bool? refundStatus,
    bool? arReminders,
    bool? priceDropAlerts,
    bool? vendorMessages,
    bool? promotions,
    DateTime? updatedAt,
  }) {
    return NotificationPreference(
      id: id is int? ? id : this.id,
      userId: userId ?? this.userId,
      user: user is _i2.User? ? user : this.user?.copyWith(),
      orderUpdates: orderUpdates ?? this.orderUpdates,
      refundStatus: refundStatus ?? this.refundStatus,
      arReminders: arReminders ?? this.arReminders,
      priceDropAlerts: priceDropAlerts ?? this.priceDropAlerts,
      vendorMessages: vendorMessages ?? this.vendorMessages,
      promotions: promotions ?? this.promotions,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
