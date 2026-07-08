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

/// Consumer checkout payment option.
enum PaymentMethod implements _i1.SerializableModel {
  cod,
  mockOnline,
  esewa,
  khalti,
  bankTransfer;

  static PaymentMethod fromJson(String name) {
    switch (name) {
      case 'cod':
        return PaymentMethod.cod;
      case 'mockOnline':
        return PaymentMethod.mockOnline;
      case 'esewa':
        return PaymentMethod.esewa;
      case 'khalti':
        return PaymentMethod.khalti;
      case 'bankTransfer':
        return PaymentMethod.bankTransfer;
      default:
        return PaymentMethod.mockOnline;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
