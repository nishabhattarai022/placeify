import 'dart:io';
import 'dart:typed_data';

import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/config/placeify_server_client.dart';

class ConsumerProfileException implements Exception {
  ConsumerProfileException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Live consumer profile read/write via [client.user].
class ServerpodConsumerProfileRepository {
  const ServerpodConsumerProfileRepository();

  Future<User?> getCurrentProfile() async {
    if (!client.auth.isAuthenticated) return null;
    try {
      return await client.user.getCurrentUser();
    } catch (error) {
      throw ConsumerProfileException(_mapError(error));
    }
  }

  Future<User> updateProfile({
    required String name,
    String? phone,
    String? address,
  }) async {
    _requireAuthenticated();
    try {
      return await client.user.updateProfile(
        name.trim(),
        phone: phone?.trim(),
        address: address?.trim(),
      );
    } catch (error) {
      throw ConsumerProfileException(_mapError(error));
    }
  }

  Future<User> uploadProfileImage(File file) async {
    _requireAuthenticated();
    if (!await file.exists()) {
      throw ConsumerProfileException('Photo file not found.');
    }
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) {
      throw ConsumerProfileException('Photo file is empty.');
    }

    try {
      return await client.user.uploadProfileImage(
        ByteData.sublistView(bytes),
        _fileNameFromPath(file.path),
      );
    } catch (error) {
      throw ConsumerProfileException(_mapError(error));
    }
  }

  void _requireAuthenticated() {
    if (!client.auth.isAuthenticated) {
      throw ConsumerProfileException('Sign in to update your profile.');
    }
  }

  String _fileNameFromPath(String path) {
    final segments = path.split(Platform.pathSeparator);
    return segments.isEmpty ? 'profile.jpg' : segments.last;
  }

  String _mapError(Object error) {
    if (error is ConsumerProfileException) return error.message;
    if (error is PlaceifyException) return error.message;
    final text = error.toString().toLowerCase();
    if (text.contains('invalid_name')) {
      return 'Enter your name.';
    }
    if (text.contains('file_too_large')) {
      return 'Image must be 5 MB or smaller.';
    }
    if (text.contains('invalid_file_type')) {
      return 'Use a JPG, PNG, or WEBP image.';
    }
    return 'Could not update profile. Please try again.';
  }
}
