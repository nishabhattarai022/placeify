import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';
import 'placeify_pill_button.dart';

/// Horizontal cancel + confirm pill buttons for modals and bottom sheets.
class PlaceifyActionRow extends StatelessWidget {
  const PlaceifyActionRow({
    required this.cancelLabel,
    required this.confirmLabel,
    required this.onCancel,
    required this.onConfirm,
    this.confirmColor = Colors.black,
    this.confirmTextColor = Colors.white,
    this.isConfirmLoading = false,
    this.confirmEnabled = true,
    super.key,
  });

  final String cancelLabel;
  final String confirmLabel;
  final VoidCallback? onCancel;
  final VoidCallback? onConfirm;
  final Color confirmColor;
  final Color confirmTextColor;
  final bool isConfirmLoading;
  final bool confirmEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PlaceifyPillButton(
            label: cancelLabel,
            variant: PlaceifyPillVariant.secondary,
            onTap: isConfirmLoading ? null : onCancel,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: PlaceifyPillButton(
            label: confirmLabel,
            color: confirmColor,
            textColor: confirmTextColor,
            enabled: confirmEnabled,
            isLoading: isConfirmLoading,
            onTap: onConfirm,
          ),
        ),
      ],
    );
  }
}

/// Vertical confirm-above-cancel layout for destructive flows.
class PlaceifyStackedActions extends StatelessWidget {
  const PlaceifyStackedActions({
    required this.confirmLabel,
    required this.cancelLabel,
    required this.onConfirm,
    required this.onCancel,
    this.confirmColor = AppColors.coral,
    this.confirmEnabled = true,
    this.isConfirmLoading = false,
    super.key,
  });

  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Color confirmColor;
  final bool confirmEnabled;
  final bool isConfirmLoading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PlaceifyPillButton(
          label: confirmLabel,
          color: confirmColor,
          enabled: confirmEnabled,
          isLoading: isConfirmLoading,
          onTap: onConfirm,
        ),
        const SizedBox(height: AppSpacing.sm + 2),
        PlaceifyPillButton(
          label: cancelLabel,
          variant: PlaceifyPillVariant.secondary,
          onTap: isConfirmLoading ? null : onCancel,
        ),
      ],
    );
  }
}
