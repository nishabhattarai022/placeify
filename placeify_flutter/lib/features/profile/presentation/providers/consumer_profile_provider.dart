import 'dart:io';

import 'package:placeify_client/placeify_client.dart' show User;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/serverpod_consumer_profile_repository.dart';

part 'consumer_profile_provider.g.dart';

@riverpod
ServerpodConsumerProfileRepository consumerProfileRepository(Ref ref) {
  return const ServerpodConsumerProfileRepository();
}

@riverpod
class ConsumerProfile extends _$ConsumerProfile {
  @override
  Future<User?> build() async {
    if (!client.auth.isAuthenticated) return null;
    return ref.read(consumerProfileRepositoryProvider).getCurrentProfile();
  }

  Future<String?> updateProfile({
    required String name,
    String? phone,
    String? address,
  }) async {
    try {
      final updated = await ref
          .read(consumerProfileRepositoryProvider)
          .updateProfile(
            name: name,
            phone: phone,
            address: address,
          );
      state = AsyncData(updated);
      await ref.read(currentUserProvider.notifier).refresh();
      return null;
    } on ConsumerProfileException catch (error) {
      return error.message;
    } catch (_) {
      return 'Could not update profile.';
    }
  }

  Future<String?> uploadProfileImage(String filePath) async {
    try {
      final updated = await ref
          .read(consumerProfileRepositoryProvider)
          .uploadProfileImage(File(filePath));
      state = AsyncData(updated);
      await ref.read(currentUserProvider.notifier).refresh();
      return null;
    } on ConsumerProfileException catch (error) {
      return error.message;
    } catch (_) {
      return 'Could not upload photo.';
    }
  }

  Future<void> refresh() async {
    ref.invalidateSelf();
    await future;
  }
}
