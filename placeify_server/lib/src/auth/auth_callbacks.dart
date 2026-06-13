import 'package:serverpod/serverpod.dart';

import '../generated/protocol.dart';

/// Creates a Placeify user profile when a new auth account is registered.
Future<void> onAfterAccountCreated(
  Session session, {
  required String email,
  required UuidValue authUserId,
  required UuidValue emailAccountId,
  required Transaction? transaction,
}) async {
  final existing = await User.db.findFirstRow(
    session,
    where: (user) => user.authUserId.equals(authUserId),
    transaction: transaction,
  );
  if (existing != null) return;

  final name = email.split('@').first;
  await User.db.insertRow(
    session,
    User(
      authUserId: authUserId,
      name: name,
      email: email.trim().toLowerCase(),
      role: UserRole.consumer,
      status: UserAccountStatus.approved,
    ),
    transaction: transaction,
  );
}
