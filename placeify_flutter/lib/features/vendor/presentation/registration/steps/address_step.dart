import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../profile/presentation/widgets/shared/profile_form_field.dart';
import '../../../domain/constants/vendor_strings.dart';
import '../../../domain/models/vendor_registration.dart';
import '../../../domain/validators/vendor_registration_validator.dart';
import '../../providers/vendor_registration_provider.dart';
import '../widgets/vendor_registration_error_banner.dart';

class AddressStep extends ConsumerStatefulWidget {
  const AddressStep({super.key});

  @override
  ConsumerState<AddressStep> createState() => _AddressStepState();
}

class _AddressStepState extends ConsumerState<AddressStep> {
  late final TextEditingController _street;
  late final TextEditingController _city;
  late final TextEditingController _state;
  late final TextEditingController _postalCode;
  late final TextEditingController _country;

  @override
  void initState() {
    super.initState();
    final address = ref.read(vendorRegistrationProvider).form.address;
    _street = TextEditingController(text: address.street);
    _city = TextEditingController(text: address.city);
    _state = TextEditingController(text: address.state);
    _postalCode = TextEditingController(text: address.postalCode);
    _country = TextEditingController(
      text: address.country.isEmpty
          ? VendorFormStrings.countryHint
          : address.country,
    );
  }

  @override
  void dispose() {
    _street.dispose();
    _city.dispose();
    _state.dispose();
    _postalCode.dispose();
    _country.dispose();
    super.dispose();
  }

  void _sync(VendorAddress address, {String? clearErrorFor}) {
    final notifier = ref.read(vendorRegistrationProvider.notifier);
    notifier.updateAddress(address);
    if (clearErrorFor != null) notifier.clearFieldError(clearErrorFor);
  }

  @override
  Widget build(BuildContext context) {
    final fieldErrors = ref.watch(vendorRegistrationProvider).fieldErrors;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      children: [
        const Text(
          'Store or warehouse address',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C1810),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'Where do you ship from or receive returns? This address appears on invoices.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B6055),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        VendorRegistrationErrorBanner(errors: fieldErrors),
        ProfileFormField(
          label: 'Street Address',
          error: fieldErrors[VendorRegistrationFieldKeys.street],
          child: ProfileTextInput(
            controller: _street,
            hint: VendorFormStrings.streetHint,
            hasError: fieldErrors.containsKey(VendorRegistrationFieldKeys.street),
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.address
                  .copyWith(street: v),
              clearErrorFor: VendorRegistrationFieldKeys.street,
            ),
          ),
        ),
        ProfileFormField(
          label: 'City',
          error: fieldErrors[VendorRegistrationFieldKeys.city],
          child: ProfileTextInput(
            controller: _city,
            hint: VendorFormStrings.cityHint,
            hasError: fieldErrors.containsKey(VendorRegistrationFieldKeys.city),
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.address.copyWith(city: v),
              clearErrorFor: VendorRegistrationFieldKeys.city,
            ),
          ),
        ),
        ProfileFormField(
          label: 'State / Province',
          error: fieldErrors[VendorRegistrationFieldKeys.state],
          child: ProfileTextInput(
            controller: _state,
            hint: VendorFormStrings.stateHint,
            hasError: fieldErrors.containsKey(VendorRegistrationFieldKeys.state),
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.address
                  .copyWith(state: v),
              clearErrorFor: VendorRegistrationFieldKeys.state,
            ),
          ),
        ),
        ProfileFormField(
          label: 'Postal Code',
          error: fieldErrors[VendorRegistrationFieldKeys.postalCode],
          child: ProfileTextInput(
            controller: _postalCode,
            hint: VendorFormStrings.postalCodeHint,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(5),
            ],
            hasError:
                fieldErrors.containsKey(VendorRegistrationFieldKeys.postalCode),
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.address
                  .copyWith(postalCode: v),
              clearErrorFor: VendorRegistrationFieldKeys.postalCode,
            ),
          ),
        ),
        ProfileFormField(
          label: 'Country',
          error: fieldErrors[VendorRegistrationFieldKeys.country],
          child: ProfileTextInput(
            controller: _country,
            hint: VendorFormStrings.countryHint,
            hasError:
                fieldErrors.containsKey(VendorRegistrationFieldKeys.country),
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.address
                  .copyWith(country: v),
              clearErrorFor: VendorRegistrationFieldKeys.country,
            ),
          ),
        ),
      ],
    );
  }
}
