import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_fonts.dart';
import '../ar_hub_tokens.dart';
import 'ar_hub_icon_button.dart';

class ArPoweredAppBar extends StatelessWidget {
  const ArPoweredAppBar({
    required this.onMoreTap,
    super.key,
  });

  final VoidCallback onMoreTap;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        ArHubTokens.screenPadding,
        top + 8,
        ArHubTokens.screenPadding,
        8,
      ),
      child: Row(
        children: [
          ArHubIconButton(
            onTap: () => context.pop(),
            child: const Icon(
              Icons.chevron_left_rounded,
              size: 24,
              color: ArHubTokens.textPrimary,
            ),
          ),
          Expanded(
            child: Text(
              ArHubTokens.appBarTitle,
              textAlign: TextAlign.center,
              style: AppFonts.dmSerifDisplay(
                fontSize: 17,
                fontWeight: FontWeight.w400,
                fontStyle: FontStyle.italic,
                color: ArHubTokens.textPrimary,
              ),
            ),
          ),
          ArHubIconButton(
            onTap: onMoreTap,
            child: const Icon(
              Icons.more_vert,
              size: 20,
              color: ArHubTokens.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
