import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radii.dart';
import '../../data/product_image_service.dart';

/// Tripo multiview slots in API order: front, left, back, right.
enum ProductPhotoView {
  front('Front', 'Required — face the product directly'),
  left('Left', 'Same item, camera on the left side'),
  back('Back', 'Same item, straight from behind'),
  right('Right', 'Same item, camera on the right side');

  const ProductPhotoView(this.label, this.hint);

  final String label;
  final String hint;

  bool get isRequired => this == ProductPhotoView.front;
}

class ProductMultiviewPhotoPicker extends StatelessWidget {
  const ProductMultiviewPhotoPicker({
    required this.photos,
    required this.activeView,
    required this.onSelectView,
    required this.onTakePhoto,
    required this.onChooseGallery,
    required this.onRemove,
    this.cameraAvailable = true,
    super.key,
  });

  final Map<ProductPhotoView, PickedProductImage> photos;
  final ProductPhotoView activeView;
  final ValueChanged<ProductPhotoView> onSelectView;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseGallery;
  final ValueChanged<ProductPhotoView> onRemove;
  final bool cameraAvailable;

  PickedProductImage? get _activePhoto => photos[activeView];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Product photos',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Add front, left, back, and right photos of the same piece. '
          'Use the same lighting for all — 3D copies texture from these images '
          '(front → left → back → right).',
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final view in ProductPhotoView.values)
              _ViewSlotChip(
                view: view,
                selected: activeView == view,
                hasPhoto: photos.containsKey(view),
                onTap: () => onSelectView(view),
              ),
          ],
        ),
        const SizedBox(height: 12),
        AspectRatio(
          aspectRatio: 4 / 3,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.warmWhite,
              borderRadius: AppRadii.md,
              border: Border.all(color: AppColors.creamDark, width: 1.5),
            ),
            clipBehavior: Clip.antiAlias,
            child: _activePhoto == null
                ? _EmptySlotState(
                    view: activeView,
                    cameraAvailable: cameraAvailable,
                    onTakePhoto: onTakePhoto,
                    onChooseGallery: onChooseGallery,
                  )
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.memory(
                        _activePhoto!.bytes,
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 10,
                        left: 10,
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: AppRadii.pill,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            child: Text(
                              activeView.label,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: IconButton.filled(
                          style: IconButton.styleFrom(
                            backgroundColor: Colors.black54,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => onRemove(activeView),
                          icon: const Icon(Icons.close, size: 20),
                        ),
                      ),
                      Positioned(
                        left: 12,
                        right: 12,
                        bottom: 12,
                        child: Row(
                          children: [
                            if (cameraAvailable) ...[
                              Expanded(
                                child: _PhotoActionButton(
                                  icon: Icons.photo_camera_outlined,
                                  label: 'Retake',
                                  onTap: onTakePhoto,
                                ),
                              ),
                              const SizedBox(width: 10),
                            ],
                            Expanded(
                              child: _PhotoActionButton(
                                icon: Icons.photo_library_outlined,
                                label: cameraAvailable ? 'Gallery' : 'Replace',
                                onTap: onChooseGallery,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _ViewSlotChip extends StatelessWidget {
  const _ViewSlotChip({
    required this.view,
    required this.selected,
    required this.hasPhoto,
    required this.onTap,
  });

  final ProductPhotoView view;
  final bool selected;
  final bool hasPhoto;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.sage.withValues(alpha: 0.18)
              : Colors.white,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: selected ? AppColors.sage : AppColors.creamDark,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              hasPhoto ? Icons.check_circle : Icons.circle_outlined,
              size: 14,
              color: hasPhoto ? AppColors.sage : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              view.isRequired ? '${view.label} *' : view.label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                color: selected ? AppColors.espresso : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptySlotState extends StatelessWidget {
  const _EmptySlotState({
    required this.view,
    required this.cameraAvailable,
    required this.onTakePhoto,
    required this.onChooseGallery,
  });

  final ProductPhotoView view;
  final bool cameraAvailable;
  final VoidCallback onTakePhoto;
  final VoidCallback onChooseGallery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            cameraAvailable
                ? Icons.add_a_photo_outlined
                : Icons.photo_library_outlined,
            size: 36,
            color: AppColors.textMuted.withValues(alpha: 0.8),
          ),
          const SizedBox(height: 10),
          Text(
            view.isRequired
                ? 'Add the ${view.label.toLowerCase()} photo'
                : 'Add ${view.label.toLowerCase()} view (optional)',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            view.hint,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 18),
          if (cameraAvailable)
            Row(
              children: [
                Expanded(
                  child: _PhotoActionButton(
                    icon: Icons.photo_camera_outlined,
                    label: 'Camera',
                    onTap: onTakePhoto,
                    filled: true,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PhotoActionButton(
                    icon: Icons.photo_library_outlined,
                    label: 'Gallery',
                    onTap: onChooseGallery,
                    filled: true,
                  ),
                ),
              ],
            )
          else
            _PhotoActionButton(
              icon: Icons.photo_library_outlined,
              label: 'Choose from gallery',
              onTap: onChooseGallery,
              filled: true,
              expanded: true,
            ),
        ],
      ),
    );
  }
}

class _PhotoActionButton extends StatelessWidget {
  const _PhotoActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
    this.expanded = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final button = Material(
      color: filled ? AppColors.espresso : Colors.black54,
      borderRadius: AppRadii.pill,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pill,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.white),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    if (expanded) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}
