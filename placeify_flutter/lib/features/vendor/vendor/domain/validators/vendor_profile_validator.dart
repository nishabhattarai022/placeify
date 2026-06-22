import 'package:placeify_flutter/features/vendor/domain/constants/vendor_profile_strings.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_operating_day.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_profile.dart';

/// Map keys for inline field error display on the vendor profile form.
abstract final class VendorProfileFieldKeys {
  static const businessName = 'businessName';
  static const bio = 'bio';
  static const email = 'email';
  static const phone = 'phone';
  static const tags = 'tags';
  static const instagram = 'instagram';
  static const facebook = 'facebook';
  static const website = 'website';

  static String schedule(String dayKey) => 'schedule_$dayKey';
}

/// Pure-Dart validation for vendor profile edit forms.
abstract final class VendorProfileValidator {
  static const storeNameMinLength = 3;
  static const storeNameMaxLength = 50;
  static const bioMaxLength = VendorProfileStrings.bioMaxLength;
  static const tagsMinCount = 1;
  static const tagsMaxCount = 5;
  static const phoneMinDigits = 7;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static final _phoneCharsRegex = RegExp(r'^[0-9+\-() ]+$');
  static final _httpPrefixRegex = RegExp(r'^https?://', caseSensitive: false);
  static final _domainRegex = RegExp(
    r'^([\w-]+\.)+[\w-]{2,}(/[\w\-./?%&=]*)?$',
    caseSensitive: false,
  );

  /// Returns a map of field keys to error messages. Empty when valid.
  static Map<String, String> validate(VendorProfile profile) {
    final errors = <String, String>{};

    _validateBusinessName(profile.businessName, errors);
    _validateBio(profile.bio, errors);
    _validateEmail(profile.email, errors);
    _validatePhone(profile.phone, errors);
    _validateTags(profile.tags, errors);
    _validateSchedule(profile.schedule, errors);
    _validateSocialUrl(
      profile.socialLinks.instagram,
      VendorProfileFieldKeys.instagram,
      VendorProfileStrings.instagramUrlInvalid,
      errors,
    );
    _validateSocialUrl(
      profile.socialLinks.facebook,
      VendorProfileFieldKeys.facebook,
      VendorProfileStrings.facebookUrlInvalid,
      errors,
    );
    _validateSocialUrl(
      profile.socialLinks.website,
      VendorProfileFieldKeys.website,
      VendorProfileStrings.websiteUrlInvalid,
      errors,
    );

    return errors;
  }

  static bool isValid(VendorProfile profile) => validate(profile).isEmpty;

  static void _validateBusinessName(String value, Map<String, String> errors) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      errors[VendorProfileFieldKeys.businessName] =
          VendorProfileStrings.storeNameRequired;
      return;
    }
    if (trimmed.length < storeNameMinLength) {
      errors[VendorProfileFieldKeys.businessName] =
          VendorProfileStrings.storeNameTooShort;
      return;
    }
    if (trimmed.length > storeNameMaxLength) {
      errors[VendorProfileFieldKeys.businessName] =
          VendorProfileStrings.storeNameTooLong;
    }
  }

  static void _validateBio(String value, Map<String, String> errors) {
    if (value.length > bioMaxLength) {
      errors[VendorProfileFieldKeys.bio] = VendorProfileStrings.bioTooLong;
    }
  }

  static void _validateEmail(String value, Map<String, String> errors) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      errors[VendorProfileFieldKeys.email] = VendorProfileStrings.emailRequired;
      return;
    }
    if (!_emailRegex.hasMatch(trimmed)) {
      errors[VendorProfileFieldKeys.email] = VendorProfileStrings.emailInvalid;
    }
  }

  static void _validatePhone(String value, Map<String, String> errors) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      errors[VendorProfileFieldKeys.phone] = VendorProfileStrings.phoneRequired;
      return;
    }
    if (!_phoneCharsRegex.hasMatch(trimmed) ||
        _digitCount(trimmed) < phoneMinDigits) {
      errors[VendorProfileFieldKeys.phone] = VendorProfileStrings.phoneInvalid;
    }
  }

  static void _validateTags(List<String> tags, Map<String, String> errors) {
    final nonEmptyTags =
        tags.map((tag) => tag.trim()).where((tag) => tag.isNotEmpty).toList();
    if (nonEmptyTags.length < tagsMinCount) {
      errors[VendorProfileFieldKeys.tags] = VendorProfileStrings.tagsRequired;
      return;
    }
    if (nonEmptyTags.length > tagsMaxCount) {
      errors[VendorProfileFieldKeys.tags] = VendorProfileStrings.tagsTooMany;
    }
  }

  static void _validateSchedule(
    List<VendorOperatingDay> schedule,
    Map<String, String> errors,
  ) {
    for (final day in schedule) {
      if (day.isClosed) continue;

      final openMinutes = _minutesFromHhMm(day.openTime);
      final closeMinutes = _minutesFromHhMm(day.closeTime);
      final fieldKey = VendorProfileFieldKeys.schedule(day.dayKey);

      if (openMinutes == null || closeMinutes == null) {
        errors[fieldKey] = VendorProfileStrings.scheduleInvalidTime;
        continue;
      }
      if (openMinutes >= closeMinutes) {
        errors[fieldKey] = VendorProfileStrings.scheduleCloseBeforeOpen(
          VendorProfileStrings.dayLabel(day.dayKey),
        );
      }
    }
  }

  static void _validateSocialUrl(
    String value,
    String fieldKey,
    String errorMessage,
    Map<String, String> errors,
  ) {
    if (value.trim().isEmpty) return;
    if (!_isValidSocialUrl(value)) {
      errors[fieldKey] = errorMessage;
    }
  }

  static bool _isValidSocialUrl(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return true;
    if (_httpPrefixRegex.hasMatch(trimmed)) return true;
    return _domainRegex.hasMatch(trimmed);
  }

  static int _digitCount(String value) =>
      RegExp(r'\d').allMatches(value).length;

  static int? _minutesFromHhMm(String time) {
    final parts = time.split(':');
    if (parts.length != 2) return null;

    final hours = int.tryParse(parts[0]);
    final minutes = int.tryParse(parts[1]);
    if (hours == null || minutes == null) return null;
    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) return null;

    return hours * 60 + minutes;
  }
}
