import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/core/debug/agent_debug_log.dart';
import 'package:placeify_flutter/features/admin/data/serverpod_admin_api.dart';
import 'package:placeify_flutter/features/admin/domain/enums/admin_vendor_list_filter.dart';
import 'package:placeify_flutter/features/admin/domain/enums/vendor_application_list_filter.dart';
import 'package:placeify_flutter/features/admin/domain/models/vendor_application.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_repository_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_stats_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_users_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/vendor_application_repository_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/vendor_applications_provider.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_vendors_provider.g.dart';

@riverpod
class AdminVendorsList extends _$AdminVendorsList {
  @override
  Future<List<VendorApplication>> build(AdminVendorListFilter filter) async {
    final repo = await ref.watch(vendorApplicationRepositoryProvider.future);
    final applications = await repo.listApplications();

    return applications.where((application) {
      if (application.status != VendorStatus.approved &&
          application.status != VendorStatus.suspended) {
        return false;
      }

      return switch (filter) {
        AdminVendorListFilter.all => true,
        AdminVendorListFilter.approved =>
          application.status == VendorStatus.approved,
        AdminVendorListFilter.suspended =>
          application.status == VendorStatus.suspended,
      };
    }).toList();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(vendorApplicationRepositoryProvider.future);
      final applications = await repo.listApplications();

      return applications.where((application) {
        if (application.status != VendorStatus.approved &&
            application.status != VendorStatus.suspended) {
          return false;
        }

        return switch (filter) {
          AdminVendorListFilter.all => true,
          AdminVendorListFilter.approved =>
            application.status == VendorStatus.approved,
          AdminVendorListFilter.suspended =>
            application.status == VendorStatus.suspended,
        };
      }).toList();
    });
  }
}

@riverpod
class AdminVendorActions extends _$AdminVendorActions {
  @override
  FutureOr<void> build() {}

  Future<String?> suspend({
    required String userId,
    required String vendorId,
    String? reason,
  }) async {
    final repo = await ref.read(adminRepositoryProvider.future);
    try {
      // #region agent log
      AgentDebugLog.log(
        'admin_vendors_provider.dart:suspend:entry',
        'admin suspend action',
        {
          'userId': userId,
          'vendorId': vendorId,
          'reasonLength': reason?.trim().length ?? 0,
        },
        hypothesisId: 'C',
        runId: 'post-fix',
      );
      // #endregion
      await repo.suspendVendor(userId, reason: reason);
      await _refreshAfterAction(vendorId);
      return null;
    } catch (error) {
      return _actionErrorMessage(error, 'Could not suspend vendor');
    }
  }

  Future<String?> reinstate({
    required String userId,
    required String vendorId,
    bool termsAccepted = true,
    String? termsNote,
  }) async {
    final repo = await ref.read(adminRepositoryProvider.future);
    try {
      await repo.reinstateVendor(
        userId,
        termsAccepted: termsAccepted,
        termsNote: termsNote,
      );
      await _refreshAfterAction(vendorId);
      return null;
    } catch (error) {
      return _actionErrorMessage(error, 'Could not reinstate vendor');
    }
  }

  String _actionErrorMessage(Object error, String fallback) {
    if (error is AdminApiException) return error.message;
    if (error is PlaceifyException) return error.message;
    final message = error.toString();
    if (message.isNotEmpty && !message.startsWith('Exception:')) {
      return message;
    }
    return fallback;
  }

  Future<void> _refreshAfterAction(String vendorId) async {
    ref.invalidate(vendorApplicationDetailProvider(vendorId));
    for (final filter in AdminVendorListFilter.values) {
      await ref.read(adminVendorsListProvider(filter).notifier).refresh();
    }
    for (final filter in VendorApplicationListFilter.values) {
      await ref.read(vendorApplicationsListProvider(filter).notifier).refresh();
    }
    ref.invalidate(adminStatsProvider);
    ref.invalidate(adminUsersListProvider);
  }
}
