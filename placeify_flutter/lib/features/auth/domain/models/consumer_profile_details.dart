/// Extended consumer profile fields shown on Edit Profile.
///
/// Core fields persist on [User] (`name`, `email`, `phone`, `profileImageUrl`).
/// Extra fields are packed into the [User.address] JSON column without a schema
/// migration (same pattern as city / username / bio).
class ConsumerProfileDetails {
  const ConsumerProfileDetails({
    required this.fullName,
    required this.email,
    this.firstName = '',
    this.lastName = '',
    this.username = '',
    this.phone = '',
    this.bio = '',
    this.gender = '',
    this.dateOfBirth = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.city = '',
    this.district = '',
    this.province = '',
    this.postalCode = '',
    this.country = '',
    this.preferredLanguage = '',
    this.defaultDeliveryAddress = '',
    this.profileImageUrl = '',
  });

  final String fullName;
  final String email;
  final String firstName;
  final String lastName;
  final String username;
  final String phone;
  final String bio;
  final String gender;
  final String dateOfBirth;
  final String addressLine1;
  final String addressLine2;
  final String city;
  final String district;
  final String province;
  final String postalCode;
  final String country;
  final String preferredLanguage;
  final String defaultDeliveryAddress;
  final String profileImageUrl;

  String get displayUsername =>
      username.trim().isNotEmpty ? '@${username.trim()}' : '';

  /// Prefer composed first+last when both are set; otherwise [fullName].
  String get resolvedFullName {
    final first = firstName.trim();
    final last = lastName.trim();
    if (first.isNotEmpty || last.isNotEmpty) {
      return [first, last].where((part) => part.isNotEmpty).join(' ');
    }
    return fullName.trim();
  }

  /// Packs extended fields into the server [User.address] column.
  static String encodeAddressPayload({
    required String city,
    required String username,
    required String bio,
    String firstName = '',
    String lastName = '',
    String gender = '',
    String dateOfBirth = '',
    String addressLine1 = '',
    String addressLine2 = '',
    String district = '',
    String province = '',
    String postalCode = '',
    String country = '',
    String preferredLanguage = '',
    String defaultDeliveryAddress = '',
  }) {
    return '{'
        '"city":${_jsonString(city)},'
        '"username":${_jsonString(username)},'
        '"bio":${_jsonString(bio)},'
        '"firstName":${_jsonString(firstName)},'
        '"lastName":${_jsonString(lastName)},'
        '"gender":${_jsonString(gender)},'
        '"dateOfBirth":${_jsonString(dateOfBirth)},'
        '"addressLine1":${_jsonString(addressLine1)},'
        '"addressLine2":${_jsonString(addressLine2)},'
        '"district":${_jsonString(district)},'
        '"province":${_jsonString(province)},'
        '"postalCode":${_jsonString(postalCode)},'
        '"country":${_jsonString(country)},'
        '"preferredLanguage":${_jsonString(preferredLanguage)},'
        '"defaultDeliveryAddress":${_jsonString(defaultDeliveryAddress)}'
        '}';
  }

  static ConsumerAddressExtras decodeAddressPayload(String? raw) {
    final value = raw?.trim() ?? '';
    if (value.isEmpty) {
      return ConsumerAddressExtras.empty;
    }
    if (value.startsWith('{')) {
      try {
        final city = _extractJsonString(value, 'city');
        final username = _extractJsonString(value, 'username');
        final bio = _extractJsonString(value, 'bio');
        if (city != null || username != null || bio != null) {
          return ConsumerAddressExtras(
            city: city ?? '',
            username: username ?? '',
            bio: bio ?? '',
            firstName: _extractJsonString(value, 'firstName') ?? '',
            lastName: _extractJsonString(value, 'lastName') ?? '',
            gender: _extractJsonString(value, 'gender') ?? '',
            dateOfBirth: _extractJsonString(value, 'dateOfBirth') ?? '',
            addressLine1: _extractJsonString(value, 'addressLine1') ?? '',
            addressLine2: _extractJsonString(value, 'addressLine2') ?? '',
            district: _extractJsonString(value, 'district') ?? '',
            province: _extractJsonString(value, 'province') ?? '',
            postalCode: _extractJsonString(value, 'postalCode') ?? '',
            country: _extractJsonString(value, 'country') ?? '',
            preferredLanguage:
                _extractJsonString(value, 'preferredLanguage') ?? '',
            defaultDeliveryAddress:
                _extractJsonString(value, 'defaultDeliveryAddress') ?? '',
          );
        }
      } catch (_) {}
    }
    // Legacy plain-text address → treat as city / address line 1.
    return ConsumerAddressExtras(
      city: value,
      addressLine1: value,
    );
  }

  static String _jsonString(String value) {
    final escaped = value
        .replaceAll(r'\', r'\\')
        .replaceAll('"', r'\"')
        .replaceAll('\n', r'\n')
        .replaceAll('\r', r'\r')
        .replaceAll('\t', r'\t');
    return '"$escaped"';
  }

  static String? _extractJsonString(String json, String key) {
    final pattern = RegExp('"$key"\\s*:\\s*"((?:\\\\.|[^"\\\\])*)"');
    final match = pattern.firstMatch(json);
    if (match == null) return null;
    return match
        .group(1)!
        .replaceAll(r'\"', '"')
        .replaceAll(r'\\', r'\')
        .replaceAll(r'\n', '\n')
        .replaceAll(r'\r', '\r')
        .replaceAll(r'\t', '\t');
  }

  ConsumerProfileDetails copyWith({
    String? fullName,
    String? email,
    String? firstName,
    String? lastName,
    String? username,
    String? phone,
    String? bio,
    String? gender,
    String? dateOfBirth,
    String? addressLine1,
    String? addressLine2,
    String? city,
    String? district,
    String? province,
    String? postalCode,
    String? country,
    String? preferredLanguage,
    String? defaultDeliveryAddress,
    String? profileImageUrl,
  }) {
    return ConsumerProfileDetails(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      gender: gender ?? this.gender,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      addressLine1: addressLine1 ?? this.addressLine1,
      addressLine2: addressLine2 ?? this.addressLine2,
      city: city ?? this.city,
      district: district ?? this.district,
      province: province ?? this.province,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      defaultDeliveryAddress:
          defaultDeliveryAddress ?? this.defaultDeliveryAddress,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
    );
  }
}

/// Decoded extras stored inside [User.address] JSON.
class ConsumerAddressExtras {
  const ConsumerAddressExtras({
    this.city = '',
    this.username = '',
    this.bio = '',
    this.firstName = '',
    this.lastName = '',
    this.gender = '',
    this.dateOfBirth = '',
    this.addressLine1 = '',
    this.addressLine2 = '',
    this.district = '',
    this.province = '',
    this.postalCode = '',
    this.country = '',
    this.preferredLanguage = '',
    this.defaultDeliveryAddress = '',
  });

  static const empty = ConsumerAddressExtras();

  final String city;
  final String username;
  final String bio;
  final String firstName;
  final String lastName;
  final String gender;
  final String dateOfBirth;
  final String addressLine1;
  final String addressLine2;
  final String district;
  final String province;
  final String postalCode;
  final String country;
  final String preferredLanguage;
  final String defaultDeliveryAddress;
}
