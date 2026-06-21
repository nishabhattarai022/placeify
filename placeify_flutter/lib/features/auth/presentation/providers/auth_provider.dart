import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../vendor/domain/enums/vendor_status.dart';
import '../../constants/demo_credentials.dart';
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

  /// Creates an account and signs the user in.
  Future<void> registerAccount({
    required String fullName,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(authRepositoryProvider.future);
      return repo.register(
        fullName: fullName,
        email: email,
        password: password,
      );
    });
    if (state.hasError) throw _unwrapError(state.error!);
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
    if (state.hasError) throw _unwrapError(state.error!);
  }

  Future<void> signInWithDemoCredentials() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(authRepositoryProvider.future);
      if (repo is ServerpodAuthRepository) {
        return repo.signInWithDemoCredentials();
      }
      return repo.signIn(
        email: DemoCredentials.email,
        password: DemoCredentials.password,
      );
    });
    if (state.hasError) throw _unwrapError(state.error!);
  }

  Future<void> signInWithDemoAdminCredentials() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(authRepositoryProvider.future);
      if (repo is ServerpodAuthRepository) {
        return repo.signInWithDemoAdminCredentials();
      }
      return repo.signIn(
        email: DemoCredentials.adminEmail,
        password: DemoCredentials.adminPassword,
      );
    });
    if (state.hasError) throw _unwrapError(state.error!);
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
    if (state.hasError) throw _unwrapError(state.error!);
  }

  Future<void> switchToConsumerMode() async {
    final repo = await ref.read(authRepositoryProvider.future);
    state = await AsyncValue.guard(() => repo.becomeConsumer());
    if (state.hasError) throw _unwrapError(state.error!);
  }

  Future<void> updateVendorStatus({
    required VendorStatus status,
    String? vendorId,
  }) async {
    final repo = await ref.read(authRepositoryProvider.future);
    state = await AsyncValue.guard(() async {
      await repo.updateVendorStatus(status: status, vendorId: vendorId);
      return repo.getCurrentUser();
    });
    if (state.hasError) throw _unwrapError(state.error!);
  }

  Future<void> updateVendorStatusForUser({
    required String userId,
    required VendorStatus status,
    String? vendorId,
  }) async {
    final repo = await ref.read(authRepositoryProvider.future);
    await repo.updateVendorStatusForUser(
      userId: userId,
      status: status,
      vendorId: vendorId,
    );
  }
}

Never _unwrapError(Object error) {
  if (error is AuthException) throw error;
  throw error is Exception ? error : Exception(error.toString());
}
