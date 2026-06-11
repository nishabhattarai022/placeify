import 'package:flutter/material.dart';
import '../constants/app_typography.dart';

/// Shared logo wordmark for AR and other screens.
class PlaceifyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PlaceifyAppBar({super.key, this.actions});

  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: RichText(
        text: TextSpan(
          style: AppTypography.logoWordmark,
          children: const [
            TextSpan(text: 'Place'),
            TextSpan(
              text: 'ify',
              style: TextStyle(color: Color(0xFFC17F3C)),
            ),
          ],
        ),
      ),
      actions: actions,
    );
  }
}
