import 'dart:convert';

import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/demo_credentials.dart';
import '../domain/models/app_user.dart';
import '../domain/repositories/auth_repository.dart';

/// Local mock backend: stores registered users and the active session.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _usersKey = 'placeify_auth_users';
  static const _sessionEmailKey = 'placeify_auth_session_email';

  static Future<MockAuthRepository> create() async {
    final prefs = await SharedPreferences.getInstance();
    return MockAuthRepository(prefs);
  }

  @override
  Future<AppUser> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    final normalizedEmail = email.trim().toLowerCase();
    final users = await _loadUsers();

    if (users.any((u) => u.email == normalizedEmail)) {
      throw AuthException('An account with this email already exists');
    }

    final user = _StoredUser(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      fullName: fullName.trim(),
      email: normalizedEmail,
      password: password,
    );
    users.add(user);
    await _saveUsers(users);

    return user.toAppUser();
  }

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));

    final normalizedEmail = email.trim().toLowerCase();
    final users = await _loadUsers();
    final match = users.where((u) => u.email == normalizedEmail).firstOrNull;

    if (match == null) {
      throw AuthException('No account found for this email');
    }
    if (match.password != password) {
      throw AuthException('Incorrect password');
    }

    await _prefs.setString(_sessionEmailKey, normalizedEmail);
    return match.toAppUser();
  }

  @override
  Future<List<AppUser>> getAllUsers() async {
    final users = await _loadUsers();
    return users.map((u) => u.toAppUser()).toList();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final email = _prefs.getString(_sessionEmailKey);
    if (email == null) return null;

    final users = await _loadUsers();
    final match = users.where((u) => u.email == email).firstOrNull;
    return match?.toAppUser();
  }

  @override
  Future<bool> verifyAdminAccess() async {
    final user = await getCurrentUser();
    return user?.role == UserRole.admin;
  }

  @override
  Future<AppUser> signInAsAdmin({
    required String adminId,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final normalizedId = adminId.trim().toLowerCase();
    // Mock-only identity for local UI tests (not used by Serverpod builds).
    const mockAdminId = 'admin@placeify.com';
    const mockAdminPassword = 'demo1234';
    if (normalizedId != mockAdminId || password != mockAdminPassword) {
      throw AuthException('Invalid admin credentials.');
    }

    final users = await _loadUsers();
    final index = users.indexWhere((u) => u.email == normalizedId);
    late final _StoredUser admin;
    if (index == -1) {
      admin = _StoredUser(
        id: 'admin-1',
        fullName: 'Demo Admin',
        email: normalizedId,
        password: mockAdminPassword,
        role: UserRole.admin,
      );
      users.add(admin);
    } else {
      admin = users[index].copyWith(role: UserRole.admin);
      users[index] = admin;
    }
    await _saveUsers(users);
    await _prefs.setString(_sessionEmailKey, normalizedId);
    return admin.toAppUser();
  }

  @override
  Future<void> signOut() async {
    await _prefs.remove(_sessionEmailKey);
  }

  @override
  Future<DateTime> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final email = _prefs.getString(_sessionEmailKey);
    if (email == null) {
      throw AuthException('Sign in to continue');
    }

    final users = await _loadUsers();
    final index = users.indexWhere((u) => u.email == email);
    if (index == -1) throw AuthException('Session expired');

    final current = users[index];
    if (current.password != currentPassword) {
      throw AuthException('Current password is incorrect.');
    }
    if (newPassword == currentPassword) {
      throw AuthException(
        'New password must be different from your current password.',
      );
    }
    if (newPassword.length < 8) {
      throw AuthException('Password too short');
    }

    users[index] = current.copyWithPassword(newPassword);
    await _saveUsers(users);
    return DateTime.now();
  }

  @override
  Future<void> requestPasswordReset({
    required String email,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    // Mock implementation intentionally mirrors the generic backend response.
  }

  @override
  Future<void> confirmPasswordReset({
    required String token,
    required String newPassword,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    if (token.trim().isEmpty) {
      throw AuthException('Reset token is missing. Open the reset link again.');
    }
    if (newPassword.length < 8) {
      throw AuthException('Password must be at least 8 characters');
    }
  }

  @override
  Future<AppUser> becomeVendor() async {
    final email = _prefs.getString(_sessionEmailKey);
    if (email == null) {
      throw AuthException('Sign in to continue');
    }

    final users = await _loadUsers();
    final index = users.indexWhere((u) => u.email == email);
    if (index == -1) throw AuthException('Session expired');

    final updated = users[index].copyWith(
      role: UserRole.vendor,
      vendorStatus: VendorStatus.pending,
    );
    users[index] = updated;
    await _saveUsers(users);
    return updated.toAppUser();
  }

  @override
  Future<AppUser> becomeConsumer() async {
    final email = _prefs.getString(_sessionEmailKey);
    if (email == null) {
      throw AuthException('Sign in to continue');
    }

    final users = await _loadUsers();
    final index = users.indexWhere((u) => u.email == email);
    if (index == -1) throw AuthException('Session expired');

    final updated = users[index].copyWith(
      role: UserRole.customer,
      vendorStatus: VendorStatus.none,
      clearVendorId: true,
    );
    users[index] = updated;
    await _saveUsers(users);
    return updated.toAppUser();
  }

  @override
  Future<void> updateVendorStatus({
    required VendorStatus status,
    String? vendorId,
  }) async {
    final email = _prefs.getString(_sessionEmailKey);
    if (email == null) return;

    final users = await _loadUsers();
    final index = users.indexWhere((u) => u.email == email);
    if (index == -1) return;

    final current = users[index];
    users[index] = vendorId != null
        ? current.copyWith(vendorStatus: status, vendorId: vendorId)
        : current.copyWith(vendorStatus: status);
    await _saveUsers(users);
  }

  @override
  Future<void> updateVendorStatusForUser({
    required String userId,
    required VendorStatus status,
    String? vendorId,
  }) async {
    final users = await _loadUsers();
    final index = users.indexWhere((u) => u.id == userId);
    if (index == -1) return;

    final current = users[index];
    final updated = switch ((vendorId, status)) {
      (final id?, _) => current.copyWith(vendorStatus: status, vendorId: id),
      (null, VendorStatus.none) => current.copyWith(
        vendorStatus: status,
        clearVendorId: true,
      ),
      _ => current.copyWith(vendorStatus: status),
    };
    users[index] = updated;
    await _saveUsers(users);
  }

  Future<List<_StoredUser>> _loadUsers() async {
    final raw = _prefs.getString(_usersKey);
    var users = <_StoredUser>[];

    if (raw != null && raw.isNotEmpty) {
      final list = jsonDecode(raw) as List<dynamic>;
      users = list
          .map((e) => _StoredUser.fromJson(e as Map<String, dynamic>))
          .toList();
    }

    return _ensureDemoUsers(users);
  }

  Future<List<_StoredUser>> _ensureDemoUsers(List<_StoredUser> users) async {
    var updated = users;
    var changed = false;

    final demoEmail = DemoCredentials.email.toLowerCase();
    if (!updated.any((u) => u.email == demoEmail)) {
      updated = [
        _StoredUser(
          id: 'demo-user',
          fullName: DemoCredentials.fullName,
          email: demoEmail,
          password: DemoCredentials.password,
        ),
        ...updated,
      ];
      changed = true;
    }

    if (changed) {
      await _saveUsers(updated);
    }
    return updated;
  }

  Future<void> _saveUsers(List<_StoredUser> users) async {
    final encoded = jsonEncode(users.map((u) => u.toJson()).toList());
    await _prefs.setString(_usersKey, encoded);
  }
}

class _StoredUser {
  _StoredUser({
    required this.id,
    required this.fullName,
    required this.email,
    required this.password,
    this.role = UserRole.customer,
    this.vendorStatus = VendorStatus.none,
    this.vendorId,
  });

  final String id;
  final String fullName;
  final String email;
  final String password;
  final UserRole role;
  final VendorStatus vendorStatus;
  final String? vendorId;

  _StoredUser copyWith({
    UserRole? role,
    VendorStatus? vendorStatus,
    String? vendorId,
    bool clearVendorId = false,
    String? password,
  }) {
    return _StoredUser(
      id: id,
      fullName: fullName,
      email: email,
      password: password ?? this.password,
      role: role ?? this.role,
      vendorStatus: vendorStatus ?? this.vendorStatus,
      vendorId: clearVendorId ? null : (vendorId ?? this.vendorId),
    );
  }

  _StoredUser copyWithPassword(String newPassword) =>
      copyWith(password: newPassword);

  AppUser toAppUser() => AppUser(
    id: id,
    fullName: fullName,
    email: email,
    role: role,
    vendorStatus: vendorStatus,
    vendorId: vendorId,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'fullName': fullName,
    'email': email,
    'password': password,
    'role': role.name,
    'vendorStatus': vendorStatus.name,
    if (vendorId != null) 'vendorId': vendorId,
  };

  factory _StoredUser.fromJson(Map<String, dynamic> json) {
    return _StoredUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      role: json['role'] != null
          ? UserRole.values.byName(json['role'] as String)
          : UserRole.customer,
      vendorStatus: json['vendorStatus'] != null
          ? VendorStatus.values.byName(json['vendorStatus'] as String)
          : VendorStatus.none,
      vendorId: json['vendorId'] as String?,
    );
  }
}

extension<T> on Iterable<T> {
  T? get firstOrNull {
    final iterator = this.iterator;
    if (!iterator.moveNext()) return null;
    return iterator.current;
  }
}
