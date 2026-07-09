/// Dial codes and local-number hints for the vendor phone input.
class CountryPhoneCode {
  const CountryPhoneCode({
    required this.isoCode,
    required this.name,
    required this.dialCode,
    required this.localPlaceholder,
    this.localMaxLength = 10,
  });

  final String isoCode;
  final String name;
  final String dialCode;
  final String localPlaceholder;
  final int localMaxLength;
}

abstract final class CountryPhoneCodes {
  static const defaultCountry = nepal;

  static const nepal = CountryPhoneCode(
    isoCode: 'NP',
    name: 'Nepal',
    dialCode: '+977',
    localPlaceholder: '980823094',
  );

  static const australia = CountryPhoneCode(
    isoCode: 'AU',
    name: 'Australia',
    dialCode: '+61',
    localPlaceholder: '412345678',
    localMaxLength: 9,
  );

  static const bangladesh = CountryPhoneCode(
    isoCode: 'BD',
    name: 'Bangladesh',
    dialCode: '+880',
    localPlaceholder: '1712345678',
  );

  static const canada = CountryPhoneCode(
    isoCode: 'CA',
    name: 'Canada',
    dialCode: '+1',
    localPlaceholder: '4165550123',
  );

  static const china = CountryPhoneCode(
    isoCode: 'CN',
    name: 'China',
    dialCode: '+86',
    localPlaceholder: '13800138000',
    localMaxLength: 11,
  );

  static const france = CountryPhoneCode(
    isoCode: 'FR',
    name: 'France',
    dialCode: '+33',
    localPlaceholder: '612345678',
    localMaxLength: 9,
  );

  static const germany = CountryPhoneCode(
    isoCode: 'DE',
    name: 'Germany',
    dialCode: '+49',
    localPlaceholder: '15123456789',
    localMaxLength: 11,
  );

  static const india = CountryPhoneCode(
    isoCode: 'IN',
    name: 'India',
    dialCode: '+91',
    localPlaceholder: '9876543210',
  );

  static const japan = CountryPhoneCode(
    isoCode: 'JP',
    name: 'Japan',
    dialCode: '+81',
    localPlaceholder: '9012345678',
    localMaxLength: 10,
  );

  static const singapore = CountryPhoneCode(
    isoCode: 'SG',
    name: 'Singapore',
    dialCode: '+65',
    localPlaceholder: '81234567',
    localMaxLength: 8,
  );

  static const uae = CountryPhoneCode(
    isoCode: 'AE',
    name: 'United Arab Emirates',
    dialCode: '+971',
    localPlaceholder: '501234567',
    localMaxLength: 9,
  );

  static const unitedKingdom = CountryPhoneCode(
    isoCode: 'GB',
    name: 'United Kingdom',
    dialCode: '+44',
    localPlaceholder: '7911123456',
    localMaxLength: 10,
  );

  static const unitedStates = CountryPhoneCode(
    isoCode: 'US',
    name: 'United States',
    dialCode: '+1',
    localPlaceholder: '5551234567',
  );

  /// Nepal pinned first; remaining entries sorted alphabetically by name.
  static const List<CountryPhoneCode> all = [
    nepal,
    australia,
    bangladesh,
    canada,
    china,
    france,
    germany,
    india,
    japan,
    singapore,
    uae,
    unitedKingdom,
    unitedStates,
  ];

  /// Longest-match dial-code scan; falls back to [defaultCountry].
  static ({CountryPhoneCode country, String local}) parsePhone(String? raw) {
    if (raw == null || raw.trim().isEmpty) {
      return (country: defaultCountry, local: '');
    }

    final normalized = raw.replaceAll(RegExp(r'[\s\-().]'), '');
    if (!normalized.startsWith('+')) {
      final digits = normalized.replaceAll(RegExp(r'\D'), '');
      return (country: defaultCountry, local: digits);
    }

    final byDialLength = [...all]
      ..sort((a, b) => b.dialCode.length.compareTo(a.dialCode.length));

    for (final country in byDialLength) {
      if (normalized.startsWith(country.dialCode)) {
        final local = normalized
            .substring(country.dialCode.length)
            .replaceAll(RegExp(r'\D'), '');
        return (country: country, local: local);
      }
    }

    final fallbackLocal = normalized.replaceAll(RegExp(r'\D'), '');
    return (country: defaultCountry, local: fallbackLocal);
  }

  /// Returns an error message when invalid, otherwise null.
  static String? validatePhone(String raw) {
    final parsed = parsePhone(raw);
    if (parsed.local.length < 7) {
      return 'Enter a valid phone number';
    }

    if (parsed.country.isoCode == nepal.isoCode) {
      final isNepalMobile = parsed.local.length == 10 &&
          (parsed.local.startsWith('97') || parsed.local.startsWith('98'));
      if (!isNepalMobile) {
        return 'Enter a valid Nepal mobile number (10 digits starting with 97 or 98)';
      }
    }

    return null;
  }
}
