import 'package:placeify/features/admin/domain/enums/admin_vendor_list_filter.dart';
import 'package:placeify/features/admin/domain/models/vendor_application.dart';
import 'package:placeify/features/admin/presentation/providers/admin_repository_provider.dart';
import 'package:placeify/features/admin/presentation/providers/admin_stats_provider.dart';
import 'package:placeify/features/admin/presentation/providers/admin_users_provider.dart';
import 'package:placeify/features/admin/presentation/providers/vendor_application_repository_provider.dart';
import 'package:placeify/features/admin/presentation/providers/vendor_applications_provider.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';
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
      await repo.suspendVendor(userId, reason: reason);
      _invalidateAfterAction(vendorId);
      return null;
    } catch (_) {
      return 'Could not suspend vendor';
    }
  }

  Future<String?> reinstate({
    required String userId,
    required String vendorId,
  }) async {
    final repo = await ref.read(adminRepositoryProvider.future);
    try {
      await repo.reinstateVendor(userId);
      _invalidateAfterAction(vendorId);
      return null;
    } catch (_) {
      return 'Could not reinstate vendor';
    }
  }

  void _invalidateAfterAction(String vendorId) {
    ref.invalidate(vendorApplicationDetailProvider(vendorId));
    ref.invalidate(adminVendorsListProvider);
    ref.invalidate(adminStatsProvider);
    ref.invalidate(adminUsersListProvider);
  }
}
