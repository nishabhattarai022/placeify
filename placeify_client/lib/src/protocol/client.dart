/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i1;
import 'package:serverpod_client/serverpod_client.dart' as _i2;
import 'dart:async' as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:placeify_client/src/protocol/user.dart' as _i5;
import 'package:placeify_client/src/protocol/user_role.dart' as _i6;
import 'dart:typed_data' as _i7;
import 'package:placeify_client/src/protocol/user_dashboard.dart' as _i8;
import 'package:placeify_client/src/protocol/user_order_summary.dart' as _i9;
import 'package:placeify_client/src/protocol/order_status.dart' as _i10;
import 'package:placeify_client/src/protocol/user_order_detail.dart' as _i11;
import 'package:placeify_client/src/protocol/user_order_payment_summary.dart'
    as _i12;
import 'package:placeify_client/src/protocol/user_ar_session_summary.dart'
    as _i13;
import 'package:placeify_client/src/protocol/greetings/greeting.dart' as _i14;
import 'package:placeify_client/src/protocol/admin.dart' as _i15;
import 'package:placeify_client/src/protocol/admin_type.dart' as _i16;
import 'package:placeify_client/src/protocol/in_app_notification_summary.dart'
    as _i17;
import 'package:placeify_client/src/protocol/vendor.dart' as _i18;
import 'package:placeify_client/src/protocol/vendor_moderation_result.dart'
    as _i19;
import 'package:placeify_client/src/protocol/user_account_status.dart' as _i20;
import 'package:placeify_client/src/protocol/product.dart' as _i21;
import 'package:placeify_client/src/protocol/complaint.dart' as _i22;
import 'package:placeify_client/src/protocol/complaint_status.dart' as _i23;
import 'package:placeify_client/src/protocol/pagination_input.dart' as _i24;
import 'package:placeify_client/src/protocol/admin_platform_stats.dart' as _i25;
import 'package:placeify_client/src/protocol/platform_user_summary.dart'
    as _i26;
import 'package:placeify_client/src/protocol/platform_user_detail.dart' as _i27;
import 'package:placeify_client/src/protocol/vendor_application_summary.dart'
    as _i28;
import 'package:placeify_client/src/protocol/vendor_application_detail.dart'
    as _i29;
import 'package:placeify_client/src/protocol/admin_audit_log_summary.dart'
    as _i30;
import 'package:placeify_client/src/protocol/admin_vendor_payout_summary.dart'
    as _i31;
import 'package:placeify_client/src/protocol/vendor_payout_status.dart' as _i32;
import 'package:placeify_client/src/protocol/admin_refund_request_summary.dart'
    as _i33;
import 'package:placeify_client/src/protocol/request_status.dart' as _i34;
import 'package:placeify_client/src/protocol/admin_product_summary.dart'
    as _i35;
import 'package:placeify_client/src/protocol/admin_product_list_input.dart'
    as _i36;
import 'package:placeify_client/src/protocol/admin_product_detail.dart' as _i37;
import 'package:placeify_client/src/protocol/ar_session.dart' as _i38;
import 'package:placeify_client/src/protocol/cart_item.dart' as _i39;
import 'package:placeify_client/src/protocol/checkout_result.dart' as _i40;
import 'package:placeify_client/src/protocol/checkout_request.dart' as _i41;
import 'package:placeify_client/src/protocol/notification_preference.dart'
    as _i42;
import 'package:placeify_client/src/protocol/order_page.dart' as _i43;
import 'package:placeify_client/src/protocol/order.dart' as _i44;
import 'package:placeify_client/src/protocol/order_delivery_update.dart'
    as _i45;
import 'package:placeify_client/src/protocol/vendor_payments_overview.dart'
    as _i46;
import 'package:placeify_client/src/protocol/payment_update_summary.dart'
    as _i47;
import 'package:placeify_client/src/protocol/payment_transaction_status.dart'
    as _i48;
import 'package:placeify_client/src/protocol/vendor_payout_summary.dart'
    as _i49;
import 'package:placeify_client/src/protocol/category.dart' as _i50;
import 'package:placeify_client/src/protocol/product_page.dart' as _i51;
import 'package:placeify_client/src/protocol/product_search_input.dart' as _i52;
import 'package:placeify_client/src/protocol/vendor_profile_detail.dart'
    as _i53;
import 'package:placeify_client/src/protocol/shop_listing_summary.dart' as _i54;
import 'package:placeify_client/src/protocol/marketplace_highlights.dart'
    as _i55;
import 'package:placeify_client/src/protocol/refund_request_summary.dart'
    as _i56;
import 'package:placeify_client/src/protocol/review.dart' as _i57;
import 'package:placeify_client/src/protocol/vendor_dashboard.dart' as _i58;
import 'package:placeify_client/src/protocol/vendor_bank_details_input.dart'
    as _i59;
import 'package:placeify_client/src/protocol/vendor_bank_details.dart' as _i60;
import 'package:placeify_client/src/protocol/vendor_profile_update_input.dart'
    as _i61;
import 'package:placeify_client/src/protocol/vendor_document_type.dart' as _i62;
import 'package:placeify_client/src/protocol/vendor_product_upload_input.dart'
    as _i63;
import 'package:placeify_client/src/protocol/vendor_shop_order.dart' as _i64;
import 'package:placeify_client/src/protocol/delivery_stage.dart' as _i65;
import 'package:placeify_client/src/protocol/vendor_notification_summary.dart'
    as _i66;
import 'package:placeify_client/src/protocol/vendor_review_summary.dart'
    as _i67;
