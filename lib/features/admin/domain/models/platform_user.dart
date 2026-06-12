import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify/features/admin/domain/enums/user_role.dart';
import 'package:placeify/features/vendor/domain/enums/vendor_status.dart';

part 'platform_user.freezed.dart';
part 'platform_user.g.dart';

/// Platform user record exposed to admin user-management views.
@freezed
abstract class PlatformUser with _$PlatformUser {
  const factory PlatformUser({
    required String id,
    required String name,
    required String email,
    required UserRole role,
    required VendorStatus vendorStatus,
    String? vendorId,
    required DateTime createdAt,
  }) = _PlatformUser;

  factory PlatformUser.fromJson(Map<String, dynamic> json) =>
      _$PlatformUserFromJson(json);
}
