import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

final class _MemoryAuthStorage implements ClientAuthSuccessStorage {
  AuthSuccess? _value;

  @override
  Future<AuthSuccess?> get() async => _value;

  @override
  Future<void> set(AuthSuccess? data) async {
    _value = data;
  }
}

/// Live-server check: admin login + reinstate one vendor for UI testing.
Future<void> main() async {
  final auth = ClientAuthSessionManager(storage: _MemoryAuthStorage());
  final client = Client('http://127.0.0.1:8080/')..authSessionManager = auth;
  await auth.initialize();
  try {
    final login = await client.emailIdp.login(
      email: 'admin@placeify.com',
      password: 'demo1234',
    );
    await client.auth.updateSignedInUser(login);
    await client.user.ensureDemoAdmin();

    const reinstateUserId = '019f04e4-8a0b-7214-b564-96167056ed0f';
    final reactivated = await client.admin.reactivateVendor(
      UuidValue.fromString(reinstateUserId),
      termsAccepted: true,
    );
    print('reinstate_ok shop=AaysCraft status=${reactivated.status.name}');

    final approved = await client.admin.listVendorApplications(
      status: UserAccountStatus.approved,
    );
    print('approved_vendors=${approved.length}');
    for (final vendor in approved) {
      print('  shop=${vendor.businessName} userId=${vendor.userId}');
    }
  } catch (error, stackTrace) {
    print('script_failed error=$error');
    print(stackTrace);
  } finally {
    client.close();
  }
}
