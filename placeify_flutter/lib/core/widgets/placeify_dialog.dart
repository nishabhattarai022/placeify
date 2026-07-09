import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_radii.dart';
import '../constants/app_spacing.dart';
import '../services/haptic_service.dart';
import 'placeify_action_row.dart';
import 'placeify_bottom_sheet.dart';

/// Centered dialog shell aligned with the Placeify design system.
abstract final class PlaceifyDialog {
  static Color get barrierColor => AppColors.espresso.withValues(alpha: 0.32);

  static Future<T?> show<T>(
    BuildContext context, {
    required Widget child,
    Color? barrierColor,
    EdgeInsets? insetPadding,
    EdgeInsets? padding,
  }) {
    return showDialog<T>(
      context: context,
      barrierColor: barrierColor ?? PlaceifyDialog.barrierColor,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: AppColors.warmWhite,
          elevation: 0,
          insetPadding:
              insetPadding ?? const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: AppRadii.lg),
          child: Padding(
            padding: padding ?? const EdgeInsets.all(AppSpacing.xl),
            child: child,
          ),
        );
      },
    );
  }

  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    String cancelLabel = 'Cancel',
    String confirmLabel = 'Confirm',
    Color confirmColor = AppColors.espresso,
    bool isDestructive = false,
  }) {
    final resolvedConfirmColor =
        isDestructive ? AppColors.rust : confirmColor;

    return show<bool>(
      context,
      child: Builder(
        builder: (dialogContext) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PlaceifyBottomSheetHeader(title: title, subtitle: message),
              const SizedBox(height: AppSpacing.xl),
              PlaceifyActionRow(
                cancelLabel: cancelLabel,
                confirmLabel: confirmLabel,
                confirmColor: resolvedConfirmColor,
                onCancel: () {
                  HapticService.light();
                  Navigator.pop(dialogContext, false);
                },
                onConfirm: () {
                  HapticService.medium();
                  Navigator.pop(dialogContext, true);
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
