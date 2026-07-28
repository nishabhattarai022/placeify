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
import 'chat_message_type.dart' as _i2;

/// Direct message within a customer ↔ vendor conversation.
abstract class ChatMessage implements _i1.SerializableModel {
  ChatMessage._({
    this.id,
    required this.conversationId,
    required this.senderId,
    required this.receiverId,
    required this.message,
    _i2.ChatMessageType? messageType,
    bool? isRead,
    DateTime? createdAt,
  }) : messageType = messageType ?? _i2.ChatMessageType.text,
       isRead = isRead ?? false,
       createdAt = createdAt ?? DateTime.now();

  factory ChatMessage({
    _i1.UuidValue? id,
    required _i1.UuidValue conversationId,
    required _i1.UuidValue senderId,
    required _i1.UuidValue receiverId,
    required String message,
    _i2.ChatMessageType? messageType,
    bool? isRead,
    DateTime? createdAt,
  }) = _ChatMessageImpl;

  factory ChatMessage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessage(
      id: jsonSerialization['id'] == null
          ? null
          : _i1.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      conversationId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['conversationId'],
      ),
      senderId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['senderId'],
      ),
      receiverId: _i1.UuidValueJsonExtension.fromJson(
        jsonSerialization['receiverId'],
      ),
      message: jsonSerialization['message'] as String,
      messageType: jsonSerialization['messageType'] == null
          ? null
          : _i2.ChatMessageType.fromJson(
              (jsonSerialization['messageType'] as String),
            ),
      isRead: jsonSerialization['isRead'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isRead']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  _i1.UuidValue? id;

  _i1.UuidValue conversationId;

  _i1.UuidValue senderId;

  _i1.UuidValue receiverId;

  String message;

  _i2.ChatMessageType messageType;

  bool isRead;

  DateTime createdAt;

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessage copyWith({
    _i1.UuidValue? id,
    _i1.UuidValue? conversationId,
    _i1.UuidValue? senderId,
    _i1.UuidValue? receiverId,
    String? message,
    _i2.ChatMessageType? messageType,
    bool? isRead,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatMessage',
      if (id != null) 'id': id?.toJson(),
      'conversationId': conversationId.toJson(),
      'senderId': senderId.toJson(),
      'receiverId': receiverId.toJson(),
      'message': message,
      'messageType': messageType.toJson(),
      'isRead': isRead,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChatMessageImpl extends ChatMessage {
  _ChatMessageImpl({
    _i1.UuidValue? id,
    required _i1.UuidValue conversationId,
    required _i1.UuidValue senderId,
    required _i1.UuidValue receiverId,
    required String message,
    _i2.ChatMessageType? messageType,
    bool? isRead,
    DateTime? createdAt,
  }) : super._(
         id: id,
         conversationId: conversationId,
         senderId: senderId,
         receiverId: receiverId,
         message: message,
         messageType: messageType,
         isRead: isRead,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [ChatMessage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatMessage copyWith({
    Object? id = _Undefined,
    _i1.UuidValue? conversationId,
    _i1.UuidValue? senderId,
    _i1.UuidValue? receiverId,
    String? message,
    _i2.ChatMessageType? messageType,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      id: id is _i1.UuidValue? ? id : this.id,
      conversationId: conversationId ?? this.conversationId,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      message: message ?? this.message,
      messageType: messageType ?? this.messageType,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
