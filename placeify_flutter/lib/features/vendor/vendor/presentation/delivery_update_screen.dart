import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/profile_sub_hero.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/shared/profile_form_field.dart';
import 'package:placeify_flutter/features/profile/presentation/widgets/shared/profile_submit_button.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/vendor/data/mock_vendor_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/delivery_stage.dart';
import 'package:placeify_flutter/features/vendor/domain/enums/order_status.dart';
import 'package:placeify_flutter/features/vendor/domain/models/delivery_update.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_order_detail_provider.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_profile_provider.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_radii.dart';
import '../../../core/services/haptic_service.dart';
import '../../../core/widgets/shimmer_loader.dart';
import '../../../core/widgets/toast_overlay.dart';

class DeliveryUpdateScreen extends ConsumerStatefulWidget {
  const DeliveryUpdateScreen({required this.orderId, super.key});

  final String orderId;

  @override
  ConsumerState<DeliveryUpdateScreen> createState() =>
      _DeliveryUpdateScreenState();
}

class _DeliveryUpdateScreenState extends ConsumerState<DeliveryUpdateScreen> {
  final _noteController = TextEditingController();
  final _picker = ImagePicker();
  DeliveryStage? _selectedStage;
  String? _photoProofPath;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _pickPhoto() async {
    HapticService.light();
    final image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1600,
      imageQuality: 85,
    );
    if (image == null || !mounted) return;
    setState(() => _photoProofPath = image.path);
  }

  void _removePhoto() {
    HapticService.light();
    setState(() => _photoProofPath = null);
  }

  Future<void> _submit(DeliveryStage stage) async {
    if (_isSubmitting) return;

    final user = ref.read(currentUserProvider).value;
    final vendorId = user?.vendorId;
    if (vendorId == null) {
      PlaceifyToast.show(context, 'Vendor account not found.');
      return;
    }

    setState(() => _isSubmitting = true);
    HapticService.medium();

    try {
      final repo = ref.read(vendorRepositoryProvider);
      await repo.submitDeliveryUpdate(
        vendorId,
        widget.orderId,
        stage: stage,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        photoProofPath: _photoProofPath,
      );

      if (!mounted) return;
      ref.invalidate(vendorOrderDetailProvider(widget.orderId));
      PlaceifyToast.show(context, 'Delivery update posted ✓');
      context.pop();
    } on VendorOrderActionException catch (e) {
      if (!mounted) return;
      PlaceifyToast.show(context, e.message);
    } catch (_) {
      if (!mounted) return;
      PlaceifyToast.show(context, 'Could not save delivery update.');
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  static String _stageLabel(DeliveryStage stage) {
    return switch (stage) {
      DeliveryStage.orderPlaced => 'Order Placed',
      DeliveryStage.packed => 'Packed',
      DeliveryStage.shipped => 'Shipped',
      DeliveryStage.outForDelivery => 'Out for Delivery',
      DeliveryStage.delivered => 'Delivered',
    };
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(vendorOrderDetailProvider(widget.orderId));

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: detailAsync.when(
        loading: () => const Column(
          children: [
            SizedBox(height: 120, child: ShimmerLoader()),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: ShimmerLoader(borderRadius: AppRadii.lg),
              ),
            ),
          ],
        ),
        error: (_, __) => _DeliveryUpdateError(
          onRetry: () =>
              ref.invalidate(vendorOrderDetailProvider(widget.orderId)),
        ),
        data: (detail) {
          if (detail == null) {
            return _DeliveryUpdateError(
              onRetry: () =>
                  ref.invalidate(vendorOrderDetailProvider(widget.orderId)),
            );
          }

          final order = detail.order;
          final nextStage = _nextStage(detail.deliveryUpdates);
          _selectedStage ??= nextStage;

          final canSubmit = nextStage != null &&
              _selectedStage == nextStage &&
              !_isSubmitting &&
              order.status != OrderStatus.pending &&
              order.status != OrderStatus.rejected &&
              order.status != OrderStatus.cancelled &&
              order.status != OrderStatus.delivered;

          return Column(
            children: [
              ProfileSubHero(
                title: 'Update Delivery',
                bottom: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Order #${order.orderNumber}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0x99FFFFFF),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (nextStage == null)
                        _InfoBanner(
                          message: 'All delivery stages are complete.',
                          icon: Icons.check_circle_outline_rounded,
                          color: AppColors.sage,
                        )
                      else ...[
                        const Text(
                          'Next stage',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: DeliveryStage.values.map((stage) {
                            final isNext = stage == nextStage;
                            final isSelected = _selectedStage == stage;
                            final isPast = DeliveryStage.values
                                    .indexOf(stage) <
                                DeliveryStage.values.indexOf(nextStage);

                            return FilterChip(
                              label: Text(_stageLabel(stage)),
                              selected: isSelected,
                              onSelected: isNext
                                  ? (_) {
                                      HapticService.light();
                                      setState(() => _selectedStage = stage);
                                    }
                                  : null,
                              showCheckmark: false,
                              selectedColor: AppColors.accentBg,
                              backgroundColor: isPast
                                  ? AppColors.sage.withValues(alpha: 0.12)
                                  : AppColors.warmWhite,
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.accent
                                    : AppColors.creamDark,
                                width: 1.5,
                              ),
                              labelStyle: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isNext
                                    ? AppColors.accent
                                    : isPast
                                        ? AppColors.sage
                                        : AppColors.textMuted,
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20),
                        ProfileFormField(
                          label: 'Note (optional)',
                          child: ProfileTextInput(
                            controller: _noteController,
                            hint: 'Add details for the customer',
                            maxLines: 3,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Photo proof (optional)',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (_photoProofPath != null)
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: AppRadii.md,
                                child: Image.file(
                                  File(_photoProofPath!),
                                  width: double.infinity,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 8,
                                right: 8,
                                child: GestureDetector(
                                  onTap: _removePhoto,
                                  child: Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.espresso
                                          .withValues(alpha: 0.72),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        else
                          GestureDetector(
                            onTap: _pickPhoto,
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              decoration: BoxDecoration(
                                color: AppColors.warmWhite,
                                borderRadius: AppRadii.md,
                                border: Border.all(
                                  color: AppColors.creamDark,
                                  width: 1.5,
                                ),
                              ),
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_a_photo_outlined,
                                    color: AppColors.textMuted,
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    'Add photo proof',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ),
              if (nextStage != null)
                Container(
                  color: AppColors.cream,
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 52,
                          child: Center(
                            child: CircularProgressIndicator(
                              color: AppColors.espresso,
                              strokeWidth: 2,
                            ),
                          ),
                        )
                      : ProfileSubmitButton(
                          label: 'Post update',
                          onPressed: () {
                            if (!canSubmit || _selectedStage == null) return;
                            _submit(_selectedStage!);
                          },
                        ),
                ),
            ],
          );
        },
      ),
    );
  }

  DeliveryStage? _nextStage(List<DeliveryUpdate> updates) {
    if (updates.isEmpty) return DeliveryStage.orderPlaced;

    var maxIndex = -1;
    for (final update in updates) {
      final index = DeliveryStage.values.indexOf(update.stage);
      if (index > maxIndex) maxIndex = index;
    }

    final nextIndex = maxIndex + 1;
    if (nextIndex >= DeliveryStage.values.length) return null;
    return DeliveryStage.values[nextIndex];
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner({
    required this.message,
    required this.icon,
    required this.color,
  });

  final String message;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppRadii.md,
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DeliveryUpdateError extends StatelessWidget {
  const _DeliveryUpdateError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileSubHero(title: 'Update Delivery'),
        Expanded(
          child: Center(
            child: TextButton(onPressed: onRetry, child: const Text('Try again')),
          ),
        ),
      ],
    );
  }
}
