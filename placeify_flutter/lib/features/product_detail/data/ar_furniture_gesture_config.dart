abstract final class ArFurnitureGestureConfig {
  /// Multiplier applied to [ScaleUpdateDetails.rotation] (radians).
  static const rotationSensitivity = 0.85;

  /// Interpolation factor when easing rotation between frames (0–1).
  static const rotationSmoothFactor = 0.52;

  /// Smoothing for anchored drag moves on Android (0–1).
  static const panSmoothFactor = 0.32;

  /// Hold steady tracking for this long before placement is allowed.
  static const trackingSettleDelay = Duration(milliseconds: 200);

  /// Ignore micro-rotations that cause jitter on small screens.
  static const rotationDeadZoneRadians = 0.004;
}
