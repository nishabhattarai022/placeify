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
import 'package:placeify_flutter/features/admin/presentation/vendors/widgets/vendor_reinstate_sheet.dart';
import 'package:placeify_flutter/features/admin/presentation/vendors/widgets/vendor_suspend_sheet.dart';
import 'package:placeify_flutter/features/admin/presentation/widgets/admin_status_chip.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/vendor_status.dart';

class AdminVendorDetailScreen extends ConsumerWidget {
  const AdminVendorDetailScreen({required this.vendorId, super.key});

  final String vendorId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vendorAsync = ref.watch(vendorApplicationDetailProvider(vendorId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(color: AppColors.espresso),
        title: const Text(
          'Vendor',
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.espresso,
          ),
        ),
      ),
      body: vendorAsync.when(
        loading: () => const _VendorDetailShimmer(),
        error: (_, _) => _VendorDetailError(
          onRetry: () => ref.invalidate(vendorApplicationDetailProvider(vendorId)),
        ),
        data: (vendor) {
          if (vendor == null) {
            return const Center(
              child: Text(
                'Vendor not found',
                style: AppTypography.sectionTitle,
              ),
            );
          }

          if (vendor.status != VendorStatus.approved &&
              vendor.status != VendorStatus.suspended) {
            return const Center(
              child: Text(
                'Vendor not found',
                style: AppTypography.sectionTitle,
              ),
            );
          }

          return _VendorDetailBody(vendor: vendor);
        },
      ),
    );
  }
}

class _VendorDetailBody extends ConsumerWidget {
  const _VendorDetailBody({required this.vendor});

  final VendorApplication vendor;

  bool get _canSuspend => vendor.status == VendorStatus.approved;

  bool get _canReinstate => vendor.status == VendorStatus.suspended;

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
                              vendor.businessName,
                              style: AppTypography.sectionTitle.copyWith(
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${vendor.contactEmail} · ${Formatters.shortDate(vendor.submittedAt)}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      AdminStatusChip(status: vendor.status),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ApplicationDetailSections(
                  registration: vendor.registration,
                ),
              ],
            ),
          ),
        ),
        if (_canSuspend || _canReinstate)
          _VendorActionsBar(
            canSuspend: _canSuspend,
            canReinstate: _canReinstate,
            onSuspend: () {
              VendorSuspendSheet.show(
                context,
                ref,
                vendor: vendor,
                onSuspended: () {
                  if (context.mounted) context.pop();
                },
              );
            },
            onReinstate: () {
              VendorReinstateSheet.show(
                context,
                ref,
                vendor: vendor,
                onReinstated: () {
                  if (context.mounted) context.pop();
                },
              );
            },
          ),
      ],
    );
  }
}

class _VendorActionsBar extends StatelessWidget {
  const _VendorActionsBar({
    required this.canSuspend,
    required this.canReinstate,
    required this.onSuspend,
    required this.onReinstate,
  });

  final bool canSuspend;
  final bool canReinstate;
  final VoidCallback onSuspend;
  final VoidCallback onReinstate;

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
      child: GestureDetector(
        onTap: () {
          HapticService.light();
          if (canSuspend) {
            onSuspend();
          } else if (canReinstate) {
            onReinstate();
          }
        },
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: canSuspend ? AppColors.rust : AppColors.sage,
            borderRadius: AppRadii.pill,
          ),
          child: Text(
            canSuspend ? 'Suspend vendor' : 'Reinstate vendor',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.warmWhite,
            ),
          ),
        ),
      ),
    );
  }
}

class _VendorDetailShimmer extends StatelessWidget {
  const _VendorDetailShimmer();

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

class _VendorDetailError extends StatelessWidget {
  const _VendorDetailError({required this.onRetry});

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
              'Could not load vendor',
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