import 'package:placeify_client/src/protocol/wishlist_page.dart' as _i68;
import 'package:placeify_client/src/protocol/wishlist_item.dart' as _i69;
import 'protocol.dart' as _i70;

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i1.EndpointEmailIdpBase {
  EndpointEmailIdp(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  /// Logs in the user and returns a new session.
  ///
  /// Throws an [EmailAccountLoginException] in case of errors, with reason:
  /// - [EmailAccountLoginExceptionReason.invalidCredentials] if the email or
  ///   password is incorrect.
  /// - [EmailAccountLoginExceptionReason.tooManyAttempts] if there have been
  ///   too many failed login attempts.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<_i4.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  /// Starts the registration for a new user account with an email-based login
  /// associated to it.
  ///
  /// Upon successful completion of this method, an email will have been
  /// sent to [email] with a verification link, which the user must open to
  /// complete the registration.
  ///
  /// Always returns a account request ID, which can be used to complete the
  /// registration. If the email is already registered, the returned ID will not
  /// be valid.
  @override
  _i3.Future<_i2.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startRegistration',
        {'email': email},
      );

  /// Verifies an account request code and returns a token
  /// that can be used to complete the account creation.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if no request exists
  ///   for the given [accountRequestId] or [verificationCode] is invalid.
  @override
  _i3.Future<String> verifyRegistrationCode({
    required _i2.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a new account registration, creating a new auth user with a
  /// profile and attaching the given email account to it.
  ///
  /// Throws an [EmailAccountRequestException] in case of errors, with reason:
  /// - [EmailAccountRequestExceptionReason.expired] if the account request has
  ///   already expired.
  /// - [EmailAccountRequestExceptionReason.policyViolation] if the password
  ///   does not comply with the password policy.
  /// - [EmailAccountRequestExceptionReason.invalid] if the [registrationToken]
  ///   is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  ///
  /// Returns a session for the newly created user.
  @override
  _i3.Future<_i4.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  /// Requests a password reset for [email].
  ///
  /// If the email address is registered, an email with reset instructions will
  /// be send out. If the email is unknown, this method will have no effect.
  ///
  /// Always returns a password reset request ID, which can be used to complete
  /// the reset. If the email is not registered, the returned ID will not be
  /// valid.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to request a password reset.
  ///
  @override
  _i3.Future<_i2.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i2.UuidValue>(
        'emailIdp',
        'startPasswordReset',
        {'email': email},
      );

  /// Verifies a password reset code and returns a finishPasswordResetToken
  /// that can be used to finish the password reset.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.tooManyAttempts] if the user has
  ///   made too many attempts trying to verify the password reset.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// If multiple steps are required to complete the password reset, this endpoint
  /// should be overridden to return credentials for the next step instead
  /// of the credentials for setting the password.
  @override
  _i3.Future<String> verifyPasswordResetCode({
    required _i2.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  /// Completes a password reset request by setting a new password.
  ///
  /// The [verificationCode] returned from [verifyPasswordResetCode] is used to
  /// validate the password reset request.
  ///
  /// Throws an [EmailAccountPasswordResetException] in case of errors, with reason:
  /// - [EmailAccountPasswordResetExceptionReason.expired] if the password reset
  ///   request has already expired.
  /// - [EmailAccountPasswordResetExceptionReason.policyViolation] if the new
  ///   password does not comply with the password policy.
  /// - [EmailAccountPasswordResetExceptionReason.invalid] if no request exists
  ///   for the given [passwordResetRequestId] or [verificationCode] is invalid.
  ///
  /// Throws an [AuthUserBlockedException] if the auth user is blocked.
  @override
  _i3.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _i3.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'jwtRefresh';

  /// Creates a new token pair for the given [refreshToken].
  ///
  /// Can throw the following exceptions:
  /// -[RefreshTokenMalformedException]: refresh token is malformed and could
  ///   not be parsed. Not expected to happen for tokens issued by the server.
  /// -[RefreshTokenNotFoundException]: refresh token is unknown to the server.
  ///   Either the token was deleted or generated by a different server.
  /// -[RefreshTokenExpiredException]: refresh token has expired. Will happen
  ///   only if it has not been used within configured `refreshTokenLifetime`.
  /// -[RefreshTokenInvalidSecretException]: refresh token is incorrect, meaning
  ///   it does not refer to the current secret refresh token. This indicates
  ///   either a malfunctioning client or a malicious attempt by someone who has
  ///   obtained the refresh token. In this case the underlying refresh token
  ///   will be deleted, and access to it will expire fully when the last access
  ///   token is elapsed.
  ///
  /// This endpoint is unauthenticated, meaning the client won't include any
  /// authentication information with the call.
  @override
  _i3.Future<_i4.AuthSuccess> refreshAccessToken({
    required String refreshToken,
  }) => caller.callServerEndpoint<_i4.AuthSuccess>(
    'jwtRefresh',
    'refreshAccessToken',
    {'refreshToken': refreshToken},
    authenticated: false,
  );
}

/// Base endpoint for authenticated Placeify APIs.
/// {@category Endpoint}
abstract class EndpointPlaceifyAuthenticated extends _i2.EndpointRef {
  EndpointPlaceifyAuthenticated(_i2.EndpointCaller caller) : super(caller);

  _i3.Future<_i5.User> requirePlaceifyUser();

  _i3.Future<_i5.User> requireRole(Set<_i6.UserRole> allowedRoles);
}

/// Profile and dashboard APIs for authenticated customers.
/// {@category Endpoint}
class EndpointUser extends EndpointPlaceifyAuthenticated {
  EndpointUser(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _i3.Future<_i5.User?> getCurrentUser() =>
      caller.callServerEndpoint<_i5.User?>(
        'user',
        'getCurrentUser',
        {},
      );

  _i3.Future<_i5.User> updateProfile(
    String name, {
    String? phone,
    String? address,
  }) => caller.callServerEndpoint<_i5.User>(
    'user',
    'updateProfile',
    {
      'name': name,
      'phone': phone,
      'address': address,
    },
  );

  _i3.Future<_i5.User> changePassword(
    String currentPassword,
    String newPassword,
  ) => caller.callServerEndpoint<_i5.User>(
    'user',
    'changePassword',
    {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    },
  );

  _i3.Future<_i5.User> uploadProfileImage(
    _i7.ByteData fileData,
    String fileName,
  ) => caller.callServerEndpoint<_i5.User>(
    'user',
    'uploadProfileImage',
    {
      'fileData': fileData,
      'fileName': fileName,
    },
  );

  _i3.Future<_i5.User> becomeVendor() => caller.callServerEndpoint<_i5.User>(
    'user',
    'becomeVendor',
    {},
  );

  _i3.Future<_i5.User> becomeConsumer() => caller.callServerEndpoint<_i5.User>(
    'user',
    'becomeConsumer',
    {},
  );

  _i3.Future<_i8.UserDashboard> getDashboard() =>
      caller.callServerEndpoint<_i8.UserDashboard>(
        'user',
        'getDashboard',
        {},
      );

  _i3.Future<_i5.User> ensureDemoAdmin() => caller.callServerEndpoint<_i5.User>(
    'user',
    'ensureDemoAdmin',
    {},
  );

  _i3.Future<List<_i9.UserOrderSummary>> listMyOrders({
    required int limit,
    required int offset,
    _i10.OrderStatus? status,
  }) => caller.callServerEndpoint<List<_i9.UserOrderSummary>>(
    'user',
    'listMyOrders',
    {
      'limit': limit,
      'offset': offset,
      'status': status,
    },
  );

  _i3.Future<_i11.UserOrderDetail> getMyOrder(int orderId) =>
      caller.callServerEndpoint<_i11.UserOrderDetail>(
        'user',
        'getMyOrder',
        {'orderId': orderId},
      );

  _i3.Future<_i11.UserOrderDetail> cancelMyOrder(
    int orderId,
    String reason,
  ) => caller.callServerEndpoint<_i11.UserOrderDetail>(
    'user',
    'cancelMyOrder',
    {
      'orderId': orderId,
      'reason': reason,
    },
  );

  _i3.Future<_i12.UserOrderPaymentSummary> getMyOrderPayment(int orderId) =>
      caller.callServerEndpoint<_i12.UserOrderPaymentSummary>(
        'user',
        'getMyOrderPayment',
        {'orderId': orderId},
      );

  _i3.Future<List<_i12.UserOrderPaymentSummary>> listMyPayments({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i12.UserOrderPaymentSummary>>(
    'user',
    'listMyPayments',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  /// Signed eSewa form fields (JSON) for an unpaid eSewa order.
  _i3.Future<String> getEsewaPaymentForm(int orderId) =>
      caller.callServerEndpoint<String>(
        'user',
        'getEsewaPaymentForm',
        {'orderId': orderId},
      );

  _i3.Future<_i12.UserOrderPaymentSummary> completePayment(int orderId) =>
      caller.callServerEndpoint<_i12.UserOrderPaymentSummary>(
        'user',
        'completePayment',
        {'orderId': orderId},
      );

  _i3.Future<List<_i13.UserArSessionSummary>> listMyArSessions({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i13.UserArSessionSummary>>(
    'user',
    'listMyArSessions',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  @override
  _i3.Future<_i5.User> requirePlaceifyUser() =>
      caller.callServerEndpoint<_i5.User>(
        'user',
        'requirePlaceifyUser',
        {},
      );

  @override
  _i3.Future<_i5.User> requireRole(Set<_i6.UserRole> allowedRoles) =>
      caller.callServerEndpoint<_i5.User>(
        'user',
        'requireRole',
        {'allowedRoles': allowedRoles},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i2.EndpointRef {
  EndpointGreeting(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i3.Future<_i14.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i14.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// Admin profile APIs for platform administrators.
/// {@category Endpoint}
class EndpointAdmin extends EndpointPlaceifyAuthenticated {
  EndpointAdmin(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i3.Future<bool> hasAdminProfile() => caller.callServerEndpoint<bool>(
    'admin',
    'hasAdminProfile',
    {},
  );

  _i3.Future<_i15.Admin?> getMyAdmin() =>
      caller.callServerEndpoint<_i15.Admin?>(
        'admin',
        'getMyAdmin',
        {},
      );

  _i3.Future<_i15.Admin> getMyProfile() =>
      caller.callServerEndpoint<_i15.Admin>(
        'admin',
        'getMyProfile',
        {},
      );

  _i3.Future<_i15.Admin> updateMyProfile(
    String fullName, {
    String? email,
    String? phoneNumber,
    _i16.AdminType? adminType,
    bool? isActive,
  }) => caller.callServerEndpoint<_i15.Admin>(
    'admin',
    'updateMyProfile',
    {
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'adminType': adminType,
      'isActive': isActive,
    },
  );

  _i3.Future<_i15.Admin> updateNotificationPreferences({
    required bool newApplicationAlerts,
    required bool systemAlerts,
  }) => caller.callServerEndpoint<_i15.Admin>(
    'admin',
    'updateNotificationPreferences',
    {
      'newApplicationAlerts': newApplicationAlerts,
      'systemAlerts': systemAlerts,
    },
  );

  _i3.Future<List<_i17.InAppNotificationSummary>> listNotifications({
    required int limit,
  }) => caller.callServerEndpoint<List<_i17.InAppNotificationSummary>>(
    'admin',
    'listNotifications',
    {'limit': limit},
  );

  _i3.Future<void> markNotificationRead(int notificationId) =>
      caller.callServerEndpoint<void>(
        'admin',
        'markNotificationRead',
        {'notificationId': notificationId},
      );

  _i3.Future<void> markAllNotificationsRead() =>
      caller.callServerEndpoint<void>(
        'admin',
        'markAllNotificationsRead',
        {},
      );

  _i3.Future<_i18.Vendor> approveVendor(_i2.UuidValue vendorUserId) =>
      caller.callServerEndpoint<_i18.Vendor>(
        'admin',
        'approveVendor',
        {'vendorUserId': vendorUserId},
      );

  _i3.Future<_i5.User> rejectVendor(_i2.UuidValue vendorUserId) =>
      caller.callServerEndpoint<_i5.User>(
        'admin',
        'rejectVendor',
        {'vendorUserId': vendorUserId},
      );

  _i3.Future<_i19.VendorModerationResult> suspendVendor(
    _i2.UuidValue vendorUserId,
    String reason,
  ) => caller.callServerEndpoint<_i19.VendorModerationResult>(
    'admin',
    'suspendVendor',
    {
      'vendorUserId': vendorUserId,
      'reason': reason,
    },
  );

  _i3.Future<String> getVendorReinstateTerms() =>
      caller.callServerEndpoint<String>(
        'admin',
        'getVendorReinstateTerms',
        {},
      );

  _i3.Future<_i19.VendorModerationResult> reactivateVendor(
    _i2.UuidValue vendorUserId, {
    required bool termsAccepted,
    String? termsNote,
  }) => caller.callServerEndpoint<_i19.VendorModerationResult>(
    'admin',
    'reactivateVendor',
    {
      'vendorUserId': vendorUserId,
      'termsAccepted': termsAccepted,
      'termsNote': termsNote,
    },
  );

  _i3.Future<_i5.User> suspendUser(_i2.UuidValue targetUserId) =>
      caller.callServerEndpoint<_i5.User>(
        'admin',
        'suspendUser',
        {'targetUserId': targetUserId},
      );

  _i3.Future<_i5.User> activateUser(_i2.UuidValue targetUserId) =>
      caller.callServerEndpoint<_i5.User>(
        'admin',
        'activateUser',
        {'targetUserId': targetUserId},
      );

  _i3.Future<_i5.User> updateUserStatus(
    _i2.UuidValue targetUserId,
    _i20.UserAccountStatus status, {
    bool? isActive,
  }) => caller.callServerEndpoint<_i5.User>(
    'admin',
    'updateUserStatus',
    {
      'targetUserId': targetUserId,
      'status': status,
      'isActive': isActive,
    },
  );

  _i3.Future<_i5.User> deactivateUser(_i2.UuidValue targetUserId) =>
      caller.callServerEndpoint<_i5.User>(
        'admin',
        'deactivateUser',
        {'targetUserId': targetUserId},
      );

  _i3.Future<_i21.Product> removeProduct(
    int productId,
    String reason,
  ) => caller.callServerEndpoint<_i21.Product>(
    'admin',
    'removeProduct',
    {
      'productId': productId,
      'reason': reason,
    },
  );

  _i3.Future<_i21.Product> deleteProduct(int productId) =>
      caller.callServerEndpoint<_i21.Product>(
        'admin',
        'deleteProduct',
        {'productId': productId},
      );

  _i3.Future<_i21.Product> restoreProduct(int productId) =>
      caller.callServerEndpoint<_i21.Product>(
        'admin',
        'restoreProduct',
        {'productId': productId},
      );

  _i3.Future<_i21.Product> flagProduct(int productId) =>
      caller.callServerEndpoint<_i21.Product>(
        'admin',
        'flagProduct',
        {'productId': productId},
      );

  _i3.Future<_i21.Product> setProductFeatured(
    int productId, {
    required bool featured,
  }) => caller.callServerEndpoint<_i21.Product>(
    'admin',
    'setProductFeatured',
    {
      'productId': productId,
      'featured': featured,
    },
  );

  _i3.Future<_i22.Complaint> fileComplaint(
    int productId,
    String reason,
    String description,
  ) => caller.callServerEndpoint<_i22.Complaint>(
    'admin',
    'fileComplaint',
    {
      'productId': productId,
      'reason': reason,
      'description': description,
    },
  );

  _i3.Future<List<_i22.Complaint>> listComplaints({
    _i23.ComplaintStatus? status,
    _i24.PaginationInput? pagination,
  }) => caller.callServerEndpoint<List<_i22.Complaint>>(
    'admin',
    'listComplaints',
    {
      'status': status,
      'pagination': pagination,
    },
  );

  _i3.Future<_i22.Complaint> assignComplaint(
    _i2.UuidValue complaintId, {
    String? internalNote,
  }) => caller.callServerEndpoint<_i22.Complaint>(
    'admin',
    'assignComplaint',
    {
      'complaintId': complaintId,
      'internalNote': internalNote,
    },
  );

  _i3.Future<_i22.Complaint> resolveComplaint(_i2.UuidValue complaintId) =>
      caller.callServerEndpoint<_i22.Complaint>(
        'admin',
        'resolveComplaint',
        {'complaintId': complaintId},
      );

  _i3.Future<_i22.Complaint> reopenComplaint(
    _i2.UuidValue complaintId, {
    String? internalNote,
  }) => caller.callServerEndpoint<_i22.Complaint>(
    'admin',
    'reopenComplaint',
    {
      'complaintId': complaintId,
      'internalNote': internalNote,
    },
  );

  _i3.Future<_i25.AdminPlatformStats> getPlatformStats() =>
      caller.callServerEndpoint<_i25.AdminPlatformStats>(
        'admin',
        'getPlatformStats',
        {},
      );

  _i3.Future<List<_i26.PlatformUserSummary>> listUsers({
    String? query,
    _i6.UserRole? role,
    _i24.PaginationInput? pagination,
  }) => caller.callServerEndpoint<List<_i26.PlatformUserSummary>>(
    'admin',
    'listUsers',
    {
      'query': query,
      'role': role,
      'pagination': pagination,
    },
  );

  _i3.Future<_i27.PlatformUserDetail?> getUserDetail(_i2.UuidValue userId) =>
      caller.callServerEndpoint<_i27.PlatformUserDetail?>(
        'admin',
        'getUserDetail',
        {'userId': userId},
      );

  _i3.Future<List<_i28.VendorApplicationSummary>> listVendorApplications({
    _i20.UserAccountStatus? status,
    _i24.PaginationInput? pagination,
  }) => caller.callServerEndpoint<List<_i28.VendorApplicationSummary>>(
    'admin',
    'listVendorApplications',
    {
      'status': status,
      'pagination': pagination,
    },
  );

  _i3.Future<_i29.VendorApplicationDetail?> getVendorApplication(
    _i2.UuidValue vendorId,
  ) => caller.callServerEndpoint<_i29.VendorApplicationDetail?>(
    'admin',
    'getVendorApplication',
    {'vendorId': vendorId},
  );

  _i3.Future<List<_i30.AdminAuditLogSummary>> getAuditLog({
    required int limit,
    _i24.PaginationInput? pagination,
  }) => caller.callServerEndpoint<List<_i30.AdminAuditLogSummary>>(
    'admin',
    'getAuditLog',
    {
      'limit': limit,
      'pagination': pagination,
    },
  );

  _i3.Future<List<_i31.AdminVendorPayoutSummary>> listVendorPayouts({
    _i32.VendorPayoutStatus? status,
    _i24.PaginationInput? pagination,
  }) => caller.callServerEndpoint<List<_i31.AdminVendorPayoutSummary>>(
    'admin',
    'listVendorPayouts',
    {
      'status': status,
      'pagination': pagination,
    },
  );

  _i3.Future<_i31.AdminVendorPayoutSummary> approveVendorPayout(int payoutId) =>
      caller.callServerEndpoint<_i31.AdminVendorPayoutSummary>(
        'admin',
        'approveVendorPayout',
        {'payoutId': payoutId},
      );

  _i3.Future<_i31.AdminVendorPayoutSummary> failVendorPayout(
    int payoutId, {
    String? reason,
  }) => caller.callServerEndpoint<_i31.AdminVendorPayoutSummary>(
    'admin',
    'failVendorPayout',
    {
      'payoutId': payoutId,
      'reason': reason,
    },
  );

  _i3.Future<List<_i33.AdminRefundRequestSummary>> listRefundRequests({
    _i34.RequestStatus? status,
    _i24.PaginationInput? pagination,
  }) => caller.callServerEndpoint<List<_i33.AdminRefundRequestSummary>>(
    'admin',
    'listRefundRequests',
    {
      'status': status,
      'pagination': pagination,
    },
  );

  _i3.Future<_i33.AdminRefundRequestSummary> approveRefundRequest(
    int refundId,
  ) => caller.callServerEndpoint<_i33.AdminRefundRequestSummary>(
    'admin',
    'approveRefundRequest',
    {'refundId': refundId},
  );

  _i3.Future<_i33.AdminRefundRequestSummary> rejectRefundRequest(
    int refundId,
  ) => caller.callServerEndpoint<_i33.AdminRefundRequestSummary>(
    'admin',
    'rejectRefundRequest',
    {'refundId': refundId},
  );

  _i3.Future<List<_i35.AdminProductSummary>> listProducts(
    _i36.AdminProductListInput input,
  ) => caller.callServerEndpoint<List<_i35.AdminProductSummary>>(
    'admin',
    'listProducts',
    {'input': input},
  );

  _i3.Future<List<_i35.AdminProductSummary>> listReportedProducts({
    _i36.AdminProductListInput? input,
  }) => caller.callServerEndpoint<List<_i35.AdminProductSummary>>(
    'admin',
    'listReportedProducts',
    {'input': input},
  );

  _i3.Future<_i37.AdminProductDetail?> getProductDetails(int productId) =>
      caller.callServerEndpoint<_i37.AdminProductDetail?>(
        'admin',
        'getProductDetails',
        {'productId': productId},
      );

  @override
  _i3.Future<_i5.User> requirePlaceifyUser() =>
      caller.callServerEndpoint<_i5.User>(
        'admin',
        'requirePlaceifyUser',
        {},
      );

  @override
  _i3.Future<_i5.User> requireRole(Set<_i6.UserRole> allowedRoles) =>
      caller.callServerEndpoint<_i5.User>(
        'admin',
        'requireRole',
        {'allowedRoles': allowedRoles},
      );
}

/// AR product viewing session tracking.
/// {@category Endpoint}
class EndpointAr extends _i2.EndpointRef {
  EndpointAr(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ar';

  _i3.Future<_i38.ARSession> recordSession(
    int productId, {
    String? deviceInfo,
    String? snapshotUrl,
  }) => caller.callServerEndpoint<_i38.ARSession>(
    'ar',
    'recordSession',
    {
      'productId': productId,
      'deviceInfo': deviceInfo,
      'snapshotUrl': snapshotUrl,
    },
  );

  _i3.Future<List<_i38.ARSession>> listMySessions({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i38.ARSession>>(
    'ar',
    'listMySessions',
    {
      'limit': limit,
      'offset': offset,
    },
  );
}

/// Authenticated shopping cart operations.
/// {@category Endpoint}
class EndpointCart extends _i2.EndpointRef {
  EndpointCart(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cart';

  _i3.Future<List<_i39.CartItem>> getCartItems() =>
      caller.callServerEndpoint<List<_i39.CartItem>>(
        'cart',
        'getCartItems',
        {},
      );

  _i3.Future<_i39.CartItem> addToCart(
    int productId, {
    required int quantity,
  }) => caller.callServerEndpoint<_i39.CartItem>(
    'cart',
    'addToCart',
    {
      'productId': productId,
      'quantity': quantity,
    },
  );

  _i3.Future<_i39.CartItem> updateCartItemQuantity(
    int productId,
    int quantity,
  ) => caller.callServerEndpoint<_i39.CartItem>(
    'cart',
    'updateCartItemQuantity',
    {
      'productId': productId,
      'quantity': quantity,
    },
  );

  _i3.Future<void> removeFromCart(int productId) =>
      caller.callServerEndpoint<void>(
        'cart',
        'removeFromCart',
        {'productId': productId},
      );

  _i3.Future<void> clearCart() => caller.callServerEndpoint<void>(
    'cart',
    'clearCart',
    {},
  );
}

/// Converts a cart into a persisted order.
/// {@category Endpoint}
class EndpointCheckout extends _i2.EndpointRef {
  EndpointCheckout(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'checkout';

  _i3.Future<_i40.CheckoutResult> checkout(_i41.CheckoutRequest request) =>
      caller.callServerEndpoint<_i40.CheckoutResult>(
        'checkout',
        'checkout',
        {'request': request},
      );
}

/// Notification preference management for profile settings.
/// {@category Endpoint}
class EndpointNotification extends _i2.EndpointRef {
  EndpointNotification(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  _i3.Future<_i42.NotificationPreference> getPreferences() =>
      caller.callServerEndpoint<_i42.NotificationPreference>(
        'notification',
        'getPreferences',
        {},
      );

  _i3.Future<_i42.NotificationPreference> updatePreferences({
    bool? orderUpdates,
    bool? refundStatus,
    bool? arReminders,
    bool? priceDropAlerts,
    bool? vendorMessages,
    bool? promotions,
  }) => caller.callServerEndpoint<_i42.NotificationPreference>(
    'notification',
    'updatePreferences',
    {
      'orderUpdates': orderUpdates,
      'refundStatus': refundStatus,
      'arReminders': arReminders,
      'priceDropAlerts': priceDropAlerts,
      'vendorMessages': vendorMessages,
      'promotions': promotions,
    },
  );

  _i3.Future<List<_i17.InAppNotificationSummary>> listInAppNotifications({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i17.InAppNotificationSummary>>(
    'notification',
    'listInAppNotifications',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  _i3.Future<int> unreadInAppNotificationCount() =>
      caller.callServerEndpoint<int>(
        'notification',
        'unreadInAppNotificationCount',
        {},
      );

  _i3.Future<void> markInAppNotificationRead(int notificationId) =>
      caller.callServerEndpoint<void>(
        'notification',
        'markInAppNotificationRead',
        {'notificationId': notificationId},
      );

  _i3.Future<void> markAllInAppNotificationsRead() =>
      caller.callServerEndpoint<void>(
        'notification',
        'markAllInAppNotificationsRead',
        {},
      );

  _i3.Stream<_i17.InAppNotificationSummary> watchInAppNotifications() =>
      caller.callStreamingServerEndpoint<
        _i3.Stream<_i17.InAppNotificationSummary>,
        _i17.InAppNotificationSummary
      >(
        'notification',
        'watchInAppNotifications',
        {},
        {},
      );
}

/// Legacy order history endpoint.
///
/// **Deprecated for consumer apps.** Use [UserEndpoint.listMyOrders],
/// [UserEndpoint.getMyOrder], and delivery data on [UserOrderDetail] instead.
/// See `docs/CONSUMER_API_CONTRACT.md`.
/// {@category Endpoint}
class EndpointOrder extends _i2.EndpointRef {
  EndpointOrder(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'order';

  _i3.Future<_i43.OrderPage> listMyOrders({
    _i24.PaginationInput? pagination,
    _i10.OrderStatus? status,
  }) => caller.callServerEndpoint<_i43.OrderPage>(
    'order',
    'listMyOrders',
    {
      'pagination': pagination,
      'status': status,
    },
  );

  _i3.Future<_i44.Order?> getOrder(int orderId) =>
      caller.callServerEndpoint<_i44.Order?>(
        'order',
        'getOrder',
        {'orderId': orderId},
      );

  _i3.Future<List<_i45.OrderDeliveryUpdate>> listDeliveryUpdates(int orderId) =>
      caller.callServerEndpoint<List<_i45.OrderDeliveryUpdate>>(
        'order',
        'listDeliveryUpdates',
        {'orderId': orderId},
      );
}

/// Vendor payment and payout APIs.
/// {@category Endpoint}
class EndpointPayment extends _i2.EndpointRef {
  EndpointPayment(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'payment';

  _i3.Future<_i46.VendorPaymentsOverview> getOverview() =>
      caller.callServerEndpoint<_i46.VendorPaymentsOverview>(
        'payment',
        'getOverview',
        {},
      );

  _i3.Future<List<_i47.PaymentUpdateSummary>> listPaymentUpdates(int orderId) =>
      caller.callServerEndpoint<List<_i47.PaymentUpdateSummary>>(
        'payment',
        'listPaymentUpdates',
        {'orderId': orderId},
      );

  _i3.Future<_i47.PaymentUpdateSummary> updateOrderPaymentStatus(
    int orderId,
    _i48.PaymentTransactionStatus status, {
    required String note,
  }) => caller.callServerEndpoint<_i47.PaymentUpdateSummary>(
    'payment',
    'updateOrderPaymentStatus',
    {
      'orderId': orderId,
      'status': status,
      'note': note,
    },
  );

  _i3.Future<_i49.VendorPayoutSummary> requestPayout() =>
      caller.callServerEndpoint<_i49.VendorPayoutSummary>(
        'payment',
        'requestPayout',
        {},
      );
}

/// Product browsing, search, and filtering.
/// {@category Endpoint}
class EndpointProduct extends _i2.EndpointRef {
  EndpointProduct(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  _i3.Future<List<_i50.Category>> listCategories() =>
      caller.callServerEndpoint<List<_i50.Category>>(
        'product',
        'listCategories',
        {},
      );

  _i3.Future<_i51.ProductPage> searchProducts(_i52.ProductSearchInput input) =>
      caller.callServerEndpoint<_i51.ProductPage>(
        'product',
        'searchProducts',
        {'input': input},
      );

  _i3.Future<_i21.Product?> getProduct(int productId) =>
      caller.callServerEndpoint<_i21.Product?>(
        'product',
        'getProduct',
        {'productId': productId},
      );

  _i3.Future<_i53.VendorProfileDetail?> getShopProfile(
    _i2.UuidValue vendorId,
  ) => caller.callServerEndpoint<_i53.VendorProfileDetail?>(
    'product',
    'getShopProfile',
    {'vendorId': vendorId},
  );

  _i3.Future<List<_i54.ShopListingSummary>> listApprovedShops({
    String? query,
  }) => caller.callServerEndpoint<List<_i54.ShopListingSummary>>(
    'product',
    'listApprovedShops',
    {'query': query},
  );

  _i3.Future<_i55.MarketplaceHighlights> getMarketplaceHighlights() =>
      caller.callServerEndpoint<_i55.MarketplaceHighlights>(
        'product',
        'getMarketplaceHighlights',
        {},
      );

  /// Backward-compatible list without pagination wrapper.
  _i3.Future<List<_i21.Product>> listProducts({
    String? categoryName,
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<List<_i21.Product>>(
    'product',
    'listProducts',
    {
      'categoryName': categoryName,
      'limit': limit,
      'offset': offset,
    },
  );

  _i3.Future<_i7.ByteData?> getModel3dAsset(int productId) =>
      caller.callServerEndpoint<_i7.ByteData?>(
        'product',
        'getModel3dAsset',
        {'productId': productId},
      );
}

/// Refund and return requests for authenticated customers.
/// {@category Endpoint}
class EndpointRefund extends _i2.EndpointRef {
  EndpointRefund(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'refund';

  _i3.Future<List<_i56.RefundRequestSummary>> listMyRefundRequests({
    _i24.PaginationInput? pagination,
  }) => caller.callServerEndpoint<List<_i56.RefundRequestSummary>>(
    'refund',
    'listMyRefundRequests',
    {'pagination': pagination},
  );

  _i3.Future<_i56.RefundRequestSummary> getRefundRequest(int refundId) =>
      caller.callServerEndpoint<_i56.RefundRequestSummary>(
        'refund',
        'getRefundRequest',
        {'refundId': refundId},
      );

  _i3.Future<_i56.RefundRequestSummary> createRefundRequest(
    int orderId,
    String reason,
  ) => caller.callServerEndpoint<_i56.RefundRequestSummary>(
    'refund',
    'createRefundRequest',
    {
      'orderId': orderId,
      'reason': reason,
    },
  );
}

/// Product reviews from verified purchasers.
///
/// Listing is public so product pages can show real reviews without login.
/// Submission still requires an authenticated session (enforced in the store).
/// {@category Endpoint}
class EndpointReview extends _i2.EndpointRef {
  EndpointReview(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'review';

  _i3.Future<_i57.Review> submitReview(
    int productId,
    int orderId,
    int rating, {
    String? comment,
  }) => caller.callServerEndpoint<_i57.Review>(
    'review',
    'submitReview',
    {
      'productId': productId,
      'orderId': orderId,
      'rating': rating,
      'comment': comment,
    },
  );

  _i3.Future<_i57.Review?> getMyReviewForOrderItem(
    int productId,
    int orderId,
  ) => caller.callServerEndpoint<_i57.Review?>(
    'review',
    'getMyReviewForOrderItem',
    {
      'productId': productId,
      'orderId': orderId,
    },
  );

  _i3.Future<_i57.Review> updateReview(
    int reviewId,
    int rating, {
    String? comment,
  }) => caller.callServerEndpoint<_i57.Review>(
    'review',
    'updateReview',
    {
      'reviewId': reviewId,
      'rating': rating,
      'comment': comment,
    },
  );

  _i3.Future<void> deleteReview(int reviewId) =>
      caller.callServerEndpoint<void>(
        'review',
        'deleteReview',
        {'reviewId': reviewId},
      );

  _i3.Future<List<_i57.Review>> listProductReviews(
    int productId, {
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i57.Review>>(
    'review',
    'listProductReviews',
    {
      'productId': productId,
      'limit': limit,
      'offset': offset,
    },
  );
}

/// Vendor shop and product management.
/// {@category Endpoint}
class EndpointVendor extends _i2.EndpointRef {
  EndpointVendor(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'vendor';

  _i3.Future<_i18.Vendor> getMyShop() => caller.callServerEndpoint<_i18.Vendor>(
    'vendor',
    'getMyShop',
    {},
  );

  _i3.Future<_i58.VendorDashboard> getDashboard() =>
      caller.callServerEndpoint<_i58.VendorDashboard>(
        'vendor',
        'getDashboard',
        {},
      );

  _i3.Future<bool> hasShop() => caller.callServerEndpoint<bool>(
    'vendor',
    'hasShop',
    {},
  );

  _i3.Future<_i18.Vendor> createShop(
    String shopName, {
    String? description,
    String? logoUrl,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? shopCategory,
    String? contactEmail,
    _i59.VendorBankDetailsInput? bankDetails,
  }) => caller.callServerEndpoint<_i18.Vendor>(
    'vendor',
    'createShop',
    {
      'shopName': shopName,
      'description': description,
      'logoUrl': logoUrl,
      'phone': phone,
      'address': address,
      'city': city,
      'country': country,
      'shopCategory': shopCategory,
      'contactEmail': contactEmail,
      'bankDetails': bankDetails,
    },
  );

  _i3.Future<_i60.VendorBankDetails?> getMyBankDetails() =>
      caller.callServerEndpoint<_i60.VendorBankDetails?>(
        'vendor',
        'getMyBankDetails',
        {},
      );

  _i3.Future<_i60.VendorBankDetails> saveMyBankDetails(
    _i59.VendorBankDetailsInput input,
  ) => caller.callServerEndpoint<_i60.VendorBankDetails>(
    'vendor',
    'saveMyBankDetails',
    {'input': input},
  );

  _i3.Future<_i53.VendorProfileDetail> getMyProfile() =>
      caller.callServerEndpoint<_i53.VendorProfileDetail>(
        'vendor',
        'getMyProfile',
        {},
      );

  _i3.Future<_i53.VendorProfileDetail> submitSuspensionAppeal(String message) =>
      caller.callServerEndpoint<_i53.VendorProfileDetail>(
        'vendor',
        'submitSuspensionAppeal',
        {'message': message},
      );

  _i3.Future<_i53.VendorProfileDetail> updateMyProfile(
    _i61.VendorProfileUpdateInput input,
  ) => caller.callServerEndpoint<_i53.VendorProfileDetail>(
    'vendor',
    'updateMyProfile',
    {'input': input},
  );

  _i3.Future<String> uploadShopLogo(
    _i7.ByteData fileData,
    String fileName,
  ) => caller.callServerEndpoint<String>(
    'vendor',
    'uploadShopLogo',
    {
      'fileData': fileData,
      'fileName': fileName,
    },
  );

  _i3.Future<String> uploadShopBanner(
    _i7.ByteData fileData,
    String fileName,
  ) => caller.callServerEndpoint<String>(
    'vendor',
    'uploadShopBanner',
    {
      'fileData': fileData,
      'fileName': fileName,
    },
  );

  _i3.Future<String> uploadShopCover(
    _i7.ByteData fileData,
    String fileName,
  ) => caller.callServerEndpoint<String>(
    'vendor',
    'uploadShopCover',
    {
      'fileData': fileData,
      'fileName': fileName,
    },
  );

  _i3.Future<String> uploadDocument(
    _i62.VendorDocumentType documentType,
    _i7.ByteData fileData,
    String fileName,
  ) => caller.callServerEndpoint<String>(
    'vendor',
    'uploadDocument',
    {
      'documentType': documentType,
      'fileData': fileData,
      'fileName': fileName,
    },
  );

  /// Alias for [uploadShopLogo].
  _i3.Future<String> uploadLogo(
    _i7.ByteData fileData,
    String fileName,
  ) => caller.callServerEndpoint<String>(
    'vendor',
    'uploadLogo',
    {
      'fileData': fileData,
      'fileName': fileName,
    },
  );

  /// Alias for [uploadShopBanner].
  _i3.Future<String> uploadBanner(
    _i7.ByteData fileData,
    String fileName,
  ) => caller.callServerEndpoint<String>(
    'vendor',
    'uploadBanner',
    {
      'fileData': fileData,
      'fileName': fileName,
    },
  );

  _i3.Future<_i18.Vendor> updateShop(
    String shopName, {
    String? description,
    String? logoUrl,
  }) => caller.callServerEndpoint<_i18.Vendor>(
    'vendor',
    'updateShop',
    {
      'shopName': shopName,
      'description': description,
      'logoUrl': logoUrl,
    },
  );

  _i3.Future<List<_i21.Product>> listMyProducts() =>
      caller.callServerEndpoint<List<_i21.Product>>(
        'vendor',
        'listMyProducts',
        {},
      );

  _i3.Future<_i21.Product> createProduct(
    String name,
    String description,
    double price, {
    int? categoryId,
    String? materials,
    double? widthCm,
    double? depthCm,
    double? heightCm,
    double? weightKg,
    String? assemblyNote,
    String? careInstructions,
    String? warranty,
    String? model3dUrl,
    String? thumbnailUrl,
    List<String>? viewImageUrls,
  }) => caller.callServerEndpoint<_i21.Product>(
    'vendor',
    'createProduct',
    {
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'materials': materials,
      'widthCm': widthCm,
      'depthCm': depthCm,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'assemblyNote': assemblyNote,
      'careInstructions': careInstructions,
      'warranty': warranty,
      'model3dUrl': model3dUrl,
      'thumbnailUrl': thumbnailUrl,
      'viewImageUrls': viewImageUrls,
    },
  );

  /// Creates a vendor product and stores the uploaded photo in one call.
  _i3.Future<_i21.Product> uploadProduct(
    _i63.VendorProductUploadInput input,
    _i7.ByteData imageData,
    String imageFileName,
  ) => caller.callServerEndpoint<_i21.Product>(
    'vendor',
    'uploadProduct',
    {
      'input': input,
      'imageData': imageData,
      'imageFileName': imageFileName,
    },
  );

  _i3.Future<_i21.Product> updateProductThumbnail(
    int productId,
    String thumbnailUrl,
  ) => caller.callServerEndpoint<_i21.Product>(
    'vendor',
    'updateProductThumbnail',
    {
      'productId': productId,
      'thumbnailUrl': thumbnailUrl,
    },
  );

  _i3.Future<String> uploadProductImage(
    _i7.ByteData fileData,
    String fileName, {
    required bool removeBackground,
  }) => caller.callServerEndpoint<String>(
    'vendor',
    'uploadProductImage',
    {
      'fileData': fileData,
      'fileName': fileName,
      'removeBackground': removeBackground,
    },
  );

  _i3.Future<_i21.Product> regenerateProductModel3d(int productId) =>
      caller.callServerEndpoint<_i21.Product>(
        'vendor',
        'regenerateProductModel3d',
        {'productId': productId},
      );

  _i3.Future<_i21.Product> deleteProduct(int productId) =>
      caller.callServerEndpoint<_i21.Product>(
        'vendor',
        'deleteProduct',
        {'productId': productId},
      );

  _i3.Future<_i21.Product> restoreProduct(int productId) =>
      caller.callServerEndpoint<_i21.Product>(
        'vendor',
        'restoreProduct',
        {'productId': productId},
      );

  _i3.Future<_i21.Product> archiveProduct(int productId) =>
      caller.callServerEndpoint<_i21.Product>(
        'vendor',
        'archiveProduct',
        {'productId': productId},
      );

  _i3.Future<List<_i64.VendorShopOrder>> listShopOrders({
    required int limit,
    required int offset,
    _i10.OrderStatus? status,
  }) => caller.callServerEndpoint<List<_i64.VendorShopOrder>>(
    'vendor',
    'listShopOrders',
    {
      'limit': limit,
      'offset': offset,
      'status': status,
    },
  );

  _i3.Future<_i64.VendorShopOrder> getShopOrder(int orderId) =>
      caller.callServerEndpoint<_i64.VendorShopOrder>(
        'vendor',
        'getShopOrder',
        {'orderId': orderId},
      );

  _i3.Future<_i64.VendorShopOrder> acceptShopOrder(int orderId) =>
      caller.callServerEndpoint<_i64.VendorShopOrder>(
        'vendor',
        'acceptShopOrder',
        {'orderId': orderId},
      );

  _i3.Future<_i64.VendorShopOrder> rejectShopOrder(
    int orderId,
    String reason,
  ) => caller.callServerEndpoint<_i64.VendorShopOrder>(
    'vendor',
    'rejectShopOrder',
    {
      'orderId': orderId,
      'reason': reason,
    },
  );

  _i3.Future<List<_i45.OrderDeliveryUpdate>> listDeliveryUpdates(int orderId) =>
      caller.callServerEndpoint<List<_i45.OrderDeliveryUpdate>>(
        'vendor',
        'listDeliveryUpdates',
        {'orderId': orderId},
      );

  _i3.Future<_i45.OrderDeliveryUpdate> submitDeliveryUpdate(
    int orderId,
    _i65.DeliveryStage stage, {
    String? note,
    String? photoUrl,
  }) => caller.callServerEndpoint<_i45.OrderDeliveryUpdate>(
    'vendor',
    'submitDeliveryUpdate',
    {
      'orderId': orderId,
      'stage': stage,
      'note': note,
      'photoUrl': photoUrl,
    },
  );

  _i3.Future<String> uploadDeliveryProof(
    _i7.ByteData fileData,
    String fileName,
  ) => caller.callServerEndpoint<String>(
    'vendor',
    'uploadDeliveryProof',
    {
      'fileData': fileData,
      'fileName': fileName,
    },
  );

  _i3.Future<List<_i66.VendorNotificationSummary>> listNotifications({
    required int limit,
  }) => caller.callServerEndpoint<List<_i66.VendorNotificationSummary>>(
    'vendor',
    'listNotifications',
    {'limit': limit},
  );

  _i3.Future<void> markNotificationRead(int notificationId) =>
      caller.callServerEndpoint<void>(
        'vendor',
        'markNotificationRead',
        {'notificationId': notificationId},
      );

  _i3.Future<void> markAllNotificationsRead() =>
      caller.callServerEndpoint<void>(
        'vendor',
        'markAllNotificationsRead',
        {},
      );

  _i3.Future<List<_i56.RefundRequestSummary>> listPendingRefundRequests() =>
      caller.callServerEndpoint<List<_i56.RefundRequestSummary>>(
        'vendor',
        'listPendingRefundRequests',
        {},
      );

  _i3.Future<_i56.RefundRequestSummary> approveRefundRequest(int refundId) =>
      caller.callServerEndpoint<_i56.RefundRequestSummary>(
        'vendor',
        'approveRefundRequest',
        {'refundId': refundId},
      );

  _i3.Future<_i56.RefundRequestSummary> rejectRefundRequest(
    int refundId, {
    String? reason,
  }) => caller.callServerEndpoint<_i56.RefundRequestSummary>(
    'vendor',
    'rejectRefundRequest',
    {
      'refundId': refundId,
      'reason': reason,
    },
  );

  _i3.Future<List<_i67.VendorReviewSummary>> listShopReviews({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i67.VendorReviewSummary>>(
    'vendor',
    'listShopReviews',
    {
      'limit': limit,
      'offset': offset,
    },
  );
}

/// Wishlist management for authenticated customers.
/// {@category Endpoint}
class EndpointWishlist extends _i2.EndpointRef {
  EndpointWishlist(_i2.EndpointCaller caller) : super(caller);

  @override
  String get name => 'wishlist';

  _i3.Future<_i68.WishlistPage> listMyWishlist({
    _i24.PaginationInput? pagination,
  }) => caller.callServerEndpoint<_i68.WishlistPage>(
    'wishlist',
    'listMyWishlist',
    {'pagination': pagination},
  );

  _i3.Future<_i69.WishlistItem> addToWishlist(int productId) =>
      caller.callServerEndpoint<_i69.WishlistItem>(
        'wishlist',
        'addToWishlist',
        {'productId': productId},
      );

  _i3.Future<void> removeFromWishlist(int productId) =>
      caller.callServerEndpoint<void>(
        'wishlist',
        'removeFromWishlist',
        {'productId': productId},
      );

  _i3.Future<bool> toggleWishlist(int productId) =>
      caller.callServerEndpoint<bool>(
        'wishlist',
        'toggleWishlist',
        {'productId': productId},
      );

  _i3.Future<bool> isWishlisted(int productId) =>
      caller.callServerEndpoint<bool>(
        'wishlist',
        'isWishlisted',
        {'productId': productId},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i4.Caller(client);
    auth_idp = _i1.Caller(client);
  }

  late final _i4.Caller auth;

  late final _i1.Caller auth_idp;
}

class Client extends _i2.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    @Deprecated(
      'Use authKeyProvider instead. This will be removed in future releases.',
    )
    super.authenticationKeyManager,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _i2.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i2.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i70.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    emailIdp = EndpointEmailIdp(this);
    jwtRefresh = EndpointJwtRefresh(this);
    user = EndpointUser(this);
    greeting = EndpointGreeting(this);
    admin = EndpointAdmin(this);
    ar = EndpointAr(this);
    cart = EndpointCart(this);
    checkout = EndpointCheckout(this);
    notification = EndpointNotification(this);
    order = EndpointOrder(this);
    payment = EndpointPayment(this);
    product = EndpointProduct(this);
    refund = EndpointRefund(this);
    review = EndpointReview(this);
    vendor = EndpointVendor(this);
    wishlist = EndpointWishlist(this);
    modules = Modules(this);
  }

  late final EndpointEmailIdp emailIdp;

  late final EndpointJwtRefresh jwtRefresh;

  late final EndpointUser user;

  late final EndpointGreeting greeting;

  late final EndpointAdmin admin;

  late final EndpointAr ar;

  late final EndpointCart cart;

  late final EndpointCheckout checkout;

  late final EndpointNotification notification;

  late final EndpointOrder order;

  late final EndpointPayment payment;

  late final EndpointProduct product;

  late final EndpointRefund refund;

  late final EndpointReview review;

  late final EndpointVendor vendor;

  late final EndpointWishlist wishlist;

  late final Modules modules;

  @override
  Map<String, _i2.EndpointRef> get endpointRefLookup => {
    'emailIdp': emailIdp,
    'jwtRefresh': jwtRefresh,
    'user': user,
    'greeting': greeting,
    'admin': admin,
    'ar': ar,
    'cart': cart,
    'checkout': checkout,
    'notification': notification,
    'order': order,
    'payment': payment,
    'product': product,
    'refund': refund,
    'review': review,
    'vendor': vendor,
    'wishlist': wishlist,
  };

  @override
  Map<String, _i2.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
    'auth_idp': modules.auth_idp,
  };
}
