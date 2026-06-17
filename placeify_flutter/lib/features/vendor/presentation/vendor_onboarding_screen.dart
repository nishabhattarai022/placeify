import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/widgets/form_text_field.dart';
import '../../../core/widgets/toast_overlay.dart';
import '../../../core/config/placeify_server_client.dart';
import '../../auth/domain/models/app_user.dart';
import '../../auth/presentation/providers/auth_provider.dart';
import '../domain/repositories/vendor_commerce_repository.dart';
import 'providers/vendor_dashboard_provider.dart';
import 'widgets/vendor_form_widgets.dart';

class VendorOnboardingScreen extends ConsumerStatefulWidget {
  const VendorOnboardingScreen({super.key});

  @override
  ConsumerState<VendorOnboardingScreen> createState() =>
      _VendorOnboardingScreenState();
}

class _VendorOnboardingScreenState extends ConsumerState<VendorOnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _shopNameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  bool _isSubmitting = false;
  bool _didPrefill = false;

  @override
  void dispose() {
    _shopNameController.dispose();
    _descriptionController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  void _prefillFromProfile(AppUser? user) {
    if (_didPrefill || user == null) return;
    if (user.phone != null && user.phone!.trim().isNotEmpty) {
      _phoneController.text = user.phone!.trim();
    }
    if (user.address != null && user.address!.trim().isNotEmpty) {
      _addressController.text = user.address!.trim();
    }
    _didPrefill = true;
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      await ref.read(vendorDashboardStateProvider.notifier).createShop(
            shopName: _shopNameController.text.trim(),
            description: _descriptionController.text.trim(),
            phone: _phoneController.text.trim(),
            address: _addressController.text.trim(),
          );
      if (!mounted) return;
      PlaceifyToast.show(context, 'Your shop is live — welcome aboard!');
    } on VendorCommerceRepositoryException catch (error) {
      if (mounted) PlaceifyToast.show(context, error.message);
    } catch (_) {
      if (mounted) {
        PlaceifyToast.show(
          context,
          'We could not finish setup. Please try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProvider);
    final user = userAsync.value;
    _prefillFromProfile(user);
    final isAuthenticated = client.auth.isAuthenticated;
    final firstName = user?.fullName.trim().split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.espresso),
          onPressed: () => context.go('/profile'),
        ),
        title: const Text(
          'Vendor setup',
          style: TextStyle(
            fontFamily: 'Fraunces',
            fontSize: 18,
            color: AppColors.espresso,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (userAsync.isLoading && isAuthenticated)
              const LinearProgressIndicator(
                minHeight: 2,
                color: AppColors.bark,
                backgroundColor: AppColors.creamDark,
              ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  8,
                  AppSpacing.screenPadding,
                  24,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VendorScreenHeader(
                        icon: Icons.storefront_outlined,
                        title: 'Set up your shop',
                        subtitle: isAuthenticated
                            ? 'Hi${firstName != null ? ' $firstName' : ''} — complete this one-time setup to start selling. You can switch back to shopping anytime.'
                            : 'Create your shop profile to list furniture and receive orders on Placeify.',
                        badges: const [
                          'One account',
                          'Secure checkout',
                          'Customer orders',
                        ],
                      ),
                      const SizedBox(height: 28),
                      if (!isAuthenticated) ...[
                        VendorSignInPrompt(
                          onSignIn: () => context.push('/login'),
                        ),
                      ] else ...[
                        VendorFormSection(
                          step: 1,
                          title: 'Shop identity',
                          subtitle:
                              'How customers will find and recognize your store.',
                          children: [
                            FormTextField(
                              label: 'Shop name',
                              hint: 'Himalayan Home Co.',
                              helperText:
                                  'Use your business or brand name.',
                              controller: _shopNameController,
                              textInputAction: TextInputAction.next,
                              required: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your shop name';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            FormTextField(
                              label: 'About your shop',
                              hint:
                                  'Handcrafted wooden chairs, modern sofas…',
                              helperText:
                                  'A short description shown on your store profile.',
                              controller: _descriptionController,
                              textInputAction: TextInputAction.next,
                              maxLines: 3,
                              required: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Tell customers what you sell';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        VendorFormSection(
                          step: 2,
                          title: 'Contact & location',
                          subtitle:
                              'Used for order updates and delivery coordination.',
                          children: [
                            FormTextField(
                              label: 'Phone number',
                              hint: '+977 98XXXXXXXX',
                              helperText:
                                  'Customers may call for order questions.',
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              required: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a contact number';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            FormTextField(
                              label: 'Shop address',
                              hint: 'Street, area, city',
                              helperText:
                                  'Pickup or dispatch location for your orders.',
                              controller: _addressController,
                              textInputAction: TextInputAction.done,
                              maxLines: 2,
                              required: true,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your shop address';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const VendorFormNote(
                          text:
                              'You only register once. After this, switch between shopping and selling from your profile.',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            if (isAuthenticated)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.screenPadding,
                  12,
                  AppSpacing.screenPadding,
                  16,
                ),
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  border: Border(
                    top: BorderSide(
                      color: AppColors.creamDark.withValues(alpha: 0.9),
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.espresso.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: VendorSubmitButton(
                  label: 'Launch my shop',
                  icon: Icons.rocket_launch_outlined,
                  isLoading: _isSubmitting,
                  onPressed: _isSubmitting ? null : _submit,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
