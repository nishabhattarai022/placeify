import 'package:flutter/material.dart';

/// Persistent Done action — always visible after furniture is placed.
class ArDoneButton extends StatelessWidget {
  const ArDoneButton({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onDone,
      style: FilledButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.25),
      ),
      child: const Text(
        'Done',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }
}

/// Rotate / Reset / Scale controls that auto-hide when idle.
class ArEditingToolbar extends StatelessWidget {
  const ArEditingToolbar({
    required this.visible,
    required this.scaleMultiplier,
    required this.minMultiplier,
    required this.maxMultiplier,
    required this.onRotate,
    required this.onScaleChanged,
    required this.onReset,
    super.key,
  });

  final bool visible;
  final double scaleMultiplier;
  final double minMultiplier;
  final double maxMultiplier;
  final VoidCallback onRotate;
  final ValueChanged<double> onScaleChanged;
  final VoidCallback onReset;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      offset: visible ? Offset.zero : const Offset(0, 0.35),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 220),
        opacity: visible ? 1 : 0,
        child: IgnorePointer(
          ignoring: !visible,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.62),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        _ToolbarIconButton(
                          icon: Icons.rotate_right_outlined,
                          label: 'Rotate',
                          onTap: onRotate,
                        ),
                        const SizedBox(width: 8),
                        _ToolbarIconButton(
                          icon: Icons.restart_alt_outlined,
                          label: 'Reset',
                          onTap: onReset,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.straighten,
                          color: Colors.white70,
                          size: 18,
                        ),
                        Expanded(
                          child: Slider(
                            value: scaleMultiplier,
                            min: minMultiplier,
                            max: maxMultiplier,
                            divisions: 15,
                            label: '${(scaleMultiplier * 100).round()}%',
                            onChanged: onScaleChanged,
                          ),
                        ),
                        Text(
                          '${(scaleMultiplier * 100).round()}%',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ToolbarIconButton extends StatelessWidget {
  const _ToolbarIconButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(height: 2),
            Text(
              label,
              style: const TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
