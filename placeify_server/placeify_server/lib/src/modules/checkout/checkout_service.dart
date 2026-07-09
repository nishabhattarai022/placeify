import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'checkout_repository.dart';

class CheckoutService {
  CheckoutService({CheckoutStore? repository})
      : _repository = repository ?? CheckoutStore();

  final CheckoutStore _repository;

  Future<CheckoutResult> checkout(
    Session session,
    CheckoutRequest request,
  ) {
    return _repository.checkout(session, request);
  }
}
