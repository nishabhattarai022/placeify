import 'package:placeify/features/vendor/domain/constants/vendor_strings.dart';

/// User-facing copy for the vendor store profile screen (view + edit modes).
abstract final class VendorProfileStrings {
  // Screen chrome
  static const screenTitle = 'Store Profile';
  static const editProfile = 'Edit Profile';
  static const activeBadge = VendorStrings.activeBadge;

  // Stats strip
  static const productsMetric = 'Products';
  static const ordersMetric = 'Orders';
  static const avgRatingMetric = 'Avg Rating';
  static const responseRateMetric = 'Response Rate';

  // Section titles
  static const storeInfoSection = 'Store Info';
  static const aboutSection = 'About';
  static const contactSection = 'Contact';
  static const categoriesSection = 'Categories';
  static const operatingHoursSection = 'Operating Hours';
  static const socialLinksSection = 'Social Links';

  // Header
  static const _monthAbbreviations = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String memberSince(DateTime createdAt) {
    final month = _monthAbbreviations[createdAt.month - 1];
    return 'Member since $month ${createdAt.year}';
  }

  // Image picker
  static const storeBanner = 'Store banner';
  static const storeLogo = 'Store logo';
  static const bannerRatioHint = 'Recommended 3:1 aspect ratio';
  static const logoRatioHint = 'Recommended 1:1 aspect ratio';
  static const changeBanner = 'Change banner';
  static const changeLogo = 'Change logo';

  // Image picker bottom sheet
  static const chooseFromGallery = 'Choose from gallery';
  static const removeBackground = 'Remove background';
  static const cancel = 'Cancel';

  // Form labels
  static const businessNameLabel = 'Business Name';
  static const emailLabel = 'Email';
  static const phoneLabel = 'Phone';
  static const addressLabel = 'Address';
  static const bioLabel = 'Bio';
  static const instagramLabel = 'Instagram';
  static const facebookLabel = 'Facebook';
  static const websiteLabel = 'Website';

  // Form hints
  static const businessNameHint = 'Your store name';
  static const emailHint = 'vendor@example.com';
  static const addressHint = 'Store location';
  static const bioHint = 'Tell customers about your store';
  static const instagramHint = '@yourstore';
  static const facebookHint = 'facebook.com/yourstore';
  static const websiteHint = 'https://yourstore.com';
  static const addInstagram = 'Add Instagram…';
  static const addFacebook = 'Add Facebook…';
  static const addWebsite = 'Add website…';

  // Operating hours editor
  static const copyToAllDays = 'Copy to all days';
  static const closedLabel = 'Closed';
  static const openLabel = 'Open';
  static const closeLabel = 'Close';

  static const dayLabels = {
    'monday': 'Monday',
    'tuesday': 'Tuesday',
    'wednesday': 'Wednesday',
    'thursday': 'Thursday',
    'friday': 'Friday',
    'saturday': 'Saturday',
    'sunday': 'Sunday',
  };

  static String dayLabel(String dayKey) =>
      dayLabels[dayKey] ?? dayKey;

  // Edit bar
  static const saveChanges = 'Save Changes';
  static const discardChanges = 'Discard Changes';

  // Discard bottom sheet
  static const discardTitle = 'Discard changes?';
  static const discardSubtitle =
      'Your unsaved edits will be lost if you leave this screen.';
  static const keepEditing = 'Keep Editing';

  // Settings link
  static const storeSettings = 'Store settings';
  static const switchToShopping = 'Switch to shopping';

  // Empty / loading
  static const noProfileFound = 'No vendor profile found.';

  // Toasts
  static const profileUpdated = 'Profile updated successfully';
  static const fixValidationErrors = 'Please fix the errors below';

  // Validation errors
  static const storeNameRequired = 'Enter your store name';
  static const storeNameTooShort = 'Store name must be at least 3 characters';
  static const storeNameTooLong = 'Store name must be 50 characters or fewer';
  static const bioTooLong = 'Bio must be 300 characters or fewer';
  static const emailRequired = 'Enter your email address';
  static const emailInvalid = 'Enter a valid email address';
  static const phoneRequired = 'Enter your phone number';
  static const phoneInvalid = 'Enter a valid phone number (at least 7 digits)';
  static const tagsRequired = 'Select at least one category';
  static const tagsTooMany = 'You can select up to 5 categories';
  static const scheduleInvalidTime = 'Enter valid opening and closing times';
  static String scheduleCloseBeforeOpen(String dayLabel) =>
      'Closing time must be after opening time on $dayLabel';
  static const instagramUrlInvalid = 'Enter a valid Instagram URL';
  static const facebookUrlInvalid = 'Enter a valid Facebook URL';
  static const websiteUrlInvalid = 'Enter a valid website URL';

  // Bio counter
  static const bioMaxLength = 300;
}
