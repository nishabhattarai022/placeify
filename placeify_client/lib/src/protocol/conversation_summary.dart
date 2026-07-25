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

/// Inbox row for conversation lists (customer or vendor perspective).
abstract class ConversationSummary implements _i1.SerializableModel {
  ConversationSummary._({
    required this.id,
    required this.customerId,
    required this.vendorId,
    required this.peerUserId,
    required this.peerName,
    this.peerAvatarUrl,
    this.lastMessage,
    this.lastMessageTime,
    this.lastSenderId,
    required this.unreadCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ConversationSummary({
    required _i1.UuidValue id,
    required _i1.UuidValue customerId,
    required _i1.UuidValue vendorId,
    required _i1.UuidValue peerUserId,
    required String peerName,
    String? peerAvatarUrl,
    String? lastMessage,
    DateTime? lastMessageTime,
    _i1.UuidValue? lastSenderId,
    required int unreadCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ConversationSummaryImpl;

  factory ConversationSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConversationSummary(
      id: _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      customerId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['customerId'],
      ),
      vendorId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['vendorId'],
      ),
      peerUserId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['peerUserId'],
      ),
      peerName: jsonSerialization['peerName'] as String,
      peerAvatarUrl: jsonSerialization['peerAvatarUrl'] as String?,
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
      unreadCount: jsonSerialization['unreadCount'] as int,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  _i1.UuidValue id;

  _i1.UuidValue customerId;

  _i1.UuidValue vendorId;

  _i1.UuidValue peerUserId;

  String peerName;

  String? peerAvatarUrl;

  String? lastMessage;

  DateTime? lastMessageTime;

  _i1.UuidValue? lastSenderId;

  int unreadCount;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [ConversationSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ConversationSummary copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? customerId,
    _i1.UuidValue? vendorId,
    _i1.UuidValue? peerUserId,
    String? peerName,
    String? peerAvatarUrl,
    String? lastMessage,
    DateTime? lastMessageTime,
    _i1.UuidValue? lastSenderId,
    int? unreadCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConversationSummary',
      'id': id.toJson(),
      'customerId': customerId.toJson(),
      'vendorId': vendorId.toJson(),
      'peerUserId': peerUserId.toJson(),
      'peerName': peerName,
      if (peerAvatarUrl != null) 'peerAvatarUrl': peerAvatarUrl,
      if (lastMessage != null) 'lastMessage': lastMessage,
      if (lastMessageTime != null) 'lastMessageTime': lastMessageTime?.toJson(),
      if (lastSenderId != null) 'lastSenderId': lastSenderId?.toJson(),
      'unreadCount': unreadCount,
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

class _ConversationSummaryImpl extends ConversationSummary {
  _ConversationSummaryImpl({
    required _i1.UuidValue id,
    required _i1.UuidValue customerId,
    required _i1.UuidValue vendorId,
    required _i1.UuidValue peerUserId,
    required String peerName,
    String? peerAvatarUrl,
    String? lastMessage,
    DateTime? lastMessageTime,
    _i1.UuidValue? lastSenderId,
    required int unreadCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         customerId: customerId,
         vendorId: vendorId,
         peerUserId: peerUserId,
         peerName: peerName,
         peerAvatarUrl: peerAvatarUrl,
         lastMessage: lastMessage,
         lastMessageTime: lastMessageTime,
         lastSenderId: lastSenderId,
         unreadCount: unreadCount,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [ConversationSummary]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ConversationSummary copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? customerId,
    _i1.UuidValue? vendorId,
    _i1.UuidValue? peerUserId,
    String? peerName,
    Object? peerAvatarUrl = _Undefined,
    Object? lastMessage = _Undefined,
    Object? lastMessageTime = _Undefined,
    Object? lastSenderId = _Undefined,
    int? unreadCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ConversationSummary(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      vendorId: vendorId ?? this.vendorId,
      peerUserId: peerUserId ?? this.peerUserId,
      peerName: peerName ?? this.peerName,
      peerAvatarUrl: peerAvatarUrl is String?
          ? peerAvatarUrl
          : this.peerAvatarUrl,
      lastMessage: lastMessage is String? ? lastMessage : this.lastMessage,
      lastMessageTime: lastMessageTime is DateTime?
          ? lastMessageTime
          : this.lastMessageTime,
      lastSenderId: lastSenderId is _i1.UuidValue?
          ? lastSenderId
          : this.lastSenderId,
      unreadCount: unreadCount ?? this.unreadCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
