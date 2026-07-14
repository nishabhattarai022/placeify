// One-shot account bootstrap against a running local server.
//
// From placeify_flutter:
//   dart run tool/bootstrap_test_user.dart [email] [password] [fullName]

import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart';

Future<void> main(List<String> args) async {
  final email =
      (args.isNotEmpty ? args[0] : 'testanu@gmail.com').trim().toLowerCase();
  final password = args.length > 1 ? args[1] : 'testanu123';
  final fullName = args.length > 2 ? args[2] : 'Test Anu';

  final storage = _InMemoryAuthSuccessStorage();
  final sessionManager = ClientAuthSessionManager(storage: storage);
  final client = Client('http://127.0.0.1:8080/')
    ..authSessionManager = sessionManager;

  print('Bootstrapping $email');

  try {
    final authSuccess = await client.emailIdp.login(
      email: email,
      password: password,
    );
    await client.auth.updateSignedInUser(authSuccess);
    print('OK login — account already exists for $email');
    return;
  } catch (error) {
    print('Login miss, registering… ($error)');
  }

  final requestId = await client.emailIdp.startRegistration(email: email);
  final token = await client.emailIdp.verifyRegistrationCode(
    accountRequestId: requestId,
    verificationCode: '123456',
  );
  final authSuccess = await client.emailIdp.finishRegistration(
    registrationToken: token,
    password: password,
  );
  await client.auth.updateSignedInUser(authSuccess);
  await client.user.updateProfile(fullName, phone: null, address: null);
  print('Registered $email with password "$password" (name: $fullName)');
}

class _InMemoryAuthSuccessStorage implements ClientAuthSuccessStorage {
  AuthSuccess? _auth;

  @override
  Future<AuthSuccess?> get() async => _auth;

  @override
  Future<void> set(AuthSuccess? authSuccess) async {
    _auth = authSuccess;
  }

  @override
  Future<void> delete() async {
    _auth = null;
  }
}
