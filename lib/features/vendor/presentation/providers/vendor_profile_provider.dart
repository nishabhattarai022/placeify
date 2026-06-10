import 'package:placeify/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify/features/vendor/data/mock_vendor_repository.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';
import 'package:placeify/features/vendor/domain/models/vendor_profile.dart'
    as models;
import 'package:placeify/features/vendor/domain/repositories/vendor_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_profile_provider.g.dart';

@Riverpod(keepAlive: true)
VendorRepository vendorRepository(Ref ref) {
  return MockVendorRepository();
}

@riverpod
class VendorProfile extends _$VendorProfile {
  @override
  Future<models.VendorProfile?> build() async {
    final user = await ref.watch(currentUserProvider.future);
    if (user?.vendorStatus != VendorStatus.approved || user?.vendorId == null) {
      return null;
    }
    final repo = ref.watch(vendorRepositoryProvider);
    return repo.getProfile(user!.vendorId!);
  }
}
