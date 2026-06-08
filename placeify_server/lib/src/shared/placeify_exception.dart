/// Application-level error with a stable code for clients.
class PlaceifyException implements Exception {
  PlaceifyException(this.message, {required this.code});

  final String message;
  final String code;

  @override
  String toString() => '$code: $message';
}
