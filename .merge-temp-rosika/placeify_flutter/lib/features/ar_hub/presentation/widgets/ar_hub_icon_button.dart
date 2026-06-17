import 'package:flutter/material.dart';

import '../../../../core/services/haptic_service.dart';
import '../ar_hub_tokens.dart';

class ArHubIconButton extends StatelessWidget {
  const ArHubIconButton({
    required this.onTap,
    required this.child,
    super.key,
  });

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticService.light();
        onTap();
      },
      child: Container(
        width: ArHubTokens.headerButtonSize,
        height: ArHubTokens.headerButtonSize,
        decoration: ArHubTokens.headerButtonDecoration,
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}
