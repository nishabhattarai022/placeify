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

enum PaymentTransactionStatus implements _i1.SerializableModel {
  pending,
  paid,
  failed,
  cancelled,
  refunded;

  static PaymentTransactionStatus fromJson(String name) {
    switch (name) {
      case 'pending':
        return PaymentTransactionStatus.pending;
      case 'paid':
        return PaymentTransactionStatus.paid;
      case 'failed':
        return PaymentTransactionStatus.failed;
      case 'cancelled':
        return PaymentTransactionStatus.cancelled;
      case 'refunded':
        return PaymentTransactionStatus.refunded;
      default:
        return PaymentTransactionStatus.pending;
    }
  }

  @override
  String toJson() => name;

  @override
  String toString() => name;
}
