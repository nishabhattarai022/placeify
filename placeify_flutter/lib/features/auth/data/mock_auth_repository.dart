import 'dart:convert';

import 'package:placeify_flutter/features/admin/domain/enums/user_role.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/demo_credentials.dart';
import '../domain/models/app_user.dart';
import '../domain/models/consumer_profile_details.dart';
import '../domain/repositories/auth_repository.dart';

/// Local mock backend: stores registered users and the active session.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _usersKey = 'placeify_auth_users';
  static const _sessionEmailKey = 'placeify_auth_session_email';
  static const _pendingEmailKey = 'placeify_pending_registration_email';
  static const _pendingPasswordKey = 'placeify_pending_registration_password';
  static const _pendingNameKey = 'placeify_pending_registration_name';

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
    await beginEmailRegistration(
      fullName: fullName,
      email: email,
      password: password,
    );
    throw AuthException(
      'Registration started. Check your email to verify your Placeify account.',
    );
  }

  @override
  Future<String> beginEmailRegistration({
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

    await _prefs.setString(_pendingEmailKey, normalizedEmail);
    await _prefs.setString(_pendingPasswordKey, password);
    await _prefs.setString(_pendingNameKey, fullName.trim());
    return normalizedEmail;
  }

  @override
  Future<void> verifyEmailRegistration({
    required String token,
    required String password,
    String? fullName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    if (token.trim().isEmpty) {
      throw AuthException('This verification link is invalid. Request a new one.');
    }

    final email = _prefs.getString(_pendingEmailKey);
    final pendingPassword = _prefs.getString(_pendingPasswordKey);
    final pendingName = fullName ?? _prefs.getString(_pendingNameKey);
    if (email == null || pendingPassword == null) {
      throw AuthException('Start registration again from the sign-up screen.');
    }
    if (pendingPassword != password) {
      throw AuthException('Incorrect password for this verification.');
    }

    final users = await _loadUsers();
    if (users.any((u) => u.email == email)) {
      throw AuthException('An account with this email already exists');
    }

    users.add(
      _StoredUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fullName: (pendingName ?? email.split('@').first).trim(),
        email: email,
        password: password,
      ),
    );
    await _saveUsers(users);
    await _prefs.remove(_pendingEmailKey);
    await _prefs.remove(_pendingPasswordKey);
    await _prefs.remove(_pendingNameKey);
  }

  @override
  Future<void> resendVerificationEmail({
    required String email,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    // Mock: no-op success for UX.
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
  Future<void> signOut() async {
    await _prefs.remove(_sessionEmailKey);
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
      (null, VendorStatus.none) =>
        current.copyWith(vendorStatus: status, clearVendorId: true),
      _ => current.copyWith(vendorStatus: status),
    };
    users[index] = updated;
    await _saveUsers(users);
  }

  @override
  Future<ConsumerProfileDetails?> getConsumerProfile() async {
    final user = await getCurrentUser();
    if (user == null) return null;
    return ConsumerProfileDetails(
      fullName: user.fullName,
      email: user.email,
      phone: '',
      city: '',
    );
  }

  @override
  Future<AppUser> updateConsumerProfile(ConsumerProfileDetails profile) async {
    final user = await getCurrentUser();
    if (user == null) {
      throw AuthException('Sign in to update your profile');
    }
    return user;
  }

  @override
  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    if (newPassword.length < 8) {
      throw AuthException('Password must be at least 8 characters');
    }
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

    final adminEmail = DemoCredentials.adminEmail.toLowerCase();
    if (!updated.any((u) => u.email == adminEmail)) {
      updated = [
        _StoredUser(
          id: 'demo-admin',
          fullName: DemoCredentials.adminFullName,
          email: adminEmail,
          password: DemoCredentials.adminPassword,
          role: UserRole.admin,
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
  }) {
    return _StoredUser(
      id: id,
      fullName: fullName,
      email: email,
      password: password,
      role: role ?? this.role,
      vendorStatus: vendorStatus ?? this.vendorStatus,
      vendorId: clearVendorId ? null : (vendorId ?? this.vendorId),
    );
  }

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
