/// Tuning for IKEA Place–style AR furniture gestures.
abstract final class ArFurnitureGestureConfig {
  /// Multiplier applied to [ScaleUpdateDetails.rotation] (radians).
  static const rotationSensitivity = 0.85;

  /// Interpolation factor when easing rotation between frames (0–1).
  static const rotationSmoothFactor = 0.28;

  /// Ignore micro-rotations that cause jitter on small screens.
  static const rotationDeadZoneRadians = 0.004;
}
