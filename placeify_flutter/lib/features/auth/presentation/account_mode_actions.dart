import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/toast_overlay.dart';
import '../domain/models/app_user_extensions.dart';
import '../domain/repositories/auth_repository.dart';
import '../../admin/domain/enums/user_role.dart';
import 'providers/auth_provider.dart';

Future<void> openVendorExperience(
  BuildContext context,
  WidgetRef ref,
) async {
  var user = ref.read(currentUserProvider).value;
  if (user == null) {
    context.push('/login');
    return;
  }

  final shouldSwitchMode = user.isVendorAccount && user.role != UserRole.vendor;
  if (shouldSwitchMode) {
    try {
      await ref.read(currentUserProvider.notifier).switchToVendorMode();
      user = ref.read(currentUserProvider).value ?? user;
    } on AuthException catch (error) {
      if (context.mounted) PlaceifyToast.show(context, error.message);
      return;
    } catch (_) {
      if (context.mounted) {
        PlaceifyToast.show(context, 'Could not switch to vendor mode.');
      }
      return;
    }
  }

  if (!context.mounted) return;

  if (user.isVendorAccount || user.canLoadVendorPortal) {
    context.go('/vendor');
  } else {
    context.push('/vendor/register');
  }
}

Future<void> openConsumerExperience(
  BuildContext context,
  WidgetRef ref,
) async {
  final user = ref.read(currentUserProvider).value;
  if (user == null) return;

  if (user.isVendorMode) {
    try {
      await ref.read(currentUserProvider.notifier).switchToConsumerMode();
    } on AuthException catch (error) {
      if (context.mounted) PlaceifyToast.show(context, error.message);
      return;
    } catch (_) {
      if (context.mounted) {
        PlaceifyToast.show(context, 'Could not switch to shopping mode.');
      }
      return;
    }
  }

  if (context.mounted) context.go('/home');
}
