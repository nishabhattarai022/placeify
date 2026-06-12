import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify/core/constants/app_colors.dart';
import 'package:placeify/core/constants/app_radii.dart';
import 'package:placeify/core/constants/app_spacing.dart';
import 'package:placeify/core/constants/app_typography.dart';
import 'package:placeify/core/widgets/bottom_nav/bottom_nav_tokens.dart';
import 'package:placeify/core/widgets/shimmer_loader.dart';
import 'package:placeify/features/admin/domain/constants/admin_strings.dart';
import 'package:placeify/features/admin/domain/enums/user_role.dart';
import 'package:placeify/features/admin/presentation/providers/admin_users_provider.dart';
import 'package:placeify/features/admin/presentation/users/widgets/admin_user_row.dart';
import 'package:placeify/features/admin/presentation/widgets/admin_empty_state.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  String _searchQuery = '';
  UserRole? _roleFilter;
  bool _hasLoaded = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    await ref
        .read(adminUsersListProvider(_searchQuery, _roleFilter).notifier)
        .refresh();
  }

  @override
  Widget build(BuildContext context) {
    final usersAsync =
        ref.watch(adminUsersListProvider(_searchQuery, _roleFilter));

    usersAsync.whenData((_) {
      if (!_hasLoaded) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) setState(() => _hasLoaded = true);
        });
      }
    });

    final showShimmer = usersAsync.isLoading && !_hasLoaded;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    AdminStrings.usersTitle,
                    style: AppTypography.sectionTitle,
                  ),
                  const SizedBox(height: 14),
                  _UsersSearchField(
                    controller: _searchController,
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                ],
              ),
            ),
            _RoleFilterChips(
              selected: _roleFilter,
              onSelected: (role) => setState(() => _roleFilter = role),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: showShimmer
                  ? const _UsersShimmer()
                  : usersAsync.when(
                      loading: () => const _UsersShimmer(),
                      error: (_, __) => _UsersError(onRetry: _onRefresh),
                      data: (users) {
                        if (users.isEmpty) {
                          return RefreshIndicator(
                            color: AppColors.espresso,
                            onRefresh: _onRefresh,
                            child: ListView(
                              physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics(),
                              ),
                              children: [
                                AdminEmptyState(
                                  message: _searchQuery.trim().isEmpty
                                      ? 'No users found'
                                      : 'No users match your search',
                                  icon: Icons.people_outline,
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
                            itemCount: users.length,
                            itemBuilder: (context, index) {
                              return AdminUserRow(user: users[index]);
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

class _RoleFilterChips extends StatelessWidget {
  const _RoleFilterChips({
    required this.selected,
    required this.onSelected,
  });

  final UserRole? selected;
  final ValueChanged<UserRole?> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 0),
      child: Row(
        children: [
          _RoleChip(
            label: AdminStrings.filterAll,
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          const SizedBox(width: 8),
          _RoleChip(
            label: 'Customer',
            isSelected: selected == UserRole.customer,
            onTap: () => onSelected(UserRole.customer),
          ),
          const SizedBox(width: 8),
          _RoleChip(
            label: 'Vendor',
            isSelected: selected == UserRole.vendor,
            onTap: () => onSelected(UserRole.vendor),
          ),
          const SizedBox(width: 8),
          _RoleChip(
            label: AdminStrings.roleAdmin,
            isSelected: selected == UserRole.admin,
            onTap: () => onSelected(UserRole.admin),
          ),
        ],
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.adminSlate : AppColors.warmWhite,
          borderRadius: AppRadii.pill,
          border: Border.all(
            color: isSelected ? AppColors.adminSlate : AppColors.creamDark,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? AppColors.warmWhite : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _UsersSearchField extends StatelessWidget {
  const _UsersSearchField({
    required this.controller,
    required this.onChanged,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.pill,
        border: Border.all(color: AppColors.creamDark, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const Icon(
            Icons.search_rounded,
            size: 20,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: AppTypography.searchText,
              decoration: const InputDecoration(
                hintText: 'Search by name or email',
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersShimmer extends StatelessWidget {
  const _UsersShimmer();

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
      itemCount: 6,
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

class _UsersError extends StatelessWidget {
  const _UsersError({required this.onRetry});

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
              'Could not load users',
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
