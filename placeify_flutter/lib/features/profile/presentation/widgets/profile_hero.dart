import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../../auth/domain/models/app_user.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/profile_menu_config.dart';
import 'profile_hero_pattern.dart';
import 'profile_stats_strip.dart';

class ProfileHero extends ConsumerWidget {
  const ProfileHero({
    required this.onMoreTap,
    required this.onStatTap,
    super.key,
  });

  final VoidCallback onMoreTap;
  final void Function(int index) onStatTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final top = MediaQuery.paddingOf(context).top;
    final userAsync = ref.watch(currentUserProvider);

    return ColoredBox(
      color: AppColors.forest,
      child: Stack(
        children: [
          const Positioned.fill(child: ProfileHeroPattern()),
          Padding(
            padding: EdgeInsets.only(top: top),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 4, 22, 0),
                  child: Row(
                    children: [
                      const Text(
                        'Profile',
                        style: TextStyle(
                          fontFamily: 'Fraunces',
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: onMoreTap,
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.35),
                              width: 1.5,
                            ),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _AvatarSection(userAsync: userAsync),
                const SizedBox(height: 12),
                userAsync.when(
                  loading: () => const _UserInfoShimmer(),
                  error: (_, _) => const _UserInfoPlaceholder(),
                  data: (user) => user == null
                      ? const _UserInfoPlaceholder()
                      : _UserInfo(name: user.fullName, email: user.email),
                ),
                ProfileStatsStrip(onStatTap: onStatTap),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserInfo extends StatelessWidget {
  const _UserInfo({required this.name, required this.email});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          email,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

class _UserInfoPlaceholder extends StatelessWidget {
  const _UserInfoPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Guest',
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
        Text(
          'Sign in to see your account',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.55),
          ),
        ),
      ],
    );
  }
}

class _UserInfoShimmer extends StatelessWidget {
  const _UserInfoShimmer();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 160,
          height: 22,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 200,
          height: 14,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
      ],
    );
  }
}

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({required this.userAsync});

  final AsyncValue<AppUser?> userAsync;

  @override
  Widget build(BuildContext context) {
    const size = ProfileMenuConfig.avatarSize;
    final initial = userAsync.maybeWhen(
      data: (user) =>
          user != null && user.fullName.isNotEmpty
              ? user.fullName.trim()[0].toUpperCase()
              : null,
      orElse: () => null,
    );

    return SizedBox(
      width: size + 8,
      height: size + 8,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.accent, width: 3),
              color: initial != null ? AppColors.accent : null,
              image: initial == null
                  ? const DecorationImage(
                      image: AssetImage(ProfileMenuConfig.avatarAsset),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            alignment: Alignment.center,
            child: initial != null
                ? Text(
                    initial,
                    style: const TextStyle(
                      fontFamily: 'Fraunces',
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          Positioned(
            right: 0,
            bottom: 2,
            child: GestureDetector(
              onTap: () => PlaceifyToast.show(context, 'Edit photo'),
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.forest, width: 2.5),
                ),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
