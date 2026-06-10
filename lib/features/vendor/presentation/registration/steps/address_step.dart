import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../profile/presentation/widgets/shared/profile_form_field.dart';
import '../../../domain/models/vendor_registration.dart';
import '../../providers/vendor_registration_provider.dart';

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
    _country = TextEditingController(text: address.country);
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

  void _sync(VendorAddress address) {
    ref.read(vendorRegistrationProvider.notifier).updateAddress(address);
  }

  @override
  Widget build(BuildContext context) {
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
        ProfileFormField(
          label: 'Street Address',
          child: ProfileTextInput(
            controller: _street,
            hint: '123 Market Street',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.address
                  .copyWith(street: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'City',
          child: ProfileTextInput(
            controller: _city,
            hint: 'San Francisco',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.address
                  .copyWith(city: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'State / Province',
          child: ProfileTextInput(
            controller: _state,
            hint: 'CA',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.address
                  .copyWith(state: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'Postal Code',
          child: ProfileTextInput(
            controller: _postalCode,
            hint: '94103',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.address
                  .copyWith(postalCode: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'Country',
          child: ProfileTextInput(
            controller: _country,
            hint: 'United States',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.address
                  .copyWith(country: v),
            ),
          ),
        ),
      ],
    );
  }
}
