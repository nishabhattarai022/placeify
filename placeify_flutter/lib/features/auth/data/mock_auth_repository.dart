import 'dart:convert';

import 'package:placeify_client/placeify_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../vendor/domain/enums/vendor_status.dart';
import '../constants/demo_credentials.dart';
import '../domain/models/app_user.dart';
import '../domain/repositories/auth_repository.dart';

/// Local mock backend: stores registered users and the active session.
class MockAuthRepository implements AuthRepository {
  MockAuthRepository(this._prefs);

  final SharedPreferences _prefs;

  static const _usersKey = 'placeify_auth_users';
  static const _sessionEmailKey = 'placeify_auth_session_email';
  static const _vendorStatusKey = 'placeify_vendor_status';
  static const _vendorIdKey = 'placeify_vendor_id';

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
  Future<AppUser?> getCurrentUser() async {
    final email = _prefs.getString(_sessionEmailKey);
    if (email == null) return null;

    final users = await _loadUsers();
    final match = users.where((u) => u.email == email).firstOrNull;
    final user = match?.toAppUser();
    return user == null ? null : _withVendorOverrides(user);
  }

  @override
  Future<AppUser> updateVendorStatus({
    required VendorStatus status,
    String? vendorId,
  }) async {
    final user = await getCurrentUser();
    if (user == null) {
      throw AuthException('Sign in to continue');
    }
    await _prefs.setString(_vendorStatusKey, status.name);
    if (vendorId != null) {
      await _prefs.setString(_vendorIdKey, vendorId);
    }
    return _withVendorOverrides(user);
  }

  @override
  Future<AppUser> becomeVendor() async {
    final user = await getCurrentUser();
    if (user == null) {
      throw AuthException('Sign in to continue');
    }
    if (!user.hasVendorShop) {
      throw AuthException('Register your shop first to switch to vendor mode.');
    }
    return user.copyWith(role: UserRole.vendor);
  }

  @override
  Future<AppUser> becomeConsumer() async {
    final user = await getCurrentUser();
    if (user == null) {
      throw AuthException('Sign in to continue');
    }
    return user.copyWith(role: UserRole.consumer);
  }

  @override
  Future<void> signOut() async {
    await _prefs.remove(_sessionEmailKey);
    await _prefs.remove(_vendorStatusKey);
    await _prefs.remove(_vendorIdKey);
  }

  AppUser _withVendorOverrides(AppUser user) {
    final statusRaw = _prefs.getString(_vendorStatusKey);
    final status = statusRaw == null
        ? null
        : VendorStatus.values.asNameMap()[statusRaw];
    return user.copyWith(
      registeredVendorStatus: status,
      registeredVendorId: _prefs.getString(_vendorIdKey),
    );
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

    return _ensureDemoUser(users);
  }

  Future<List<_StoredUser>> _ensureDemoUser(List<_StoredUser> users) async {
    final demoEmail = DemoCredentials.email.toLowerCase();
    if (users.any((u) => u.email == demoEmail)) return users;

    final withDemo = [
      _StoredUser(
        id: 'demo-user',
        fullName: DemoCredentials.fullName,
        email: demoEmail,
        password: DemoCredentials.password,
      ),
      ...users,
    ];
    await _saveUsers(withDemo);
    return withDemo;
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
  });

  final String id;
  final String fullName;
  final String email;
  final String password;

  AppUser toAppUser() => AppUser(
        id: id,
        fullName: fullName,
        email: email,
        role: UserRole.consumer,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'fullName': fullName,
        'email': email,
        'password': password,
      };

  factory _StoredUser.fromJson(Map<String, dynamic> json) {
    return _StoredUser(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
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
