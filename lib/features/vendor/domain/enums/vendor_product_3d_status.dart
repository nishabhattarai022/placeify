/// Lifecycle of a vendor-authored 3D / AR model for a product listing.
enum VendorProduct3dStatus {
  none,
  draft,
  processing,
  ready,
  failed;

  bool get isReady => this == VendorProduct3dStatus.ready;

  bool get needsAttention =>
      this == VendorProduct3dStatus.none ||
      this == VendorProduct3dStatus.draft ||
      this == VendorProduct3dStatus.failed;
}
