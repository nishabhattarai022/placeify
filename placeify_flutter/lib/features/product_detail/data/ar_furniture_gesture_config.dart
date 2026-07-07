/// Tuning for IKEA Place–style AR furniture gestures.
abstract final class ArFurnitureGestureConfig {
  /// Multiplier applied to [ScaleUpdateDetails.rotation] (radians).
  static const rotationSensitivity = 0.85;

  /// Interpolation factor when easing rotation between frames (0–1).
  static const rotationSmoothFactor = 0.28;

  /// Smoothing for anchored drag moves on Android (0–1).
  static const panSmoothFactor = 0.32;

  /// Retries for auto-placement after floor detection.
  static const maxAutoPlaceAttempts = 10;

  /// Delay between auto-placement retries.
  static const autoPlaceRetryDelay = Duration(milliseconds: 180);

  /// Wait for plane refinement before anchoring furniture.
  static const planeStabilizeDelay = Duration(milliseconds: 750);

  /// Hold steady tracking for this long before placement is allowed.
  static const trackingSettleDelay = Duration(milliseconds: 500);

  /// Ignore micro-rotations that cause jitter on small screens.
  static const rotationDeadZoneRadians = 0.004;
}
