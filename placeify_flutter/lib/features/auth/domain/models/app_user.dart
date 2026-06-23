import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

/// Authenticated Placeify user returned from the auth backend.
@freezed
abstract class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String fullName,
    required String email,
    @Default(UserRole.customer) UserRole role,
    @Default(VendorStatus.none) VendorStatus vendorStatus,
    String? vendorId,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
