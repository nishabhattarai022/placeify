import 'package:flutter/material.dart';

import 'package:placeify/core/services/haptic_service.dart';
import 'package:placeify/core/theme/app_fonts.dart';

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

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _CircleToolButton(
          icon: Icons.tune_rounded,
          onTap: onFilterTap,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Material(
            color: selectionMode ? Colors.white : _pillBg,
            borderRadius: BorderRadius.circular(999),
            child: InkWell(
              borderRadius: BorderRadius.circular(999),
              onTap: () {
                HapticService.light();
                onSelectTap();
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: selectionMode ? Colors.black26 : _pillBorder,
                  ),
                ),
                child: Text(
                  selectionMode ? 'Cancel' : 'Select',
                  style: AppFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: selectionMode ? Colors.black87 : Colors.white,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CircleToolButton extends StatelessWidget {
  const _CircleToolButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF111111),
      shape: const CircleBorder(
        side: BorderSide(color: Color(0xFF3A3A3A)),
      ),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: () {
          HapticService.light();
          onTap();
        },
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
