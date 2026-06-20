/// User-facing copy for vendor status gates, profile tile, and registration flow.
abstract final class VendorStrings {
  // Profile tile copy
  static const becomeVendorTitle = 'Become a Vendor';
  static const becomeVendorSubtitle = 'Start selling on Placeify';
  static const applicationPendingTitle = 'Application Pending';
  static const applicationPendingSubtitle = "We'll notify you once approved";
  static const vendorDashboardTitle = 'Vendor Dashboard';
  static const vendorDashboardSubtitle = 'Manage your store';
  static const storeSuspendedTitle = 'Store Suspended';
  static const storeSuspendedSubtitle = 'Tap to learn more';
  static const activeBadge = 'Active';

  // Toasts
  static const applicationSubmitted =
      "Application submitted! We'll review within 24 hours";
  static const noChangesToSave = 'No changes to save';
  static const guardPendingToast =
      'Your vendor application is still under review';
  static const guardSuspendedToast =
      'Your store is suspended. Contact support for help.';
  static const contactSupportToast =
      'Support request noted. Our team will get back to you shortly.';
  static const appealSubmittedToast =
      'Appeal submitted. Our team will review your request.';

  // Bottom sheets
  static const pendingSheetTitle = 'Application under review';
  static const pendingSheetBody =
      'Thanks for applying to sell on Placeify. Our team is reviewing your '
      'store details and will notify you once your application is approved. '
      'This usually takes up to 24 hours.';
  static const contactSupport = 'Contact Support';
  static const suspendedSheetTitle = 'Store suspended';
  static const suspendedSheetBody =
      'Your store is currently suspended and cannot accept new orders. '
      'This may be due to a policy violation or an unresolved account issue. '
      'Contact support or submit an appeal if you believe this was a mistake.';
  static const appealCta = 'Submit an Appeal';
  static const keepEditing = 'Keep Editing';
  static const dismiss = 'Dismiss';

  // Product form
  static const uploadProduct = 'Upload Product';
  static const saveChanges = 'Save Changes';
  static const noChangesLabel = 'No Changes';
  static const productSaved = 'Product saved successfully';
  static const changesSaved = 'Changes saved';
}

/// Nepal-first placeholders and labels for vendor registration and profile forms.
abstract final class VendorFormStrings {
  static const businessNameHint = 'e.g. Himalayan Home Crafts';
  static const contactNameHint = 'e.g. Sita Sharma';
  static const taxIdLabel = 'PAN / VAT Number';
  static const taxIdHint = 'e.g. 123456789';
  static const streetHint = 'e.g. Thamel, Kathmandu';
  static const cityHint = 'Kathmandu';
  static const stateHint = 'Bagmati';
  static const postalCodeHint = '44600';
  static const countryHint = 'Nepal';
  static const bankNameHint = 'e.g. Nabil Bank, NIC Asia';
  static const branchSwiftLabel = 'Branch / SWIFT Code';
  static const branchSwiftHint = 'e.g. NIBLNPKT';

  static const fixValidationErrors =
      'Please fix the highlighted fields below before continuing';
}
