import 'dart:io';
import 'dart:typed_data';

import 'package:placeify_client/placeify_client.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../../core/utils/local_image_path.dart';
import '../domain/models/vendor_profile.dart';
import '../domain/models/vendor_stats.dart';
import 'vendor_order_exceptions.dart';
import 'vendor_profile_mapper.dart';

typedef VendorSuspensionStatus = ({
  String? moderationNote,
  String? appealMessage,
  DateTime? appealSubmittedAt,
});

typedef VendorStoreSettings = ({
  bool isOpen,
  NotificationPreference? notificationPreferences,
  String? bankName,
  String? accountHolderName,
  String? maskedAccountNumber,
});

/// Live vendor profile, stats, and media uploads via [client.vendor].
class ServerpodVendorProfileRepository {
  const ServerpodVendorProfileRepository();

  Future<VendorProfile> getProfile(String vendorId) async {
    try {
      final detail = await client.vendor.getMyProfile();
      final profile = VendorProfileMapper.fromApiDetail(detail);
      if (profile.id != vendorId) {
        // Auth session owns the shop; vendorId from auth should match profile id.
        return profile.copyWith(id: vendorId);
      }
      return profile;
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<VendorSuspensionStatus> getSuspensionStatus() async {
    try {
      final detail = await client.vendor.getMyProfile();
      return (
        moderationNote: detail.moderationNote,
        appealMessage: detail.appealMessage,
        appealSubmittedAt: detail.appealSubmittedAt,
      );
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<VendorSuspensionStatus> submitSuspensionAppeal(String message) async {
    try {
      final detail = await client.vendor.submitSuspensionAppeal(message);
      return (
        moderationNote: detail.moderationNote,
        appealMessage: detail.appealMessage,
        appealSubmittedAt: detail.appealSubmittedAt,
      );
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<VendorStoreSettings> loadStoreSettings() async {
    try {
      final detail = await client.vendor.getMyProfile();
      final bank = await client.vendor.getMyBankDetails();
      return (
        isOpen: detail.isOpen,
        notificationPreferences: detail.notificationPreferences,
        bankName: bank?.bankName,
        accountHolderName: bank?.accountHolderName,
        maskedAccountNumber: bank == null
            ? null
            : _maskAccountNumber(bank.accountNumber),
      );
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<bool> updateStoreOpen({required bool isOpen}) async {
    try {
      final detail = await client.vendor.updateMyProfile(
        VendorProfileUpdateInput(isOpen: isOpen),
      );
      return detail.isOpen;
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<VendorProfile> updateProfile(VendorProfile profile) async {
    try {
      var working = profile;

      final logoPath = profile.logoUrl;
      if (logoPath != null && LocalImagePath.isLocal(logoPath)) {
        final uploaded = await _uploadLogo(logoPath);
        working = working.copyWith(logoUrl: uploaded);
      }

      final bannerPath = profile.bannerUrl;
      if (bannerPath != null && LocalImagePath.isLocal(bannerPath)) {
        final uploaded = await _uploadBanner(bannerPath);
        working = working.copyWith(bannerUrl: uploaded);
      }

      final detail = await client.vendor.updateMyProfile(
        VendorProfileMapper.toUpdateInput(working),
      );
      return VendorProfileMapper.fromApiDetail(detail);
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<String> uploadLogo(String localPath) => _uploadLogo(localPath);

  Future<String> uploadBanner(String localPath) => _uploadBanner(localPath);

  Future<String> uploadCover(String localPath) => _uploadCover(localPath);

  Future<VendorStats> getStats(String vendorId) async {
    try {
      final dashboard = await client.vendor.getDashboard();
      return VendorStats(
        revenue: dashboard.revenue,
        orderCount: dashboard.orderCount,
        productCount: dashboard.productCount,
        viewCount: 0,
        conversionRate: dashboard.orderCount == 0
            ? 0
            : dashboard.orderCount / dashboard.productCount.clamp(1, 999999),
        periodLabel: 'All time',
        averageRating: dashboard.shop.rating,
        responseRate: 0,
        pendingRefundCount: dashboard.pendingRefundCount,
      );
    } catch (error) {
      throw VendorOrderActionException(_mapError(error));
    }
  }

  Future<String> _uploadLogo(String localPath) async {
    final bytes = await _readFile(localPath);
    return client.vendor.uploadShopLogo(
      ByteData.sublistView(bytes),
      _fileName(localPath),
    );
  }

  Future<String> _uploadBanner(String localPath) async {
    final bytes = await _readFile(localPath);
    return client.vendor.uploadShopBanner(
      ByteData.sublistView(bytes),
      _fileName(localPath),
    );
  }

  Future<String> _uploadCover(String localPath) async {
    final bytes = await _readFile(localPath);
    return client.vendor.uploadShopCover(
      ByteData.sublistView(bytes),
      _fileName(localPath),
    );
  }

  Future<Uint8List> _readFile(String path) async {
    final file = File(LocalImagePath.normalize(path));
    if (!await file.exists()) {
      throw VendorOrderActionException('Image file could not be read.');
    }
    return file.readAsBytes();
  }

  String _fileName(String path) {
    final normalized = path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('/');
    return index == -1 ? normalized : normalized.substring(index + 1);
  }

  String _mapError(Object error) {
    if (error is VendorOrderActionException) return error.message;
    if (error is PlaceifyException) return error.message;
    final raw = error is ServerpodClientException
        ? error.message
        : error.toString();
    if (raw.toLowerCase().contains('socketexception') ||
        raw.toLowerCase().contains('connection refused')) {
      return 'Cannot reach the server. Make sure placeify_server is running.';
    }
    return raw;
  }

  String _maskAccountNumber(String accountNumber) {
    final trimmed = accountNumber.trim();
    if (trimmed.length <= 4) return '••••';
    return '•••• ${trimmed.substring(trimmed.length - 4)}';
  }
}
