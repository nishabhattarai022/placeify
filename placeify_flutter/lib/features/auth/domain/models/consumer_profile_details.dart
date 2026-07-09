/// Extended consumer profile fields shown on Edit Profile.
class ConsumerProfileDetails {
  const ConsumerProfileDetails({
    required this.fullName,
    required this.email,
    this.username = '',
    this.phone = '',
    this.bio = '',
    this.city = '',
  });

  final String fullName;
  final String email;
  final String username;
  final String phone;
  final String bio;
  final String city;

  String get displayUsername =>
      username.trim().isNotEmpty ? '@${username.trim()}' : '';

  ConsumerProfileDetails copyWith({
    String? fullName,
    String? email,
    String? username,
    String? phone,
    String? bio,
    String? city,
  }) {
    return ConsumerProfileDetails(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      username: username ?? this.username,
      phone: phone ?? this.phone,
      bio: bio ?? this.bio,
      city: city ?? this.city,
    );
  }
}
