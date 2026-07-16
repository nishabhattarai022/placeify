import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:placeify_flutter/core/providers/shared_preferences_provider.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_routes.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../../../core/services/haptic_service.dart';

const _prefsKey = 'vendor_onboarding_checklist_completed';

class _ChecklistItem {
  const _ChecklistItem({
    required this.id,
    required this.label,
    required this.route,
  });

  final String id;
  final String label;
  final String route;
}

const _items = [
  _ChecklistItem(
    id: 'profile',
    label: 'Complete your store profile',
    route: VendorRoutes.profile,
  ),
  _ChecklistItem(
    id: 'product',
    label: 'Upload your first product',
    route: VendorRoutes.productsUpload,
  ),
  _ChecklistItem(
    id: 'orders',
    label: 'Review incoming orders',
    route: VendorRoutes.orders,
  ),
];

class VendorOnboardingChecklist extends ConsumerStatefulWidget {
  const VendorOnboardingChecklist({super.key});

  @override
  ConsumerState<VendorOnboardingChecklist> createState() =>
      _VendorOnboardingChecklistState();
}

class _VendorOnboardingChecklistState
    extends ConsumerState<VendorOnboardingChecklist> {
  final Set<String> _checked = {};
  bool _dismissed = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadState());
  }

  Future<void> _loadState() async {
    final prefs = ref.read(sharedPreferencesProvider);
    final completed = prefs.getBool(_prefsKey) ?? false;
    if (!mounted) return;
    setState(() {
      _dismissed = completed;
      _loaded = true;
    });
  }

  Future<void> _persistCompleted() async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool(_prefsKey, true);
  }

  void _toggleItem(String id) {
    HapticService.light();
    setState(() {
      if (_checked.contains(id)) {
        _checked.remove(id);
      } else {
        _checked.add(id);
      }
    });

    if (_checked.length == _items.length) {
      _persistCompleted();
      setState(() => _dismissed = true);
    }
  }

  void _dismiss() {
    HapticService.light();
    _persistCompleted();
    setState(() => _dismissed = true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded || _dismissed) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warmWhite,
        borderRadius: AppRadii.lg,
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Get started',
                  style: GoogleFonts.dmSans(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
              GestureDetector(
                onTap: _dismiss,
                child: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'Complete these steps to set up your store.',
            style: TextStyle(fontSize: 12, color: AppColors.textMuted),
          ),
          const SizedBox(height: 12),
          ..._items.map((item) {
            final isChecked = _checked.contains(item.id);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () => _toggleItem(item.id),
                child: Row(
                  children: [
                    Icon(
                      isChecked
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 20,
                      color: isChecked ? AppColors.sage : AppColors.creamDark,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: isChecked
                              ? AppColors.textMuted
                              : AppColors.textPrimary,
                          decoration:
                              isChecked ? TextDecoration.lineThrough : null,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        HapticService.light();
                        context.push(item.route);
                      },
                      child: const Text('Go'),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
