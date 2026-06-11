import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../profile/presentation/widgets/shared/profile_form_field.dart';
import '../../../domain/models/vendor_registration.dart';
import '../../providers/vendor_registration_provider.dart';

class BankDetailsStep extends ConsumerStatefulWidget {
  const BankDetailsStep({super.key});

  @override
  ConsumerState<BankDetailsStep> createState() => _BankDetailsStepState();
}

class _BankDetailsStepState extends ConsumerState<BankDetailsStep> {
  late final TextEditingController _accountHolder;
  late final TextEditingController _bankName;
  late final TextEditingController _accountNumber;
  late final TextEditingController _routingNumber;

  @override
  void initState() {
    super.initState();
    final bank = ref.read(vendorRegistrationProvider).form.bank;
    _accountHolder = TextEditingController(text: bank.accountHolderName);
    _bankName = TextEditingController(text: bank.bankName);
    _accountNumber = TextEditingController(text: bank.accountNumber);
    _routingNumber = TextEditingController(text: bank.routingNumber);
  }

  @override
  void dispose() {
    _accountHolder.dispose();
    _bankName.dispose();
    _accountNumber.dispose();
    _routingNumber.dispose();
    super.dispose();
  }

  void _sync(VendorBankDetails bank) {
    ref.read(vendorRegistrationProvider.notifier).updateBank(bank);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 24),
      children: [
        const Text(
          'Payout bank details',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2C1810),
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'We use this account to send your earnings. Details are encrypted in production.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B6055),
            height: 1.45,
          ),
        ),
        const SizedBox(height: 20),
        ProfileFormField(
          label: 'Account Holder Name',
          child: ProfileTextInput(
            controller: _accountHolder,
            hint: 'Name on the account',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.bank
                  .copyWith(accountHolderName: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'Bank Name',
          child: ProfileTextInput(
            controller: _bankName,
            hint: 'e.g. Chase, Wells Fargo',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.bank
                  .copyWith(bankName: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'Account Number',
          child: ProfileTextInput(
            controller: _accountNumber,
            hint: '••••••••••',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.bank
                  .copyWith(accountNumber: v),
            ),
          ),
        ),
        ProfileFormField(
          label: 'Routing Number',
          child: ProfileTextInput(
            controller: _routingNumber,
            hint: '9-digit routing number',
            onChanged: (v) => _sync(
              ref.read(vendorRegistrationProvider).form.bank
                  .copyWith(routingNumber: v),
            ),
          ),
        ),
      ],
    );
  }
}
