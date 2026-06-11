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

/// Pagination parameters for list endpoints.
abstract class PaginationInput
    implements _i1.SerializableModel, _i1.ProtocolSerialization {
  PaginationInput._({
    int? page,
    int? pageSize,
  }) : page = page ?? 1,
       pageSize = pageSize ?? 20;

  factory PaginationInput({
    int? page,
    int? pageSize,
  }) = _PaginationInputImpl;

  factory PaginationInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return PaginationInput(
      page: jsonSerialization['page'] as int?,
      pageSize: jsonSerialization['pageSize'] as int?,
    );
  }

  int page;

  int pageSize;

  /// Returns a shallow copy of this [PaginationInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PaginationInput copyWith({
    int? page,
    int? pageSize,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PaginationInput',
      'page': page,
      'pageSize': pageSize,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'PaginationInput',
      'page': page,
      'pageSize': pageSize,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _PaginationInputImpl extends PaginationInput {
  _PaginationInputImpl({
    int? page,
    int? pageSize,
  }) : super._(
         page: page,
         pageSize: pageSize,
       );

  /// Returns a shallow copy of this [PaginationInput]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PaginationInput copyWith({
    int? page,
    int? pageSize,
  }) {
    return PaginationInput(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
