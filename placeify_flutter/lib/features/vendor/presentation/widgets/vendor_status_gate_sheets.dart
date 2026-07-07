import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../data/serverpod_vendor_profile_repository.dart';
import '../../domain/constants/vendor_strings.dart';

abstract final class VendorStatusGateSheets {
  static Future<void> showPending(BuildContext context) {
    HapticService.light();
    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _VendorStatusGateSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        title: VendorStrings.pendingSheetTitle,
        body: VendorStrings.pendingSheetBody,
        actionLabel: VendorStrings.contactSupport,
        onAction: () {
          PlaceifyToast.show(
            context,
            VendorStrings.contactSupportToast,
          );
        },
      ),
    );
  }

  static Future<void> showSuspended(BuildContext context) async {
    HapticService.light();

    VendorSuspensionStatus? status;
    try {
      status =
          await const ServerpodVendorProfileRepository().getSuspensionStatus();
    } catch (_) {}

    if (!context.mounted) return;

    return PlaceifyBottomSheet.show<void>(
      context,
      builder: (sheetContext) => _SuspendedAppealSheetBody(
        parentContext: context,
        sheetContext: sheetContext,
        initialStatus: status,
      ),
    );
  }
}

class _VendorStatusGateSheetBody extends StatelessWidget {
  const _VendorStatusGateSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.title,
    required this.body,
    required this.actionLabel,
    required this.onAction,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final String title;
  final String body;
  final String actionLabel;
  final VoidCallback onAction;

  void _onActionTap() {
    HapticService.light();
    Navigator.pop(sheetContext);
    if (parentContext.mounted) {
      onAction();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceifyBottomSheetHeader(
          title: title,
          subtitle: body,
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticService.light();
                  Navigator.pop(sheetContext);
                },
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: AppRadii.pill,
                    border: Border.all(color: AppColors.creamDark, width: 1.5),
                  ),
                  child: Text(
                    VendorStrings.dismiss,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _onActionTap,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.espresso,
                    borderRadius: AppRadii.pill,
                  ),
                  child: Text(
                    actionLabel,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.warmWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SuspendedAppealSheetBody extends StatefulWidget {
  const _SuspendedAppealSheetBody({
    required this.parentContext,
    required this.sheetContext,
    required this.initialStatus,
  });

  final BuildContext parentContext;
  final BuildContext sheetContext;
  final VendorSuspensionStatus? initialStatus;

  @override
  State<_SuspendedAppealSheetBody> createState() =>
      _SuspendedAppealSheetBodyState();
}

class _SuspendedAppealSheetBodyState extends State<_SuspendedAppealSheetBody> {
  final _messageController = TextEditingController();
  final _repository = const ServerpodVendorProfileRepository();
  bool _isSubmitting = false;
  DateTime? _appealSubmittedAt;

  @override
  void initState() {
    super.initState();
    _appealSubmittedAt = widget.initialStatus?.appealSubmittedAt;
    final existingMessage = widget.initialStatus?.appealMessage;
    if (existingMessage != null && existingMessage.isNotEmpty) {
      _messageController.text = existingMessage;
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  bool get _hasPendingAppeal => _appealSubmittedAt != null;

  Future<void> _submitAppeal() async {
    if (_hasPendingAppeal || _isSubmitting) return;

    final message = _messageController.text.trim();
    if (message.isEmpty) {
      PlaceifyToast.show(widget.parentContext, VendorStrings.appealMessageHint);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final status = await _repository.submitSuspensionAppeal(message);
      if (!mounted) return;
      setState(() {
        _appealSubmittedAt = status.appealSubmittedAt;
        _isSubmitting = false;
      });
      final parentContext = widget.parentContext;
      Navigator.pop(widget.sheetContext);
      if (!parentContext.mounted) return;
      PlaceifyToast.show(
        parentContext,
        VendorStrings.appealSubmittedToast,
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      final parentContext = widget.parentContext;
      if (!parentContext.mounted) return;
      PlaceifyToast.show(
        parentContext,
        VendorStrings.appealAlreadySubmittedToast,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moderationNote = widget.initialStatus?.moderationNote;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PlaceifyBottomSheetHeader(
          title: VendorStrings.suspendedSheetTitle,
          subtitle: VendorStrings.suspendedSheetBody,
        ),
        if (moderationNote != null && moderationNote.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: AppRadii.md,
              border: Border.all(color: AppColors.creamDark, width: 1.5),
            ),
            child: Text(
              moderationNote,
              style: GoogleFonts.dmSans(
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: _messageController,
          enabled: !_hasPendingAppeal && !_isSubmitting,
          maxLines: 4,
          minLines: 3,
          decoration: InputDecoration(
            hintText: VendorStrings.appealMessageHint,
            filled: true,
            fillColor: AppColors.warmWhite,
            border: OutlineInputBorder(
              borderRadius: AppRadii.md,
              borderSide: const BorderSide(color: AppColors.creamDark, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: AppRadii.md,
              borderSide: const BorderSide(color: AppColors.creamDark, width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticService.light();
                  Navigator.pop(widget.sheetContext);
                },
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.cream,
                    borderRadius: AppRadii.pill,
                    border: Border.all(color: AppColors.creamDark, width: 1.5),
                  ),
                  child: Text(
                    VendorStrings.dismiss,
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _hasPendingAppeal || _isSubmitting ? null : _submitAppeal,
                child: Container(
                  height: 48,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _hasPendingAppeal
                        ? AppColors.creamDark
                        : AppColors.espresso,
                    borderRadius: AppRadii.pill,
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppColors.warmWhite,
                          ),
                        )
                      : Text(
                          _hasPendingAppeal
                              ? VendorStrings.appealPendingCta
                              : VendorStrings.appealCta,
                          style: GoogleFonts.dmSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.warmWhite,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
