import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/shimmer_loader.dart';
import 'package:placeify/features/admin/domain/enums/admin_vendor_list_filter.dart';
import 'package:placeify/features/admin/presentation/providers/admin_vendors_provider.dart';
import 'package:placeify/features/admin/presentation/vendors/widgets/admin_vendor_row.dart';
import 'package:placeify/features/admin/presentation/vendors/widgets/vendor_filter_chips.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_empty_state.dart';

class AdminVendorsScreen extends ConsumerStatefulWidget {
  const AdminVendorsScreen({super.key});

  @override
  ConsumerState<AdminVendorsScreen> createState() => _AdminVendorsScreenState();
}

class _AdminVendorsScreenState extends ConsumerState<AdminVendorsScreen> {
  AdminVendorListFilter _filter = AdminVendorListFilter.all;
  bool _hasLoaded = false;

  Future<void> _onRefresh() async {
    await ref.read(adminVendorsListProvider(_filter).notifier).refresh();
  }

  String _emptyMessage() {
    return switch (_filter) {
      AdminVendorListFilter.all => 'No active vendors',
      AdminVendorListFilter.approved => 'No approved vendors',
      AdminVendorListFilter.suspended => 'No suspended vendors',
    };
  }

  @override
  Widget build(BuildContext context) {
    final vendorsAsync = ref.watch(adminVendorsListProvider(_filter));

    vendorsAsync.whenData((_) {
      if (!_hasLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _hasLoaded = true);
        });
      }
    });

    final showShimmer = vendorsAsync.isLoading && !_hasLoaded;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 14, 24, 4),
              child: Text(
                'Vendors',
                style: AppTypography.sectionTitle,
              ),
            ),
            VendorFilterChips(
              selected: _filter,
              onSelected: (filter) {
                if (filter == _filter) return;
                setState(() => _filter = filter);
              },
            ),
            Expanded(
              child: showShimmer
                  ? const _VendorsShimmer()
                  : vendorsAsync.when(
                      loading: () => const _VendorsShimmer(),
                      error: (_, __) => _VendorsError(onRetry: _onRefresh),
                      data: (vendors) {
                        if (vendors.isEmpty) {
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
                            itemCount: vendors.length,
                            itemBuilder: (context, index) {
                              return AdminVendorRow(vendor: vendors[index]);
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

class _VendorsShimmer extends StatelessWidget {
  const _VendorsShimmer();

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

class _VendorsError extends StatelessWidget {
  const _VendorsError({required this.onRetry});

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
              'Could not load vendors',
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
