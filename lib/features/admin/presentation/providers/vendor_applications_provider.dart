import 'package:placeify/features/admin/domain/enums/vendor_application_list_filter.dart';
import 'package:placeify/features/admin/domain/models/vendor_application.dart';
import 'package:placeify/features/admin/presentation/providers/admin_stats_provider.dart';
import 'package:placeify/features/admin/presentation/providers/vendor_application_repository_provider.dart';
import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_profile_provider.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_stats_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_applications_provider.g.dart';

@riverpod
class VendorApplicationsList extends _$VendorApplicationsList {
  @override
  Future<List<VendorApplication>> build(
    VendorApplicationListFilter filter,
  ) async {
    final repo = await ref.watch(vendorApplicationRepositoryProvider.future);
    return repo.listApplications(filter: filter);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = await ref.read(vendorApplicationRepositoryProvider.future);
      return repo.listApplications(filter: filter);
    });
  }
}

@riverpod
Future<VendorApplication?> vendorApplicationDetail(
  Ref ref,
  String vendorId,
) async {
  final repo = await ref.watch(vendorApplicationRepositoryProvider.future);
  return repo.getByVendorId(vendorId);
}

@riverpod
class VendorApplicationActions extends _$VendorApplicationActions {
  @override
  FutureOr<void> build() {}

  Future<String?> approve({
    required String userId,
    required String vendorId,
  }) async {
    final repo = await ref.read(vendorApplicationRepositoryProvider.future);
    try {
      await ref.read(currentUserProvider.notifier).updateVendorStatusForUser(
            userId: userId,
            status: VendorStatus.approved,
            vendorId: vendorId,
          );
      await repo.approve(userId: userId, vendorId: vendorId);
      _invalidateAfterDecision(vendorId);
      return null;
    } catch (e) {
      return 'Could not approve application: $e';
    }
  }

  Future<String?> decline({
    required String userId,
    required String vendorId,
    String? note,
  }) async {
    final repo = await ref.read(vendorApplicationRepositoryProvider.future);
    try {
      await ref.read(currentUserProvider.notifier).updateVendorStatusForUser(
            userId: userId,
            status: VendorStatus.none,
            vendorId: null,
          );
      await repo.decline(userId: userId, note: note);
      _invalidateAfterDecision(vendorId);
      return null;
    } catch (_) {
      return 'Could not decline application';
    }
  }

  void _invalidateAfterDecision(String vendorId) {
    ref.invalidate(vendorApplicationDetailProvider(vendorId));
    ref.invalidate(vendorApplicationsListProvider);
    ref.invalidate(adminStatsProvider);
    ref.invalidate(vendorProfileProvider);
    ref.invalidate(vendorStatsProvider);
  }
}
