import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../core/services/haptic_service.dart';
import '../../../core/theme/app_fonts.dart';
import '../../../core/widgets/toast_overlay.dart';
import 'ar_hub_tokens.dart';
import 'widgets/ar_compact_cta_button.dart';
import 'widgets/ar_feature_showcase.dart';
import 'widgets/ar_powered_app_bar.dart';

class ArPoweredScreen extends StatefulWidget {
  const ArPoweredScreen({super.key});

  @override
  State<ArPoweredScreen> createState() => _ArPoweredScreenState();
}

class _ArPoweredScreenState extends State<ArPoweredScreen> {
  static final _headlineStyle = AppFonts.dmSans(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: ArHubTokens.textPrimary,
    height: 1.25,
    letterSpacing: -0.3,
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  void _showMoreMenu() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(
                Icons.photo_library_outlined,
                color: ArHubTokens.textPrimary,
              ),
              title: Text(
                'Saved Room Shots',
                style: AppFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  color: ArHubTokens.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                HapticService.light();
                context.pushNamed('profileRoomSnapshots');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.view_in_ar_outlined,
                color: ArHubTokens.textPrimary,
              ),
              title: Text(
                'AR History',
                style: AppFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  color: ArHubTokens.textPrimary,
                ),
              ),
              onTap: () {
                Navigator.pop(sheetContext);
                HapticService.light();
                context.pushNamed('profileArHistory');
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openArAssistant() {
    HapticService.heavy();
    PlaceifyToast.show(context, 'In progress / Building');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ArHubTokens.background,
      body: Column(
        children: [
          ArPoweredAppBar(onMoreTap: _showMoreMenu),
          Expanded(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    ArHubTokens.screenPadding,
                    ArHubTokens.heroTopSpacing,
                    ArHubTokens.screenPadding,
                    0,
                  ),
                  child: Column(
                    children: [
                      Text(
                        ArHubTokens.headlineLine1,
                        textAlign: TextAlign.center,
                        style: _headlineStyle,
                      ),
                      Text(
                        ArHubTokens.headlineLine2,
                        textAlign: TextAlign.center,
                        style: _headlineStyle,
                      ),
                      const SizedBox(height: 14),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: Text(
                          ArHubTokens.body,
                          textAlign: TextAlign.center,
                          style: AppFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: ArHubTokens.textSecondary,
                            height: 1.55,
                          ),
                        ),
                      ),
                      const SizedBox(height: 22),
                      ArCompactCtaButton(onTap: _openArAssistant),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Expanded(child: ArFeatureShowcase()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
