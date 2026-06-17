class VendorOrderActionException implements Exception {
  VendorOrderActionException(this.message);

  final String message;

  @override
  String toString() => message;
}
