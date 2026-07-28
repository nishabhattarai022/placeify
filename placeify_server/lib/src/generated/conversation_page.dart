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
import 'conversation_summary.dart' as _i2;
import 'package:placeify_server/src/generated/protocol.dart' as _i3;

/// Paginated conversation inbox.
abstract class ConversationPage
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  ConversationPage._({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.hasMore,
  });

  factory ConversationPage({
    required List<_i2.ConversationSummary> items,
    required int totalCount,
    required int page,
    required int pageSize,
    required bool hasMore,
  }) = _ConversationPageImpl;

  factory ConversationPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ConversationPage(
      items: _i3.Protocol().deserialize<List<_i2.ConversationSummary>>(
        jsonSerialization['items'],
      ),
      totalCount: jsonSerialization['totalCount'] as int,
      page: jsonSerialization['page'] as int,
      pageSize: jsonSerialization['pageSize'] as int,
      hasMore: _i1.BoolJsonExtension.fromJson(jsonSerialization['hasMore']),
    );
  }

  List<_i2.ConversationSummary> items;

  int totalCount;

  int page;

  int pageSize;

  bool hasMore;

  /// Returns a shallow copy of this [ConversationPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  ConversationPage copyWith({
    List<_i2.ConversationSummary>? items,
    int? totalCount,
    int? page,
    int? pageSize,
    bool? hasMore,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ConversationPage',
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
      '__className__': 'ConversationPage',
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

class _ConversationPageImpl extends ConversationPage {
  _ConversationPageImpl({
    required List<_i2.ConversationSummary> items,
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

  /// Returns a shallow copy of this [ConversationPage]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  ConversationPage copyWith({
    List<_i2.ConversationSummary>? items,
    int? totalCount,
    int? page,
    int? pageSize,
    bool? hasMore,
  }) {
    return ConversationPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
