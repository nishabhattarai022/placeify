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
import 'chat_message.dart' as _i2;
import 'package:placeify_server/src/generated/protocol.dart' as _i3;

/// Paginated chat messages for a conversation thread.
abstract class ChatMessagePage
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ChatMessagePage._({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory ChatMessagePage({
    required List<_i2.ChatMessage> items,
    required int totalCount,
    required int page,
    required int pageSize,
    required bool hasMore,
  }) = _ChatMessagePageImpl;

  factory ChatMessagePage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChatMessagePage(
      items: _i3.Protocol().deserialize<List<_i2.ChatMessage>>(
        jsonSerialization['items'],
      ),
      totalCount: jsonSerialization['totalCount'] as int,
      page: jsonSerialization['page'] as int,
      pageSize: jsonSerialization['pageSize'] as int,
      hasMore: _i1.BoolJsonExtension.fromJson(jsonSerialization['hasMore']),
    );
  }

  List<_i2.ChatMessage> items;

  int totalCount;

  int page;

  int pageSize;

  bool hasMore;

  /// Returns a shallow copy of this [ChatMessagePage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ChatMessagePage copyWith({
    List<_i2.ChatMessage>? items,
    int? totalCount,
    int? page,
    int? pageSize,
    bool? hasMore,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChatMessagePage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'totalCount': totalCount,
      'page': page,
      'pageSize': pageSize,
      'hasMore': hasMore,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChatMessagePage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'totalCount': totalCount,
      'page': page,
      'pageSize': pageSize,
      'hasMore': hasMore,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _ChatMessagePageImpl extends ChatMessagePage {
  _ChatMessagePageImpl({
    required List<_i2.ChatMessage> items,
    required int totalCount,
    required int page,
    required int pageSize,
    required bool hasMore,
  }) : super._(
         items: items,
         totalCount: totalCount,
         page: page,
         pageSize: pageSize,
         hasMore: hasMore,
       );

  /// Returns a shallow copy of this [ChatMessagePage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ChatMessagePage copyWith({
    List<_i2.ChatMessage>? items,
    int? totalCount,
    int? page,
    int? pageSize,
    bool? hasMore,
  }) {
    return ChatMessagePage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
