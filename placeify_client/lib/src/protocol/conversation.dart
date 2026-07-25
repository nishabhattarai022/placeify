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

/// One-to-one customer ↔ vendor conversation.
abstract class Conversation implements _i1.SerializableModel {
  Conversation._({
    this.id,
    required this.customerId,
    required this.vendorId,
    this.lastMessage,
    this.lastMessageTime,
    this.lastSenderId,
    int? unreadCustomerCount,
    int? unreadVendorCount,
    this.customerDeletedAt,
    this.vendorDeletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : unreadCustomerCount = unreadCustomerCount ?? 0,
       unreadVendorCount = unreadVendorCount ?? 0,
       createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Conversation({
    _i1.UuidValue? id,
    required _i1.UuidValue customerId,
    required _i1.UuidValue vendorId,
    String? lastMessage,
    DateTime? lastMessageTime,
    _i1.UuidValue? lastSenderId,
    int? unreadCustomerCount,
    int? unreadVendorCount,
    DateTime? customerDeletedAt,
    DateTime? vendorDeletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ConversationImpl;

  factory Conversation.fromJson(Map<String, dynamic> jsonSerialization) {
    return Conversation(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      customerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['customerId'],
      ),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      lastMessage: jsonSerialization['lastMessage'] as String?,
      lastMessageTime: jsonSerialization['lastMessageTime'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastMessageTime'],
            ),
      lastSenderId: jsonSerialization['lastSenderId'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(
              jsonSerialization['lastSenderId'],
            ),
      unreadCustomerCount: jsonSerialization['unreadCustomerCount'] as int?,
      unreadVendorCount: jsonSerialization['unreadVendorCount'] as int?,
      customerDeletedAt: jsonSerialization['customerDeletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['customerDeletedAt'],
            ),
      vendorDeletedAt: jsonSerialization['vendorDeletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(
              jsonSerialization['vendorDeletedAt'],
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

  _i1.UuidValue customerId;

  _i1.UuidValue vendorId;

  String? lastMessage;

  DateTime? lastMessageTime;

  _i1.UuidValue? lastSenderId;

  int unreadCustomerCount;

  int unreadVendorCount;

  /// Soft-delete for the customer side of the inbox.
  DateTime? customerDeletedAt;

  /// Soft-delete for the vendor side of the inbox.
  DateTime? vendorDeletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Conversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Conversation copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? customerId,
    _i1.UuidValue? vendorId,
    String? lastMessage,
    DateTime? lastMessageTime,
    _i1.UuidValue? lastSenderId,
    int? unreadCustomerCount,
    int? unreadVendorCount,
    DateTime? customerDeletedAt,
    DateTime? vendorDeletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Conversation',
      if (id != null) 'id': id?.toJson(),
      'customerId': customerId.toJson(),
      'vendorId': vendorId.toJson(),
      if (lastMessage != null) 'lastMessage': lastMessage,
      if (lastMessageTime != null) 'lastMessageTime': lastMessageTime?.toJson(),
      if (lastSenderId != null) 'lastSenderId': lastSenderId?.toJson(),
      'unreadCustomerCount': unreadCustomerCount,
      'unreadVendorCount': unreadVendorCount,
      if (customerDeletedAt != null)
        'customerDeletedAt': customerDeletedAt?.toJson(),
      if (vendorDeletedAt != null) 'vendorDeletedAt': vendorDeletedAt?.toJson(),
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

class _ConversationImpl extends Conversation {
  _ConversationImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue customerId,
    required _i1.UuidValue vendorId,
    String? lastMessage,
    DateTime? lastMessageTime,
    _i1.UuidValue? lastSenderId,
    int? unreadCustomerCount,
    int? unreadVendorCount,
    DateTime? customerDeletedAt,
    DateTime? vendorDeletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         customerId: customerId,
         vendorId: vendorId,
         lastMessage: lastMessage,
         lastMessageTime: lastMessageTime,
         lastSenderId: lastSenderId,
         unreadCustomerCount: unreadCustomerCount,
         unreadVendorCount: unreadVendorCount,
         customerDeletedAt: customerDeletedAt,
         vendorDeletedAt: vendorDeletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Conversation]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Conversation copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? customerId,
    _i1.UuidValue? vendorId,
    Object? lastMessage = _Undefined,
    Object? lastMessageTime = _Undefined,
    Object? lastSenderId = _Undefined,
    int? unreadCustomerCount,
    int? unreadVendorCount,
    Object? customerDeletedAt = _Undefined,
    Object? vendorDeletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Conversation(
      id: id is _i1.UuidValue? ? id : this.id,
      customerId: customerId ?? this.customerId,
      vendorId: vendorId ?? this.vendorId,
      lastMessage: lastMessage is String? ? lastMessage : this.lastMessage,
      lastMessageTime: lastMessageTime is DateTime?
          ? lastMessageTime
          : this.lastMessageTime,
      lastSenderId: lastSenderId is _i1.UuidValue?
          ? lastSenderId
          : this.lastSenderId,
      unreadCustomerCount: unreadCustomerCount ?? this.unreadCustomerCount,
      unreadVendorCount: unreadVendorCount ?? this.unreadVendorCount,
      customerDeletedAt: customerDeletedAt is DateTime?
          ? customerDeletedAt
          : this.customerDeletedAt,
      vendorDeletedAt: vendorDeletedAt is DateTime?
          ? vendorDeletedAt
          : this.vendorDeletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
