import 'package:flutter/material.dart';

import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/theme/app_fonts.dart';

/// Filter + Select controls for the My AR screen header.
class MyArToolbar extends StatelessWidget {
  const MyArToolbar({
    required this.selectionMode,
    required this.onFilterTap,
    required this.onSelectTap,
    super.key,
  });

  final bool selectionMode;
  final VoidCallback onFilterTap;
  final VoidCallback onSelectTap;

  static const Color _pillBg = Color(0xFF111111);
  static const Color _pillBorder = Color(0xFF3A3A3A);
  static const double _controlHeight = 38;
  static const double _iconSize = 17;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _CircleToolButton(
          height: _controlHeight,
          iconSize: _iconSize,
          onTap: onFilterTap,
        ),
        const SizedBox(width: 8),
        _SelectPillButton(
          height: _controlHeight,
          selectionMode: selectionMode,
          onTap: () {
            HapticService.light();
            onSelectTap();
          },
        ),
      ],
    );
  }
}

class _CircleToolButton extends StatelessWidget {
  const _CircleToolButton({
    required this.height,
    required this.iconSize,
    required this.onTap,
  });

  final double height;
  final double iconSize;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: MyArToolbar._pillBg,
      shape: const CircleBorder(
        side: BorderSide(color: MyArToolbar._pillBorder),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticService.light();
          onTap();
        },
        child: SizedBox(
          width: height,
          height: height,
          child: Icon(
            Icons.tune_rounded,
            color: Colors.white,
            size: iconSize,
          ),
        ),
      ),
    );
  }
}

class _SelectPillButton extends StatelessWidget {
  const _SelectPillButton({
    required this.height,
    required this.selectionMode,
    required this.onTap,
  });

  final double height;
  final bool selectionMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor =
        selectionMode ? Colors.black26 : MyArToolbar._pillBorder;

    return Material(
      color: selectionMode ? Colors.white : MyArToolbar._pillBg,
      shape: StadiumBorder(
        side: BorderSide(color: borderColor),
      ),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: SizedBox(
          height: height,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Text(
                selectionMode ? 'Cancel' : 'Select',
                style: AppFonts.dmSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  height: 1,
                  color: selectionMode ? Colors.black87 : Colors.white,
                  letterSpacing: -0.2,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
