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
  final normalizedEmail = email.trim().toLowerCase();
  final existing = await User.db.findFirstRow(
    session,
    where: (user) => user.authUserId.equals(authUserId),
    transaction: transaction,
  );
  if (existing != null) {
    final current = existing.email?.trim().toLowerCase() ?? '';
    if (current != normalizedEmail) {
      await User.db.updateRow(
        session,
        existing.copyWith(
          email: normalizedEmail,
          updatedAt: DateTime.now(),
        ),
        transaction: transaction,
      );
    }
    return;
  }

  final name = normalizedEmail.split('@').first;
  await User.db.insertRow(
    session,
    User(
      authUserId: authUserId,
      name: name,
      email: normalizedEmail,
      role: UserRole.consumer,
      status: UserAccountStatus.approved,
    ),
    transaction: transaction,
  );
}
