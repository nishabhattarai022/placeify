import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/serverpod_auth_repository.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
Future<AuthRepository> authRepository(Ref ref) async {
  return ServerpodAuthRepository.create();
}

@Riverpod(keepAlive: true)
class CurrentUser extends _$CurrentUser {
  @override
  Future<AppUser?> build() async {
    final repo = await ref.watch(authRepositoryProvider.future);
    return repo.getCurrentUser();
  }

  /// Persists a new account on the backend (does not create a session).
  Future<void> registerAccount({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final repo = await ref.read(authRepositoryProvider.future);
    await repo.register(
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(authRepositoryProvider.future);
      return repo.signIn(email: email, password: password);
    });
    if (state.hasError) throw state.error!;
  }

  Future<void> signOut() async {
    final repo = await ref.read(authRepositoryProvider.future);
    await repo.signOut();
    state = const AsyncData(null);
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(authRepositoryProvider.future);
      return repo.getCurrentUser();
    });
  }

  Future<void> switchToVendorMode() async {
    final repo = await ref.read(authRepositoryProvider.future);
    state = await AsyncValue.guard(() => repo.becomeVendor());
    if (state.hasError) throw state.error!;
  }

  Future<void> switchToConsumerMode() async {
    final repo = await ref.read(authRepositoryProvider.future);
    state = await AsyncValue.guard(() => repo.becomeConsumer());
    if (state.hasError) throw state.error!;
  }
}
