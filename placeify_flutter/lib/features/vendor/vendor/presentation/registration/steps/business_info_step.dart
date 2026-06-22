import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_flutter/core/widgets/phone_input_field.dart';

import '../../../../profile/presentation/widgets/shared/profile_form_field.dart';
import '../../../domain/constants/vendor_strings.dart';
import '../../../domain/models/vendor_registration.dart';
import '../../../domain/validators/vendor_registration_validator.dart';
import '../../providers/vendor_registration_provider.dart';
import '../widgets/vendor_registration_error_banner.dart';

class BusinessInfoStep extends ConsumerStatefulWidget {
  const BusinessInfoStep({super.key});

  @override
  ConsumerState<BusinessInfoStep> createState() => _BusinessInfoStepState();
}

class _BusinessInfoStepState extends ConsumerState<BusinessInfoStep> {
  late final TextEditingController _businessName;
  late final TextEditingController _contactName;
  late final TextEditingController _email;
  late final TextEditingController _taxId;

  @override
  void initState() {
    super.initState();
    final business = ref.read(vendorRegistrationProvider).form.business;
    _businessName = TextEditingController(text: business.businessName);
    _contactName = TextEditingController(text: business.contactName);
    _email = TextEditingController(text: business.email);
    _taxId = TextEditingController(text: business.taxId);
  }

  @override
  void dispose() {
    _businessName.dispose();
    _contactName.dispose();
    _email.dispose();
    _taxId.dispose();
    super.dispose();
  }

  void _sync(VendorBusinessInfo business, {String? clearErrorFor}) {
    final notifier = ref.read(vendorRegistrationProvider.notifier);
    notifier.updateBusiness(business);
    if (clearErrorFor != null) notifier.clearFieldError(clearErrorFor);
  }

  @override
  Widget build(BuildContext context) {
    final fieldErrors = ref.watch(vendorRegistrationProvider).fieldErrors;

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
        VendorRegistrationErrorBanner(errors: fieldErrors),
        ProfileFormField(
          label: 'Business Name',
          error: fieldErrors[VendorRegistrationFieldKeys.businessName],
          child: ProfileTextInput(
            controller: _businessName,
            hint: VendorFormStrings.businessNameHint,
            hasError: fieldErrors
                .containsKey(VendorRegistrationFieldKeys.businessName),
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.business
                  .copyWith(businessName: v),
              clearErrorFor: VendorRegistrationFieldKeys.businessName,
            ),
          ),
        ),
        ProfileFormField(
          label: 'Contact Name',
          error: fieldErrors[VendorRegistrationFieldKeys.contactName],
          child: ProfileTextInput(
            controller: _contactName,
            hint: VendorFormStrings.contactNameHint,
            hasError: fieldErrors
                .containsKey(VendorRegistrationFieldKeys.contactName),
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.business
                  .copyWith(contactName: v),
              clearErrorFor: VendorRegistrationFieldKeys.contactName,
            ),
          ),
        ),
        ProfileFormField(
          label: 'Email',
          error: fieldErrors[VendorRegistrationFieldKeys.email],
          child: ProfileTextInput(
            controller: _email,
            hint: 'vendor@example.com',
            keyboardType: TextInputType.emailAddress,
            hasError: fieldErrors.containsKey(VendorRegistrationFieldKeys.email),
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.business
                  .copyWith(email: v),
              clearErrorFor: VendorRegistrationFieldKeys.email,
            ),
          ),
        ),
        ProfileFormField(
          label: 'Phone',
          error: fieldErrors[VendorRegistrationFieldKeys.phone],
          child: PhoneInputField(
            initialPhone: ref.watch(vendorRegistrationProvider).form.business.phone,
            hasError: fieldErrors.containsKey(VendorRegistrationFieldKeys.phone),
            onChanged: (full) => _sync(
              ref.read(vendorRegistrationProvider).form.business
                  .copyWith(phone: full),
              clearErrorFor: VendorRegistrationFieldKeys.phone,
            ),
          ),
        ),
        ProfileFormField(
          label: VendorFormStrings.taxIdLabel,
          error: fieldErrors[VendorRegistrationFieldKeys.taxId],
          child: ProfileTextInput(
            controller: _taxId,
            hint: VendorFormStrings.taxIdHint,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(9),
            ],
            hasError: fieldErrors.containsKey(VendorRegistrationFieldKeys.taxId),
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.business
                  .copyWith(taxId: v),
              clearErrorFor: VendorRegistrationFieldKeys.taxId,
            ),
          ),
        ),
      ],
    );
  }
}
