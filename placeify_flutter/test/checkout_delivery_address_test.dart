import 'package:flutter_test/flutter_test.dart';
import 'package:placeify_flutter/features/auth/domain/models/consumer_profile_details.dart';

void main() {
  group('ConsumerAddressExtras.formattedDeliveryAddress', () {
    test('does not dump raw profile JSON into the delivery field', () {
      final raw = ConsumerProfileDetails.encodeAddressPayload(
        city: 'Kathmandu',
        username: 'rosika',
        bio: 'Loves furniture',
        gender: 'female',
        dateOfBirth: '2000-01-01',
        addressLine1: 'Baneshwor',
        addressLine2: 'Near temple',
        district: 'Kathmandu',
        province: 'Bagmati',
        postalCode: '44600',
        country: 'Nepal',
        preferredLanguage: 'en',
        defaultDeliveryAddress: '',
      );

      final formatted =
          ConsumerProfileDetails.decodeAddressPayload(raw).formattedDeliveryAddress;

      expect(formatted, isNot(contains('username')));
      expect(formatted, isNot(contains('bio')));
      expect(formatted, isNot(contains('gender')));
      expect(formatted, isNot(contains('dateOfBirth')));
      expect(formatted, contains('Baneshwor'));
      expect(formatted, contains('Nepal'));
      // 'Kathmandu' is already in addressLine1='Baneshwor' substring? No, but
      // district='Kathmandu' equals city='Kathmandu' so Kathmandu appears only once.
      final kathmandus = 'Kathmandu'.allMatches(formatted).length;
      expect(kathmandus, equals(1),
          reason: 'Kathmandu must not appear twice (city == district dedup)');
    });

    test('city not repeated when addressLine1 already contains it', () {
      final raw = ConsumerProfileDetails.encodeAddressPayload(
        city: 'Pokhara',
        username: '',
        bio: '',
        addressLine1: 'Lakeside, Pokhara',
        district: '',
        province: 'Gandaki',
        country: 'Nepal',
      );

      final formatted =
          ConsumerProfileDetails.decodeAddressPayload(raw).formattedDeliveryAddress;

      final pokharas = 'Pokhara'.allMatches(formatted).length;
      expect(pokharas, equals(1),
          reason: 'Pokhara already in addressLine1; should not repeat');
    });

    test('prefers defaultDeliveryAddress when set', () {
      final raw = ConsumerProfileDetails.encodeAddressPayload(
        city: 'Pokhara',
        username: 'user',
        bio: '',
        addressLine1: 'Lakeside',
        defaultDeliveryAddress: 'Office: Durbar Marg, Kathmandu',
      );

      expect(
        ConsumerProfileDetails.decodeAddressPayload(raw).formattedDeliveryAddress,
        'Office: Durbar Marg, Kathmandu',
      );
    });

    test('returns empty when profile has no address lines', () {
      final raw = ConsumerProfileDetails.encodeAddressPayload(
        city: '',
        username: 'only-username',
        bio: 'only bio',
      );

      expect(
        ConsumerProfileDetails.decodeAddressPayload(raw).formattedDeliveryAddress,
        isEmpty,
      );
    });
  });
}
