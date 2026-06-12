import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/shimmer_loader.dart';
import 'package:placeify/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify/features/admin/domain/enums/vendor_application_list_filter.dart';
import 'package:placeify/features/admin/presentation/providers/admin_stats_provider.dart';
import 'package:placeify/features/admin/presentation/providers/vendor_applications_provider.dart';
import 'package:placeify/features/admin/presentation/vendor_approvals/widgets/application_filter_chips.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_application_row.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_empty_state.dart';

class VendorApplicationsScreen extends ConsumerStatefulWidget {
  const VendorApplicationsScreen({super.key});

  @override
  ConsumerState<VendorApplicationsScreen> createState() =>
      _VendorApplicationsScreenState();
}

class _VendorApplicationsScreenState
    extends ConsumerState<VendorApplicationsScreen> {
  VendorApplicationListFilter _filter = VendorApplicationListFilter.pending;
  bool _hasLoaded = false;

  Future<void> _onRefresh() async {
    await ref
        .read(vendorApplicationsListProvider(_filter).notifier)
        .refresh();
  }

  String _emptyMessage() {
    return switch (_filter) {
      VendorApplicationListFilter.pending => AdminStrings.allCaughtUpPending,
      VendorApplicationListFilter.approved => 'No approved applications',
      VendorApplicationListFilter.declined => 'No declined applications',
    };
  }

  @override
  Widget build(BuildContext context) {
    final applicationsAsync = ref.watch(vendorApplicationsListProvider(_filter));
    final statsAsync = ref.watch(adminStatsProvider);
    final stats = statsAsync.value;

    applicationsAsync.whenData((_) {
      if (!_hasLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _hasLoaded = true);
        });
      }
    });

    final showShimmer = applicationsAsync.isLoading && !_hasLoaded;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 14, 24, 4),
              child: Text(
                AdminStrings.approvalsTitle,
                style: AppTypography.sectionTitle,
              ),
            ),
            ApplicationFilterChips(
              selected: _filter,
              pendingCount: stats?.pendingCount ?? 0,
              approvedCount: stats?.approvedCount ?? 0,
              declinedCount: stats?.declinedCount ?? 0,
              onSelected: (filter) {
                if (filter == _filter) return;
                setState(() => _filter = filter);
              },
            ),
            Expanded(
              child: showShimmer
                  ? const _ApplicationsShimmer()
                  : applicationsAsync.when(
                      loading: () => const _ApplicationsShimmer(),
                      error: (_, __) => _ApplicationsError(onRetry: _onRefresh),
                      data: (applications) {
                        if (applications.isEmpty) {
                          return RefreshIndicator(
                            color: AppColors.espresso,
                            onRefresh: _onRefresh,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              children: [
                                AdminEmptyState(
                                  message: _emptyMessage(),
                                  icon: Icons.storefront_outlined,
                                ),
                              ],
                            ),
                          );
                        }

                        return RefreshIndicator(
                          color: AppColors.espresso,
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            physics: const AlwaysScrollableScrollPhysics(
                              parent: BouncingScrollPhysics(),
                            ),
                            padding: const EdgeInsets.fromLTRB(
                              AppSpacing.screenPadding,
                              4,
                              AppSpacing.screenPadding,
                              BottomNavTokens.scrollBottomPadding,
                            ),
                            itemCount: applications.length,
                            itemBuilder: (context, index) {
                              return AdminApplicationRow(
                                application: applications[index],
                              );
                            },
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApplicationsShimmer extends StatelessWidget {
  const _ApplicationsShimmer();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPadding,
        8,
        AppSpacing.screenPadding,
        BottomNavTokens.scrollBottomPadding,
      ),
      itemCount: 5,
      itemBuilder: (_, __) => const Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: SizedBox(
          height: 76,
          child: ShimmerLoader(borderRadius: AppRadii.md),
        ),
      ),
    );
  }
}

class _ApplicationsError extends StatelessWidget {
  const _ApplicationsError({required this.onRetry});

  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Could not load applications',
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
