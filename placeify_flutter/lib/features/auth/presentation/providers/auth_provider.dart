import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../vendor/domain/enums/vendor_status.dart';
import '../../constants/demo_credentials.dart';
import '../../data/serverpod_auth_repository.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/consumer_profile_details.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/config/placeify_server_client.dart';

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

  /// Starts registration and emails a verification link. Does not sign in.
  Future<String> registerAccount({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final repo = await ref.read(authRepositoryProvider.future);
    return repo.beginEmailRegistration(
      fullName: fullName,
      email: email,
      password: password,
    );
  }

  Future<void> verifyEmailRegistration({
    required String token,
    required String password,
    String? fullName,
  }) async {
    final repo = await ref.read(authRepositoryProvider.future);
    await repo.verifyEmailRegistration(
      token: token,
      password: password,
      fullName: fullName,
    );
  }

  Future<void> resendVerificationEmail({
    required String email,
  }) async {
    final repo = await ref.read(authRepositoryProvider.future);
    await repo.resendVerificationEmail(email: email);
  }

  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(authRepositoryProvider.future);
      return repo.signIn(email: email, password: password);
    });
    if (state.hasError) throw _unwrapError(state.error!);
    await ensurePlaceifyRealtime();
    return _requireSignedInUser();
  }

  Future<AppUser> signInWithDemoAdminCredentials() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(authRepositoryProvider.future);
      if (repo is ServerpodAuthRepository) {
        return repo.signIn(
          email: DemoCredentials.adminEmail,
          password: DemoCredentials.adminPassword,
        );
      }
      return repo.signIn(
        email: DemoCredentials.adminEmail,
        password: DemoCredentials.adminPassword,
      );
    });
    if (state.hasError) throw _unwrapError(state.error!);
    unawaited(ensurePlaceifyRealtime());
    return _requireSignedInUser();
  }

  AppUser _requireSignedInUser() {
    final user = state.requireValue;
    if (user == null) {
      throw AuthException('Sign in failed. Try again.');
    }
    return user;
  }

  Future<void> signOut() async {
    final repo = await ref.read(authRepositoryProvider.future);
    await repo.signOut();
    await resetPlaceifyRealtime();
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

  Future<void> updateConsumerProfile(ConsumerProfileDetails profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(authRepositoryProvider.future);
      return repo.updateConsumerProfile(profile);
    });
    if (state.hasError) throw _unwrapError(state.error!);
  }

  Future<ConsumerProfileDetails?> loadConsumerProfile() async {
    final repo = await ref.read(authRepositoryProvider.future);
    return repo.getConsumerProfile();
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    final repo = await ref.read(authRepositoryProvider.future);
    await repo.resetPassword(email: email, newPassword: newPassword);
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
