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

/// Application-level error with a stable code for API clients.
abstract class PlaceifyException
    implements _i1.SerializableException, _i1.SerializableModel {
  PlaceifyException._({
    required this.message,
    required this.code,
  });

  factory PlaceifyException({
    required String message,
    required String code,
  }) = _PlaceifyExceptionImpl;

  factory PlaceifyException.fromJson(Map<String, dynamic> jsonSerialization) {
    return PlaceifyException(
      message: jsonSerialization['message'] as String,
      code: jsonSerialization['code'] as String,
    );
  }

  String message;

  String code;

  /// Returns a shallow copy of this [PlaceifyException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PlaceifyException copyWith({
    String? message,
    String? code,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'PlaceifyException',
      'message': message,
      'code': code,
    };
  }

  @override
  String toString() {
    return 'PlaceifyException(message: $message, code: $code)';
  }
}

class _PlaceifyExceptionImpl extends PlaceifyException {
  _PlaceifyExceptionImpl({
    required String message,
    required String code,
  }) : super._(
         message: message,
         code: code,
       );

  /// Returns a shallow copy of this [PlaceifyException]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PlaceifyException copyWith({
    String? message,
    String? code,
  }) {
    return PlaceifyException(
      message: message ?? this.message,
      code: code ?? this.code,
    );
  }
}
