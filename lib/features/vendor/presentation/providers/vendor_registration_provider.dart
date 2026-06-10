import 'package:placeify/features/vendor/domain/models/vendor_registration.dart';
import 'package:placeify/features/vendor/domain/repositories/vendor_registration_repository.dart';
import 'package:placeify/features/vendor/presentation/providers/vendor_registration_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_registration_provider.g.dart';

/// UI state for the multi-step vendor registration flow.
class VendorRegistrationUiState {
  const VendorRegistrationUiState({
    this.form = const VendorRegistration(),
    this.currentStep = 0,
    this.isSubmitting = false,
    this.submitError,
  });

  static const int stepCount = 6;

  static const List<String> stepTitles = [
    'Business Info',
    'Address',
    'Category',
    'Documents',
    'Bank Details',
    'Review',
  ];

  final VendorRegistration form;
  final int currentStep;
  final bool isSubmitting;
  final String? submitError;

  bool get isLastStep => currentStep == stepCount - 1;
  bool get isReviewStep => currentStep == stepCount - 1;

  VendorRegistrationUiState copyWith({
    VendorRegistration? form,
    int? currentStep,
    bool? isSubmitting,
    String? submitError,
    bool clearSubmitError = false,
  }) {
    return VendorRegistrationUiState(
      form: form ?? this.form,
      currentStep: currentStep ?? this.currentStep,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
    );
  }
}

@riverpod
class VendorRegistrationNotifier extends _$VendorRegistrationNotifier {
  @override
  VendorRegistrationUiState build() => const VendorRegistrationUiState();

  void updateBusiness(VendorBusinessInfo business) {
    state = state.copyWith(form: state.form.copyWith(business: business));
  }

  void updateAddress(VendorAddress address) {
    state = state.copyWith(form: state.form.copyWith(address: address));
  }

  void updateCategory(VendorCategoryInfo category) {
    state = state.copyWith(form: state.form.copyWith(category: category));
  }

  void updateDocuments(VendorDocuments documents) {
    state = state.copyWith(form: state.form.copyWith(documents: documents));
  }

  void updateBank(VendorBankDetails bank) {
    state = state.copyWith(form: state.form.copyWith(bank: bank));
  }

  void setStep(int step) {
    if (step < 0 || step >= VendorRegistrationUiState.stepCount) return;
    state = state.copyWith(currentStep: step, clearSubmitError: true);
  }

  /// Returns an error message when the step is invalid, otherwise null.
  String? validateStep(int step) {
    final form = state.form;
    switch (step) {
      case 0:
        final b = form.business;
        if (b.businessName.trim().isEmpty) {
          return 'Enter your business name';
        }
        if (b.contactName.trim().isEmpty) {
          return 'Enter a contact name';
        }
        if (b.email.trim().isEmpty || !_isValidEmail(b.email)) {
          return 'Enter a valid email address';
        }
        if (b.phone.trim().length < 7) {
          return 'Enter a valid phone number';
        }
        if (b.taxId.trim().isEmpty) {
          return 'Enter your tax ID';
        }
        return null;
      case 1:
        final a = form.address;
        if (a.street.trim().isEmpty) return 'Enter your street address';
        if (a.city.trim().isEmpty) return 'Enter your city';
        if (a.state.trim().isEmpty) return 'Enter your state / province';
        if (a.postalCode.trim().isEmpty) return 'Enter your postal code';
        if (a.country.trim().isEmpty) return 'Enter your country';
        return null;
      case 2:
        if (form.category.category.trim().isEmpty) {
          return 'Select a product category';
        }
        return null;
      case 3:
        final d = form.documents;
        if (d.businessLicensePath == null) {
          return 'Upload your business license';
        }
        if (d.governmentIdPath == null) {
          return 'Upload a government-issued ID';
        }
        return null;
      case 4:
        final bank = form.bank;
        if (bank.accountHolderName.trim().isEmpty) {
          return 'Enter the account holder name';
        }
        if (bank.bankName.trim().isEmpty) return 'Enter your bank name';
        if (bank.accountNumber.trim().length < 6) {
          return 'Enter a valid account number';
        }
        if (bank.routingNumber.trim().length < 6) {
          return 'Enter a valid routing number';
        }
        return null;
      case 5:
        for (var i = 0; i < 5; i++) {
          final error = validateStep(i);
          if (error != null) return error;
        }
        return null;
      default:
        return null;
    }
  }

  /// Validates the current step. Returns false when invalid.
  bool validateCurrentStep() => validateStep(state.currentStep) == null;

  /// Advances to the next step when the current step is valid.
  bool nextStep() {
    if (!validateCurrentStep()) return false;
    if (state.currentStep < VendorRegistrationUiState.stepCount - 1) {
      state = state.copyWith(
        currentStep: state.currentStep + 1,
        clearSubmitError: true,
      );
    }
    return true;
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(
        currentStep: state.currentStep - 1,
        clearSubmitError: true,
      );
    }
  }

  Future<String?> submit() async {
    final validationError = validateStep(5);
    if (validationError != null) {
      state = state.copyWith(submitError: validationError);
      return null;
    }

    state = state.copyWith(isSubmitting: true, clearSubmitError: true);

    try {
      final repo = await ref.read(vendorRegistrationRepositoryProvider.future);
      final vendorId = await repo.submitRegistration(state.form);
      state = state.copyWith(isSubmitting: false);
      return vendorId;
    } on VendorRegistrationException catch (e) {
      state = state.copyWith(isSubmitting: false, submitError: e.message);
      return null;
    } catch (_) {
      state = state.copyWith(
        isSubmitting: false,
        submitError: 'Something went wrong. Please try again.',
      );
      return null;
    }
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  }
}
