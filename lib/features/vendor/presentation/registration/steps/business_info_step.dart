import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../profile/presentation/widgets/shared/profile_form_field.dart';
import '../../../domain/models/vendor_registration.dart';
import '../../providers/vendor_registration_provider.dart';

class BusinessInfoStep extends ConsumerStatefulWidget {
  const BusinessInfoStep({super.key});

  @override
  ConsumerState<BusinessInfoStep> createState() => _BusinessInfoStepState();
}

class _BusinessInfoStepState extends ConsumerState<BusinessInfoStep> {
  late final TextEditingController _businessName;
  late final TextEditingController _contactName;
  late final TextEditingController _email;
  late final TextEditingController _phone;
  late final TextEditingController _taxId;

  @override
  void initState() {
    super.initState();
    final business = ref.read(vendorRegistrationProvider).form.business;
    _businessName = TextEditingController(text: business.businessName);
    _contactName = TextEditingController(text: business.contactName);
    _email = TextEditingController(text: business.email);
    _phone = TextEditingController(text: business.phone);
    _taxId = TextEditingController(text: business.taxId);
  }

  @override
  void dispose() {
    _businessName.dispose();
    _contactName.dispose();
    _email.dispose();
    _phone.dispose();
    _taxId.dispose();
    super.dispose();
  }

  void _sync(VendorBusinessInfo business) {
    ref.read(vendorRegistrationProvider.notifier).updateBusiness(business);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      children: [
        const Text(
          'Tell us about your business',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C1810),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'We use this information to verify your store and contact you about orders.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B6055),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        ProfileFormField(
          label: 'Business Name',
          child: ProfileTextInput(
            controller: _businessName,
            hint: 'e.g. Oak & Linen Co.',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.business
                  .copyWith(businessName: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'Contact Name',
          child: ProfileTextInput(
            controller: _contactName,
            hint: 'Primary contact person',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.business
                  .copyWith(contactName: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'Email',
          child: ProfileTextInput(
            controller: _email,
            hint: 'vendor@example.com',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.business
                  .copyWith(email: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'Phone',
          child: ProfileTextInput(
            controller: _phone,
            hint: '+1 (555) 000-0000',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.business
                  .copyWith(phone: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'Tax ID',
          child: ProfileTextInput(
            controller: _taxId,
            hint: 'EIN or VAT number',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.business
                  .copyWith(taxId: v),
            ),
          ),
        ),
      ],
    );
  }
}
