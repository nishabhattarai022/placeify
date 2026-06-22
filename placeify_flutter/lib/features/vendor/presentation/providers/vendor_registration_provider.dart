import 'package:placeify_flutter/features/vendor/domain/constants/vendor_strings.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_registration_repository.dart';
import 'package:placeify_flutter/features/vendor/domain/validators/vendor_registration_validator.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_registration_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'vendor_registration_provider.g.dart';

/// UI state for the multi-step vendor registration flow.
class VendorRegistrationUiState {
  const VendorRegistrationUiState({
    this.form = const VendorRegistration(),
    this.currentStep = 0,
    this.isSubmitting = false,
    this.submitError,
    this.fieldErrors = const {},
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
  final Map<String, String> fieldErrors;

  bool get isLastStep => currentStep == stepCount - 1;
  bool get isReviewStep => currentStep == stepCount - 1;
  bool get hasFieldErrors => fieldErrors.isNotEmpty;

  VendorRegistrationUiState copyWith({
    VendorRegistration? form,
    int? currentStep,
    bool? isSubmitting,
    String? submitError,
    Map<String, String>? fieldErrors,
    bool clearSubmitError = false,
    bool clearFieldErrors = false,
  }) {
    return VendorRegistrationUiState(
      form: form ?? this.form,
      currentStep: currentStep ?? this.currentStep,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      fieldErrors: clearFieldErrors
          ? const {}
          : (fieldErrors ?? this.fieldErrors),
    );
  }
}

@riverpod
class VendorRegistrationNotifier extends _$VendorRegistrationNotifier {
  @override
  VendorRegistrationUiState build() {
    const initial = VendorRegistrationUiState();
    final address = initial.form.address;
    if (address.country.isNotEmpty) return initial;

    return initial.copyWith(
      form: initial.form.copyWith(
        address: address.copyWith(country: VendorFormStrings.countryHint),
      ),
    );
  }

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

  void clearFieldError(String fieldKey) {
    if (!state.fieldErrors.containsKey(fieldKey)) return;
    final next = Map<String, String>.from(state.fieldErrors)..remove(fieldKey);
    state = state.copyWith(fieldErrors: next);
  }

  void setStep(int step) {
    if (step < 0 || step >= VendorRegistrationUiState.stepCount) return;
    state = state.copyWith(
      currentStep: step,
      clearSubmitError: true,
      clearFieldErrors: true,
    );
  }

  /// Validates [step] and stores per-field errors on state.
  Map<String, String> validateStep(int step) {
    return VendorRegistrationValidator.validateStep(step, state.form);
  }

  /// Validates the current step, stores field errors, and returns whether valid.
  bool validateCurrentStep() {
    final errors = validateStep(state.currentStep);
    state = state.copyWith(fieldErrors: errors, clearSubmitError: true);
    return errors.isEmpty;
  }

  /// Advances to the next step when the current step is valid.
  bool nextStep() {
    if (!validateCurrentStep()) return false;
    if (state.currentStep < VendorRegistrationUiState.stepCount - 1) {
      state = state.copyWith(
        currentStep: state.currentStep + 1,
        clearSubmitError: true,
        clearFieldErrors: true,
      );
    }
    return true;
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(
        currentStep: state.currentStep - 1,
        clearSubmitError: true,
        clearFieldErrors: true,
      );
    }
  }

  Future<String?> submit() async {
    final invalidStep =
        VendorRegistrationValidator.firstInvalidStep(state.form);
    if (invalidStep != null) {
      final errors = validateStep(invalidStep);
      state = state.copyWith(
        currentStep: invalidStep,
        fieldErrors: errors,
        submitError: null,
      );
      return null;
    }

    state = state.copyWith(
      isSubmitting: true,
      clearSubmitError: true,
      clearFieldErrors: true,
    );

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
}
