import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../vendor/domain/enums/vendor_status.dart';
import '../../constants/demo_credentials.dart';
import '../../data/serverpod_auth_repository.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/consumer_profile_details.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../profile/data/serverpod_consumer_profile_repository.dart';

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

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    if (newPassword.length < 8) {
      throw AuthException('Password must be at least 8 characters');
    }
    throw AuthException(
      'Password reset is not available yet. Sign in with your current password '
      'or register a new account.',
    );
  }

  Future<ConsumerProfileDetails?> loadConsumerProfile() async {
    final appUser = state.value;
    if (appUser == null) return null;

    const repo = ServerpodConsumerProfileRepository();
    try {
      final profile = await repo.getCurrentProfile();
      if (profile == null) return null;

      final email = profile.email?.trim().isNotEmpty == true
          ? profile.email!.trim()
          : appUser.email;
      final localPart = email.split('@').first;
      final username = localPart.replaceAll(RegExp(r'[^a-z0-9_]'), '');

      return ConsumerProfileDetails(
        fullName: profile.name,
        email: email,
        username: username,
        phone: profile.phone ?? '',
        bio: '',
        city: profile.address ?? '',
      );
    } on ConsumerProfileException catch (error) {
      throw AuthException(error.message);
    }
  }

  Future<void> updateConsumerProfile(ConsumerProfileDetails details) async {
    const repo = ServerpodConsumerProfileRepository();
    try {
      await repo.updateProfile(
        name: details.fullName,
        phone: details.phone.trim().isEmpty ? null : details.phone.trim(),
        address: details.city.trim().isEmpty ? null : details.city.trim(),
      );
      await refresh();
    } on ConsumerProfileException catch (error) {
      throw AuthException(error.message);
    }
  }
}

Never _unwrapError(Object error) {
  if (error is AuthException) throw error;
  throw error is Exception ? error : Exception(error.toString());
}
