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
}
