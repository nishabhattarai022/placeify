/// User-facing failure from vendor product create/update/delete flows.
class VendorProductActionException implements Exception {
  VendorProductActionException(this.message);

  final String message;

  @override
  String toString() => message;
}
