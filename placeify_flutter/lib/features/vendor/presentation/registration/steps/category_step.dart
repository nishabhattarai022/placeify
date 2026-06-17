import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/widgets/placeify_bottom_sheet.dart';
import '../../../../../data/furniture_categories.dart';
import '../../../../profile/presentation/widgets/shared/profile_form_field.dart';
import '../../../domain/models/vendor_registration.dart';
import '../../providers/vendor_registration_provider.dart';

class CategoryStep extends ConsumerStatefulWidget {
  const CategoryStep({super.key});

  @override
  ConsumerState<CategoryStep> createState() => _CategoryStepState();
}

class _CategoryStepState extends ConsumerState<CategoryStep> {
  late final TextEditingController _description;

  @override
  void initState() {
    super.initState();
    final category = ref.read(vendorRegistrationProvider).form.category;
    _description = TextEditingController(text: category.description);
  }

  @override
  void dispose() {
    _description.dispose();
    super.dispose();
  }

  void _sync(VendorCategoryInfo category) {
    ref.read(vendorRegistrationProvider.notifier).updateCategory(category);
  }

  @override
  Widget build(BuildContext context) {
    final selected = ref.watch(vendorRegistrationProvider).form.category.category;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      children: [
        const Text(
          'What do you sell?',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C1810),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Choose your primary category. You can add more products across categories later.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B6055),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        ProfileFormField(
          label: 'Primary Category',
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.creamDark, width: 1.5),
            ),
            child: Column(
              children: [
                for (final cat in furnitureCategories)
                  PlaceifySelectTile(
                    label: cat.name,
                    selected: selected == cat.name,
                    icon: Icons.category_outlined,
                    onTap: () => _sync(
                      ref.read(vendorRegistrationProvider).form.category
                          .copyWith(category: cat.name),
                    ),
                  ),
              ],
            ),
          ),
        ),
        ProfileFormField(
          label: 'Store Description (optional)',
          child: ProfileTextInput(
            controller: _description,
            hint: 'Briefly describe your brand and product style',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.category
                  .copyWith(description: v),
            ),
          ),
        ),
      ],
    );
  }
}
