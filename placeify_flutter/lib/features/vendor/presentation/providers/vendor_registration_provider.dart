import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/core/constants/country_phone_codes.dart';
import 'package:placeify_flutter/features/vendor/domain/constants/vendor_registration_field_keys.dart';
import 'package:placeify_flutter/features/vendor/domain/models/vendor_registration.dart';
import 'package:placeify_flutter/features/vendor/domain/repositories/vendor_registration_repository.dart';
import 'package:placeify_flutter/features/vendor/presentation/providers/vendor_document_repository_provider.dart';
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
    this.uploadingDocuments = const {},
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
  final Set<String> uploadingDocuments;

  bool get isLastStep => currentStep == stepCount - 1;
  bool get isReviewStep => currentStep == stepCount - 1;

  String? fieldError(String key) => fieldErrors[key];

  VendorRegistrationUiState copyWith({
    VendorRegistration? form,
    int? currentStep,
    bool? isSubmitting,
    String? submitError,
    Map<String, String>? fieldErrors,
    Set<String>? uploadingDocuments,
    bool clearSubmitError = false,
    bool clearFieldErrors = false,
  }) {
    return VendorRegistrationUiState(
      form: form ?? this.form,
      currentStep: currentStep ?? this.currentStep,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitError: clearSubmitError ? null : (submitError ?? this.submitError),
      fieldErrors: clearFieldErrors ? const {} : (fieldErrors ?? this.fieldErrors),
      uploadingDocuments: uploadingDocuments ?? this.uploadingDocuments,
    );
  }
}

@riverpod
class VendorRegistrationNotifier extends _$VendorRegistrationNotifier {
  @override
  VendorRegistrationUiState build() => const VendorRegistrationUiState();

  void updateBusiness(VendorBusinessInfo business) {
    state = state.copyWith(
      form: state.form.copyWith(business: business),
      clearFieldErrors: true,
    );
  }

  void updateAddress(VendorAddress address) {
    state = state.copyWith(
      form: state.form.copyWith(address: address),
      clearFieldErrors: true,
    );
  }

  void updateCategory(VendorCategoryInfo category) {
    state = state.copyWith(
      form: state.form.copyWith(category: category),
      clearFieldErrors: true,
    );
  }

  void updateDocuments(VendorDocuments documents) {
    state = state.copyWith(
      form: state.form.copyWith(documents: documents),
      clearFieldErrors: true,
    );
  }

  void updateBank(VendorBankDetails bank) {
    state = state.copyWith(
      form: state.form.copyWith(bank: bank),
      clearFieldErrors: true,
    );
  }

  void setStep(int step) {
    if (step < 0 || step >= VendorRegistrationUiState.stepCount) return;
    state = state.copyWith(currentStep: step, clearSubmitError: true);
  }

  Map<String, String> validateStepFields(int step) {
    if (step == 5) {
      final all = <String, String>{};
      for (var i = 0; i < 5; i++) {
        all.addAll(validateStepFields(i));
      }
      return all;
    }

    final form = state.form;
    final errors = <String, String>{};

    switch (step) {
      case 0:
        final b = form.business;
        if (b.businessName.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.businessName] =
              'Enter your business name';
        }
        if (b.contactName.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.contactName] =
              'Enter a contact name';
        }
        if (b.email.trim().isEmpty || !_isValidEmail(b.email)) {
          errors[VendorRegistrationFieldKeys.email] =
              'Enter a valid email address';
        }
        final phoneError = CountryPhoneCodes.validatePhone(b.phone);
        if (phoneError != null) {
          errors[VendorRegistrationFieldKeys.phone] = phoneError;
        }
        if (b.taxId.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.taxId] = 'Enter your tax ID';
        }
      case 1:
        final a = form.address;
        if (a.street.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.street] =
              'Enter your street address';
        }
        if (a.city.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.city] = 'Enter your city';
        }
        if (a.state.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.state] =
              'Enter your state / province';
        }
        if (a.postalCode.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.postalCode] =
              'Enter your postal code';
        }
        if (a.country.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.country] = 'Enter your country';
        }
      case 2:
        if (form.category.category.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.category] =
              'Select a product category';
        }
      case 3:
        final d = form.documents;
        if (!isUploadedVendorDocument(d.businessLicensePath)) {
          errors[VendorRegistrationFieldKeys.businessLicense] =
              'Upload your business license';
        }
        if (!isUploadedVendorDocument(d.governmentIdPath)) {
          errors[VendorRegistrationFieldKeys.governmentId] =
              'Upload a government-issued ID';
        }
      case 4:
        final bank = form.bank;
        if (bank.accountHolderName.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.accountHolderName] =
              'Enter the account holder name';
        }
        if (bank.bankName.trim().isEmpty) {
          errors[VendorRegistrationFieldKeys.bankName] = 'Enter your bank name';
        }
        if (bank.accountNumber.trim().length < 6) {
          errors[VendorRegistrationFieldKeys.accountNumber] =
              'Enter a valid account number';
        }
        if (bank.routingNumber.trim().length < 6) {
          errors[VendorRegistrationFieldKeys.routingNumber] =
              'Enter a valid branch / SWIFT code';
        }
    }

    return errors;
  }

  /// Returns the first validation error for a step, if any.
  String? validateStep(int step) {
    final errors = validateStepFields(step);
    if (errors.isEmpty) return null;
    return errors.values.first;
  }

  bool validateCurrentStep() => validateStepFields(state.currentStep).isEmpty;

  bool nextStep() {
    final errors = validateStepFields(state.currentStep);
    if (errors.isNotEmpty) {
      state = state.copyWith(fieldErrors: errors);
      return false;
    }
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

  Future<void> uploadDocument({
    required VendorDocumentType documentType,
    required String fieldKey,
    required String localPath,
    required VendorDocuments Function(VendorDocuments documents, String url)
        applyUrl,
  }) async {
    final uploading = {...state.uploadingDocuments, fieldKey};
    state = state.copyWith(
      uploadingDocuments: uploading,
      fieldErrors: Map<String, String>.from(state.fieldErrors)..remove(fieldKey),
    );

    try {
      final repo = ref.read(vendorDocumentRepositoryProvider);
      final url = await repo.upload(
        documentType: documentType,
        localPath: localPath,
      );
      state = state.copyWith(
        form: state.form.copyWith(
          documents: applyUrl(state.form.documents, url),
        ),
        uploadingDocuments: {...state.uploadingDocuments}..remove(fieldKey),
      );
    } catch (error) {
      state = state.copyWith(
        uploadingDocuments: {...state.uploadingDocuments}..remove(fieldKey),
        fieldErrors: {
          ...state.fieldErrors,
          fieldKey: error.toString(),
        },
      );
    }
  }

  Future<String?> submit() async {
    final errors = validateStepFields(5);
    if (errors.isNotEmpty) {
      state = state.copyWith(fieldErrors: errors, submitError: errors.values.first);
      return null;
    }

    state = state.copyWith(
      isSubmitting: true,
      clearSubmitError: true,
      clearFieldErrors: true,
    );

    try {
      final repo = ref.read(vendorRegistrationRepositoryProvider);
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
