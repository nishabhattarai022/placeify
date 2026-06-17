import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/constants/app_radii.dart';
import 'package:placeify_flutter/core/constants/app_spacing.dart';
import 'package:placeify_flutter/core/constants/app_typography.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/utils/formatters.dart';
import 'package:placeify_flutter/core/widgets/shimmer_loader.dart';
import 'package:placeify_flutter/features/admin/domain/models/vendor_application.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/vendor_applications_provider.dart';
import 'package:placeify_flutter/features/admin/presentation/vendor_approvals/widgets/application_detail_sections.dart';
import 'package:placeify_flutter/features/admin/presentation/vendor_approvals/widgets/vendor_application_approve_sheet.dart';
import 'package:placeify_flutter/features/admin/presentation/vendor_approvals/widgets/vendor_application_decline_sheet.dart';
import 'package:placeify_flutter/features/admin/presentation/widgets/admin_status_chip.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';

class VendorApplicationDetailScreen extends ConsumerWidget {
  const VendorApplicationDetailScreen({
    required this.applicationId,
    super.key,
  });

  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final applicationAsync =
        ref.watch(vendorApplicationDetailProvider(applicationId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.espresso),
        title: const Text(
          'Application',
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.espresso,
          ),
        ),
      ),
      body: applicationAsync.when(
        loading: () => const _ApplicationDetailShimmer(),
        error: (_, __) => _ApplicationDetailError(
          onRetry: () =>
              ref.invalidate(vendorApplicationDetailProvider(applicationId)),
        ),
        data: (application) {
          if (application == null) {
            return const Center(
              child: Text(
                'Application not found',
                style: AppTypography.sectionTitle,
              ),
            );
          }

          return _ApplicationDetailBody(
            application: application,
            applicationId: applicationId,
          );
        },
      ),
    );
  }
}

class _ApplicationDetailBody extends ConsumerWidget {
  const _ApplicationDetailBody({
    required this.application,
    required this.applicationId,
  });

  final VendorApplication application;
  final String applicationId;

  bool get _canReview => application.status == VendorStatus.pending;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenPadding,
              0,
              AppSpacing.screenPadding,
              24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.warmWhite,
                    borderRadius: AppRadii.md,
                    border: Border.all(color: AppColors.creamDark, width: 1.5),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              application.businessName,
                              style: AppTypography.sectionTitle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${application.contactEmail} · ${Formatters.shortDate(application.submittedAt)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AdminStatusChip(status: application.status),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ApplicationDetailSections(
                  registration: application.registration,
                ),
              ],
            ),
          ),
        ),
        if (_canReview)
          _ReviewActionsBar(
            onDecline: () {
              VendorApplicationDeclineSheet.show(
                context,
                ref,
                application: application,
                onDeclined: () {
                  if (context.mounted) context.pop();
                },
              );
            },
            onApprove: () {
              VendorApplicationApproveSheet.show(
                context,
                ref,
                application: application,
                onApproved: () {
                  if (context.mounted) context.pop();
                },
              );
            },
          ),
      ],
    );
  }
}

class _ReviewActionsBar extends StatelessWidget {
  const _ReviewActionsBar({
    required this.onDecline,
    required this.onApprove,
  });

  final VoidCallback onDecline;
  final VoidCallback onApprove;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 12 + bottomInset),
      decoration: const BoxDecoration(
        color: AppColors.warmWhite,
        border: Border(
          top: BorderSide(color: AppColors.creamDark, width: 1.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticService.light();
                onDecline();
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  borderRadius: AppRadii.pill,
                  border: Border.all(color: AppColors.creamDark, width: 1.5),
                ),
                child: const Text(
                  'Decline',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.rust,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticService.light();
                onApprove();
              },
              child: Container(
                height: 48,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.sage,
                  borderRadius: AppRadii.pill,
                ),
                child: const Text(
                  'Approve',
                  style: TextStyle(
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
    );
  }
}

class _ApplicationDetailShimmer extends StatelessWidget {
  const _ApplicationDetailShimmer();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          SizedBox(
            height: 88,
            child: ShimmerLoader(borderRadius: AppRadii.md),
          ),
          SizedBox(height: 16),
          Expanded(child: ShimmerLoader(borderRadius: AppRadii.md)),
        ],
      ),
    );
  }
}

class _ApplicationDetailError extends StatelessWidget {
  const _ApplicationDetailError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Could not load application',
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: 12),
            TextButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
