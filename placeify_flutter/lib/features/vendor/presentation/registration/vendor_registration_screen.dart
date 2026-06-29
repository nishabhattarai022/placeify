import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/services/haptic_service.dart';
import '../../../../core/widgets/toast_overlay.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../profile/presentation/widgets/shared/profile_submit_button.dart';
import '../../domain/constants/vendor_routes.dart';
import '../../domain/constants/vendor_strings.dart';
import '../providers/vendor_registration_provider.dart';
import 'steps/address_step.dart';
import 'steps/bank_details_step.dart';
import 'steps/business_info_step.dart';
import 'steps/category_step.dart';
import 'steps/document_upload_step.dart';
import 'steps/review_submit_step.dart';
import 'widgets/vendor_registration_hero.dart';

class VendorRegistrationScreen extends ConsumerStatefulWidget {
  const VendorRegistrationScreen({super.key});

  @override
  ConsumerState<VendorRegistrationScreen> createState() =>
      _VendorRegistrationScreenState();
}

class _VendorRegistrationScreenState
    extends ConsumerState<VendorRegistrationScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final initialStep = ref.read(vendorRegistrationProvider).currentStep;
    _pageController = PageController(initialPage: initialStep);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onBack() {
    final notifier = ref.read(vendorRegistrationProvider.notifier);
    final currentStep = ref.read(vendorRegistrationProvider).currentStep;
    if (currentStep > 0) {
      notifier.previousStep();
      _pageController.previousPage(
        duration: AppDurations.mid,
        curve: Curves.easeInOutCubic,
      );
    } else {
      context.pop();
    }
  }

  Future<void> _onPrimaryAction() async {
    HapticService.light();

    final notifier = ref.read(vendorRegistrationProvider.notifier);
    final uiState = ref.read(vendorRegistrationProvider);

    if (uiState.isReviewStep) {
      final vendorId = await notifier.submit();
      if (!mounted) return;

      if (vendorId == null) {
        final error = ref.read(vendorRegistrationProvider).submitError;
        if (error != null) {
          PlaceifyToast.show(context, error);
        } else if (ref.read(vendorRegistrationProvider).hasFieldErrors) {
          HapticService.light();
          final step = ref.read(vendorRegistrationProvider).currentStep;
          if (_pageController.hasClients) {
            await _pageController.animateToPage(
              step,
              duration: AppDurations.mid,
              curve: Curves.easeInOutCubic,
            );
          }
        }
        return;
      }

      await ref.read(currentUserProvider.notifier).refresh();
      if (!mounted) return;

      HapticService.medium();
      PlaceifyToast.show(context, VendorStrings.applicationSubmitted);
      context.go(VendorRoutes.profileFallback);
      return;
    }

    if (!notifier.nextStep()) {
      HapticService.light();
      return;
    }

    await _pageController.nextPage(
      duration: AppDurations.mid,
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final uiState = ref.watch(vendorRegistrationProvider);
    final isSubmitting = uiState.isSubmitting;

    ref.listen(vendorRegistrationProvider, (previous, next) {
      if (previous?.currentStep != next.currentStep &&
          _pageController.hasClients &&
          _pageController.page?.round() != next.currentStep) {
        _pageController.animateToPage(
          next.currentStep,
          duration: AppDurations.mid,
          curve: Curves.easeInOutCubic,
        );
      }
    });

    return PopScope(
      canPop: uiState.currentStep == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onBack();
      },
      child: Scaffold(
        backgroundColor: AppColors.cream,
        body: Column(
          children: [
            VendorRegistrationHero(
              title: 'Become a Vendor',
              currentStep: uiState.currentStep,
              onBack: _onBack,
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: const [
                  BusinessInfoStep(),
                  AddressStep(),
                  CategoryStep(),
                  DocumentUploadStep(),
                  BankDetailsStep(),
                  ReviewSubmitStep(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                18,
                12,
                18,
                MediaQuery.paddingOf(context).bottom + 16,
              ),
              child: isSubmitting
                  ? const SizedBox(
                      height: 52,
                      child: Center(
                        child: SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: AppColors.vendorForest,
                          ),
                        ),
                      ),
                    )
                  : ProfileSubmitButton(
                      label: uiState.isReviewStep
                          ? 'Submit Application'
                          : 'Continue',
                      onPressed: _onPrimaryAction,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
