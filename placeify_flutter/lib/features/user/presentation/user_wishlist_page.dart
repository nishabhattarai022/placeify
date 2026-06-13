import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_typography.dart';
import '../../../core/config/placeify_server_client.dart';
import '../data/user_wishlist_mappers.dart';
import 'providers/user_wishlist_provider.dart';
import 'widgets/user_wishlist_card.dart';
import 'widgets/user_wishlist_sort_bar.dart';

/// Saved products backed by [client.wishlist.listMyWishlist].
class UserWishlistPage extends ConsumerStatefulWidget {
  const UserWishlistPage({super.key});

  @override
  ConsumerState<UserWishlistPage> createState() => _UserWishlistPageState();
}

class _UserWishlistPageState extends ConsumerState<UserWishlistPage> {
  UserWishlistSort _sort = UserWishlistSort.newestFirst;

  Future<void> _refresh() async {
    ref.invalidate(userWishlistProvider);
    await ref.read(userWishlistProvider.future);
  }

  Future<void> _remove(String productId) async {
    await ref.read(userWishlistProvider.notifier).remove(productId);
  }

  @override
  Widget build(BuildContext context) {
    if (!client.auth.isAuthenticated) {
      return _AuthRequired(onLogin: () => context.push('/login'));
    }

    final wishlistAsync = ref.watch(userWishlistProvider);
    final isDesktop = MediaQuery.sizeOf(context).width >= 900;
    final horizontalPadding = isDesktop ? AppSpacing.xxl : AppSpacing.lg;

    return wishlistAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => _ErrorState(
        message: error.toString(),
        onRetry: _refresh,
      ),
      data: (entries) {
        final sorted = UserWishlistMappers.sortEntries(entries, _sort);

        return RefreshIndicator(
          onRefresh: _refresh,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isDesktop ? AppSpacing.xxl : AppSpacing.lg,
                    horizontalPadding,
                    AppSpacing.md,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wishlist', style: AppTypography.sectionTitle),
                      const SizedBox(height: 6),
                      Text(
                        entries.isEmpty
                            ? 'Save products you love to find them quickly.'
                            : '${entries.length} saved item${entries.length == 1 ? '' : 's'}.',
                        style: AppTypography.metricLabel.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (entries.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        UserWishlistSortBar(
                          sort: _sort,
                          onChanged: (sort) => setState(() => _sort = sort),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              if (sorted.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyWishlistState(
                    onBrowse: () => context.go('/browse'),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    AppSpacing.md,
                    horizontalPadding,
                    AppSpacing.xxxl,
                  ),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => UserWishlistCard(
                        entry: sorted[index],
                        onRemove: () => _remove(sorted[index].product.id),
                      ),
                      childCount: sorted.length,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyWishlistState extends StatelessWidget {
  const _EmptyWishlistState({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.favorite_border_rounded,
              size: 48,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 16),
            Text(
              'No saved items yet',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Browse the catalog and save products to your wishlist.',
              textAlign: TextAlign.center,
              style: AppTypography.metricLabel.copyWith(
                color: AppColors.textSecondary,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onBrowse,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: Colors.white,
              ),
              child: const Text('Browse furniture'),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthRequired extends StatelessWidget {
  const _AuthRequired({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 48, color: AppColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'Sign in to view your wishlist',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: onLogin,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.forest,
                foregroundColor: Colors.white,
              ),
              child: const Text('Go to login'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.rust),
            const SizedBox(height: 16),
            Text(
              'Could not load wishlist',
              style: AppTypography.sectionTitle.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.metricLabel.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 20),
            OutlinedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}
