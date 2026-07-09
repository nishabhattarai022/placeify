import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../core/theme/app_fonts.dart';
import '../ar_room_ui_tokens.dart';

/// Frosted panel for controls over the AR camera feed.
///
/// [liveBlur] samples the camera behind the panel (pretty but GPU-heavy).
/// Default is off — translucent fill reads similarly on a live camera feed
/// without forcing a full [BackdropFilter] every frame.
class ArFrostedSurface extends StatelessWidget {
  const ArFrostedSurface({
    required this.child,
    this.borderRadius = const BorderRadius.all(
      Radius.circular(ArRoomUiTokens.cardRadius),
    ),
    this.padding,
    this.strong = false,
    this.liveBlur = false,
    super.key,
  });

  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry? padding;
  final bool strong;
  final bool liveBlur;

  static const _fill = Color(0x5EFEFCF8);
  static const _fillStrong = Color(0x78FEFCF8);

  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      color: strong ? _fillStrong : _fill,
      borderRadius: borderRadius,
      border: Border.all(color: ArRoomUiTokens.glassBorder),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.12),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ],
    );

    final content = padding != null ? Padding(padding: padding!, child: child) : child;

    if (!liveBlur) {
      return ClipRRect(
        borderRadius: borderRadius,
        child: DecoratedBox(decoration: decoration, child: content),
      );
    }

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: ArRoomUiTokens.blurSigma,
          sigmaY: ArRoomUiTokens.blurSigma,
        ),
        child: DecoratedBox(decoration: decoration, child: content),
      ),
    );
  }
}

/// Circular frosted icon button (close, etc.).
class ArGlassIconButton extends StatelessWidget {
  const ArGlassIconButton({
    required this.icon,
    this.onPressed,
    this.tooltip,
    super.key,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final button = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(ArRoomUiTokens.iconButtonRadius),
        child: Opacity(
          opacity: enabled ? 1 : 0.45,
          child: ArFrostedSurface(
            borderRadius: BorderRadius.circular(ArRoomUiTokens.iconButtonRadius),
            child: SizedBox(
              width: ArRoomUiTokens.iconButtonSize,
              height: ArRoomUiTokens.iconButtonSize,
              child: Icon(
                icon,
                size: 22,
                color: ArRoomUiTokens.overlayTextPrimary,
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip == null) return button;
    return Tooltip(message: tooltip!, child: button);
  }
}

/// Frosted pill label used for transient hints.
class ArFrostedPill extends StatelessWidget {
  const ArFrostedPill({
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return ArFrostedSurface(
      borderRadius: BorderRadius.circular(ArRoomUiTokens.pillRadius),
      strong: true,
      padding: padding,
      child: child,
    );
  }
}

/// Shared hint typography for AR overlays.
TextStyle arOverlayHintStyle({bool subtitle = false}) {
  return AppFonts.dmSans(
    fontSize: subtitle ? 12 : 13.5,
    fontWeight: subtitle ? FontWeight.w400 : FontWeight.w500,
    color: subtitle
        ? ArRoomUiTokens.overlayTextSecondary
        : ArRoomUiTokens.overlayTextPrimary,
    letterSpacing: -0.15,
    height: 1.35,
  );
}
