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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'dart:async' as _i2;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i3;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i4;
import 'package:placeify_client/src/protocol/user.dart' as _i5;
import 'package:placeify_client/src/protocol/user_role.dart' as _i6;
import 'dart:typed_data' as _i7;
import 'package:placeify_client/src/protocol/user_dashboard.dart' as _i8;
import 'package:placeify_client/src/protocol/user_order_counts.dart' as _i9;
import 'package:placeify_client/src/protocol/user_order_summary.dart' as _i10;
import 'package:placeify_client/src/protocol/order_status.dart' as _i11;
import 'package:placeify_client/src/protocol/user_order_detail.dart' as _i12;
import 'package:placeify_client/src/protocol/user_order_payment_summary.dart'
    as _i13;
import 'package:placeify_client/src/protocol/user_ar_session_summary.dart'
    as _i14;
import 'package:placeify_client/src/protocol/greetings/greeting.dart' as _i15;
import 'package:placeify_client/src/protocol/admin.dart' as _i16;
import 'package:placeify_client/src/protocol/admin_type.dart' as _i17;
import 'package:placeify_client/src/protocol/vendor.dart' as _i18;
import 'package:placeify_client/src/protocol/user_account_status.dart' as _i19;
import 'package:placeify_client/src/protocol/product.dart' as _i20;
import 'package:placeify_client/src/protocol/complaint.dart' as _i21;
import 'package:placeify_client/src/protocol/complaint_status.dart' as _i22;
import 'package:placeify_client/src/protocol/admin_platform_stats.dart' as _i23;
import 'package:placeify_client/src/protocol/platform_user_summary.dart'
    as _i24;
import 'package:placeify_client/src/protocol/vendor_application_summary.dart'
    as _i25;
import 'package:placeify_client/src/protocol/vendor_application_detail.dart'
    as _i26;
import 'package:placeify_client/src/protocol/admin_audit_log_summary.dart'
    as _i27;
import 'package:placeify_client/src/protocol/admin_vendor_payout_summary.dart'
    as _i28;
import 'package:placeify_client/src/protocol/vendor_payout_status.dart' as _i29;
import 'package:placeify_client/src/protocol/admin_refund_request_summary.dart'
    as _i30;
import 'package:placeify_client/src/protocol/request_status.dart' as _i31;
import 'package:placeify_client/src/protocol/ar_session.dart' as _i32;
import 'package:placeify_client/src/protocol/cart_item.dart' as _i33;
import 'package:placeify_client/src/protocol/checkout_result.dart' as _i34;
import 'package:placeify_client/src/protocol/checkout_request.dart' as _i35;
import 'package:placeify_client/src/protocol/notification_preference.dart'
    as _i36;
import 'package:placeify_client/src/protocol/in_app_notification_summary.dart'
    as _i37;
import 'package:placeify_client/src/protocol/order_page.dart' as _i38;
import 'package:placeify_client/src/protocol/pagination_input.dart' as _i39;
import 'package:placeify_client/src/protocol/order.dart' as _i40;
import 'package:placeify_client/src/protocol/order_delivery_update.dart'
    as _i41;
import 'package:placeify_client/src/protocol/vendor_payments_overview.dart'
    as _i42;
import 'package:placeify_client/src/protocol/payment_update_summary.dart'
    as _i43;
import 'package:placeify_client/src/protocol/payment_transaction_status.dart'
    as _i44;
import 'package:placeify_client/src/protocol/vendor_payout_summary.dart'
    as _i45;
import 'package:placeify_client/src/protocol/category.dart' as _i46;
import 'package:placeify_client/src/protocol/product_page.dart' as _i47;
import 'package:placeify_client/src/protocol/product_search_input.dart' as _i48;
import 'package:placeify_client/src/protocol/vendor_profile_detail.dart'
    as _i49;
import 'package:placeify_client/src/protocol/shop_listing_summary.dart' as _i50;
import 'package:placeify_client/src/protocol/special_offer_summary.dart'
    as _i51;
import 'package:placeify_client/src/protocol/refund_request_summary.dart'
    as _i52;
import 'package:placeify_client/src/protocol/review.dart' as _i53;
import 'package:placeify_client/src/protocol/vendor_dashboard.dart' as _i54;
import 'package:placeify_client/src/protocol/vendor_bank_details_input.dart'
    as _i55;
import 'package:placeify_client/src/protocol/vendor_bank_details.dart' as _i56;
import 'package:placeify_client/src/protocol/vendor_profile_update_input.dart'
    as _i57;
import 'package:placeify_client/src/protocol/vendor_document_type.dart' as _i58;
import 'package:placeify_client/src/protocol/vendor_product_upload_input.dart'
    as _i59;
import 'package:placeify_client/src/protocol/vendor_shop_order.dart' as _i60;
import 'package:placeify_client/src/protocol/delivery_stage.dart' as _i61;
import 'package:placeify_client/src/protocol/vendor_notification_summary.dart'
    as _i62;
import 'package:placeify_client/src/protocol/wishlist_page.dart' as _i63;
import 'package:placeify_client/src/protocol/wishlist_item.dart' as _i64;
import 'protocol.dart' as _i65;

/// Development-only auth helpers (no login required).
/// {@category Endpoint}
class EndpointDevAuth extends _i1.EndpointRef {
  EndpointDevAuth(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'devAuth';

  /// Ensures the demo admin account exists with known credentials.
  _i2.Future<bool> provisionDemoAdmin() => caller.callServerEndpoint<bool>(
    'devAuth',
    'provisionDemoAdmin',
    {},
  );
}

/// By extending [EmailIdpBaseEndpoint], the email identity provider endpoints
/// are made available on the server and enable the corresponding sign-in widget
/// on the client.
/// {@category Endpoint}
class EndpointEmailIdp extends _i3.EndpointEmailIdpBase {
  EndpointEmailIdp(_i1.EndpointCaller caller) : super(caller);

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
  _i2.Future<_i4.AuthSuccess> login({
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
  _i2.Future<_i1.UuidValue> startRegistration({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
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
  _i2.Future<String> verifyRegistrationCode({
    required _i1.UuidValue accountRequestId,
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
  _i2.Future<_i4.AuthSuccess> finishRegistration({
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
  _i2.Future<_i1.UuidValue> startPasswordReset({required String email}) =>
      caller.callServerEndpoint<_i1.UuidValue>(
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
  _i2.Future<String> verifyPasswordResetCode({
    required _i1.UuidValue passwordResetRequestId,
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
  _i2.Future<void> finishPasswordReset({
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
  _i2.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// By extending [RefreshJwtTokensEndpoint], the JWT token refresh endpoint
/// is made available on the server and enables automatic token refresh on the client.
/// {@category Endpoint}
class EndpointJwtRefresh extends _i4.EndpointRefreshJwtTokens {
  EndpointJwtRefresh(_i1.EndpointCaller caller) : super(caller);

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
  _i2.Future<_i4.AuthSuccess> refreshAccessToken({
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
abstract class EndpointPlaceifyAuthenticated extends _i1.EndpointRef {
  EndpointPlaceifyAuthenticated(_i1.EndpointCaller caller) : super(caller);

  _i2.Future<_i5.User> requirePlaceifyUser();

  _i2.Future<_i5.User> requireRole(Set<_i6.UserRole> allowedRoles);
}

/// Profile and dashboard APIs for authenticated customers.
/// {@category Endpoint}
class EndpointUser extends EndpointPlaceifyAuthenticated {
  EndpointUser(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'user';

  _i2.Future<_i5.User?> getCurrentUser() =>
      caller.callServerEndpoint<_i5.User?>(
        'user',
        'getCurrentUser',
        {},
      );

  _i2.Future<_i5.User> updateProfile(
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

  _i2.Future<_i5.User> changePassword(
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

  _i2.Future<_i5.User> uploadProfileImage(
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

  _i2.Future<_i5.User> becomeVendor() => caller.callServerEndpoint<_i5.User>(
    'user',
    'becomeVendor',
    {},
  );

  _i2.Future<_i5.User> becomeConsumer() => caller.callServerEndpoint<_i5.User>(
    'user',
    'becomeConsumer',
    {},
  );

  _i2.Future<_i8.UserDashboard> getDashboard() =>
      caller.callServerEndpoint<_i8.UserDashboard>(
        'user',
        'getDashboard',
        {},
      );

  _i2.Future<_i9.UserOrderCounts> getMyOrderCounts() =>
      caller.callServerEndpoint<_i9.UserOrderCounts>(
        'user',
        'getMyOrderCounts',
        {},
      );

  _i2.Future<_i5.User> ensureDemoAdmin() => caller.callServerEndpoint<_i5.User>(
    'user',
    'ensureDemoAdmin',
    {},
  );

  _i2.Future<List<_i10.UserOrderSummary>> listMyOrders({
    required int limit,
    required int offset,
    _i11.OrderStatus? status,
  }) => caller.callServerEndpoint<List<_i10.UserOrderSummary>>(
    'user',
    'listMyOrders',
    {
      'limit': limit,
      'offset': offset,
      'status': status,
    },
  );

  _i2.Future<_i12.UserOrderDetail> getMyOrder(int orderId) =>
      caller.callServerEndpoint<_i12.UserOrderDetail>(
        'user',
        'getMyOrder',
        {'orderId': orderId},
      );

  _i2.Future<_i12.UserOrderDetail> cancelMyOrder(
    int orderId,
    String reason,
  ) => caller.callServerEndpoint<_i12.UserOrderDetail>(
    'user',
    'cancelMyOrder',
    {
      'orderId': orderId,
      'reason': reason,
    },
  );

  _i2.Future<_i13.UserOrderPaymentSummary> getMyOrderPayment(int orderId) =>
      caller.callServerEndpoint<_i13.UserOrderPaymentSummary>(
        'user',
        'getMyOrderPayment',
        {'orderId': orderId},
      );

  _i2.Future<_i13.UserOrderPaymentSummary> completePayment(int orderId) =>
      caller.callServerEndpoint<_i13.UserOrderPaymentSummary>(
        'user',
        'completePayment',
        {'orderId': orderId},
      );

  _i2.Future<List<_i14.UserArSessionSummary>> listMyArSessions({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i14.UserArSessionSummary>>(
    'user',
    'listMyArSessions',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  @override
  _i2.Future<_i5.User> requirePlaceifyUser() =>
      caller.callServerEndpoint<_i5.User>(
        'user',
        'requirePlaceifyUser',
        {},
      );

  @override
  _i2.Future<_i5.User> requireRole(Set<_i6.UserRole> allowedRoles) =>
      caller.callServerEndpoint<_i5.User>(
        'user',
        'requireRole',
        {'allowedRoles': allowedRoles},
      );
}

/// This is an example endpoint that returns a greeting message through
/// its [hello] method.
/// {@category Endpoint}
class EndpointGreeting extends _i1.EndpointRef {
  EndpointGreeting(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'greeting';

  /// Returns a personalized greeting message: "Hello {name}".
  _i2.Future<_i15.Greeting> hello(String name) =>
      caller.callServerEndpoint<_i15.Greeting>(
        'greeting',
        'hello',
        {'name': name},
      );
}

/// Admin profile APIs for platform administrators.
/// {@category Endpoint}
class EndpointAdmin extends EndpointPlaceifyAuthenticated {
  EndpointAdmin(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'admin';

  _i2.Future<bool> hasAdminProfile() => caller.callServerEndpoint<bool>(
    'admin',
    'hasAdminProfile',
    {},
  );

  _i2.Future<_i16.Admin?> getMyAdmin() =>
      caller.callServerEndpoint<_i16.Admin?>(
        'admin',
        'getMyAdmin',
        {},
      );

  _i2.Future<_i16.Admin> getMyProfile() =>
      caller.callServerEndpoint<_i16.Admin>(
        'admin',
        'getMyProfile',
        {},
      );

  _i2.Future<_i16.Admin> updateMyProfile(
    String fullName, {
    String? email,
    String? phoneNumber,
    _i17.AdminType? adminType,
    bool? isActive,
  }) => caller.callServerEndpoint<_i16.Admin>(
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

  /// One-time bootstrap when no admins exist yet (promotes the signed-in user).
  _i2.Future<_i16.Admin> bootstrapFirstAdmin() =>
      caller.callServerEndpoint<_i16.Admin>(
        'admin',
        'bootstrapFirstAdmin',
        {},
      );

  /// Promotes an existing user to admin. Requires an active admin session.
  _i2.Future<_i16.Admin> promoteToAdmin(
    _i1.UuidValue targetUserId, {
    required _i17.AdminType adminType,
  }) => caller.callServerEndpoint<_i16.Admin>(
    'admin',
    'promoteToAdmin',
    {
      'targetUserId': targetUserId,
      'adminType': adminType,
    },
  );

  _i2.Future<_i18.Vendor> approveVendor(_i1.UuidValue vendorUserId) =>
      caller.callServerEndpoint<_i18.Vendor>(
        'admin',
        'approveVendor',
        {'vendorUserId': vendorUserId},
      );

  _i2.Future<_i5.User> rejectVendor(_i1.UuidValue vendorUserId) =>
      caller.callServerEndpoint<_i5.User>(
        'admin',
        'rejectVendor',
        {'vendorUserId': vendorUserId},
      );

  _i2.Future<_i5.User> updateUserStatus(
    _i1.UuidValue targetUserId,
    _i19.UserAccountStatus status, {
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

  _i2.Future<_i5.User> deactivateUser(_i1.UuidValue targetUserId) =>
      caller.callServerEndpoint<_i5.User>(
        'admin',
        'deactivateUser',
        {'targetUserId': targetUserId},
      );

  _i2.Future<_i20.Product> removeProduct(
    int productId,
    String reason,
  ) => caller.callServerEndpoint<_i20.Product>(
    'admin',
    'removeProduct',
    {
      'productId': productId,
      'reason': reason,
    },
  );

  _i2.Future<_i20.Product> flagProduct(int productId) =>
      caller.callServerEndpoint<_i20.Product>(
        'admin',
        'flagProduct',
        {'productId': productId},
      );

  _i2.Future<_i21.Complaint> fileComplaint(
    int productId,
    String reason,
    String description,
  ) => caller.callServerEndpoint<_i21.Complaint>(
    'admin',
    'fileComplaint',
    {
      'productId': productId,
      'reason': reason,
      'description': description,
    },
  );

  _i2.Future<List<_i21.Complaint>> listComplaints({
    _i22.ComplaintStatus? status,
  }) => caller.callServerEndpoint<List<_i21.Complaint>>(
    'admin',
    'listComplaints',
    {'status': status},
  );

  _i2.Future<_i21.Complaint> resolveComplaint(_i1.UuidValue complaintId) =>
      caller.callServerEndpoint<_i21.Complaint>(
        'admin',
        'resolveComplaint',
        {'complaintId': complaintId},
      );

  _i2.Future<_i23.AdminPlatformStats> getPlatformStats() =>
      caller.callServerEndpoint<_i23.AdminPlatformStats>(
        'admin',
        'getPlatformStats',
        {},
      );

  _i2.Future<List<_i24.PlatformUserSummary>> listUsers({
    String? query,
    _i6.UserRole? role,
  }) => caller.callServerEndpoint<List<_i24.PlatformUserSummary>>(
    'admin',
    'listUsers',
    {
      'query': query,
      'role': role,
    },
  );

  _i2.Future<List<_i25.VendorApplicationSummary>> listVendorApplications({
    _i19.UserAccountStatus? status,
  }) => caller.callServerEndpoint<List<_i25.VendorApplicationSummary>>(
    'admin',
    'listVendorApplications',
    {'status': status},
  );

  _i2.Future<_i26.VendorApplicationDetail?> getVendorApplication(
    _i1.UuidValue vendorId,
  ) => caller.callServerEndpoint<_i26.VendorApplicationDetail?>(
    'admin',
    'getVendorApplication',
    {'vendorId': vendorId},
  );

  _i2.Future<List<_i27.AdminAuditLogSummary>> getAuditLog({
    required int limit,
  }) => caller.callServerEndpoint<List<_i27.AdminAuditLogSummary>>(
    'admin',
    'getAuditLog',
    {'limit': limit},
  );

  _i2.Future<List<_i28.AdminVendorPayoutSummary>> listVendorPayouts({
    _i29.VendorPayoutStatus? status,
  }) => caller.callServerEndpoint<List<_i28.AdminVendorPayoutSummary>>(
    'admin',
    'listVendorPayouts',
    {'status': status},
  );

  _i2.Future<_i28.AdminVendorPayoutSummary> approveVendorPayout(int payoutId) =>
      caller.callServerEndpoint<_i28.AdminVendorPayoutSummary>(
        'admin',
        'approveVendorPayout',
        {'payoutId': payoutId},
      );

  _i2.Future<_i28.AdminVendorPayoutSummary> failVendorPayout(
    int payoutId, {
    String? reason,
  }) => caller.callServerEndpoint<_i28.AdminVendorPayoutSummary>(
    'admin',
    'failVendorPayout',
    {
      'payoutId': payoutId,
      'reason': reason,
    },
  );

  _i2.Future<List<_i30.AdminRefundRequestSummary>> listRefundRequests({
    _i31.RequestStatus? status,
  }) => caller.callServerEndpoint<List<_i30.AdminRefundRequestSummary>>(
    'admin',
    'listRefundRequests',
    {'status': status},
  );

  _i2.Future<_i30.AdminRefundRequestSummary> approveRefundRequest(
    int refundId,
  ) => caller.callServerEndpoint<_i30.AdminRefundRequestSummary>(
    'admin',
    'approveRefundRequest',
    {'refundId': refundId},
  );

  _i2.Future<_i30.AdminRefundRequestSummary> rejectRefundRequest(
    int refundId,
  ) => caller.callServerEndpoint<_i30.AdminRefundRequestSummary>(
    'admin',
    'rejectRefundRequest',
    {'refundId': refundId},
  );

  @override
  _i2.Future<_i5.User> requirePlaceifyUser() =>
      caller.callServerEndpoint<_i5.User>(
        'admin',
        'requirePlaceifyUser',
        {},
      );

  @override
  _i2.Future<_i5.User> requireRole(Set<_i6.UserRole> allowedRoles) =>
      caller.callServerEndpoint<_i5.User>(
        'admin',
        'requireRole',
        {'allowedRoles': allowedRoles},
      );
}

/// AR product viewing session tracking.
/// {@category Endpoint}
class EndpointAr extends _i1.EndpointRef {
  EndpointAr(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'ar';

  _i2.Future<_i32.ARSession> recordSession(
    int productId, {
    String? deviceInfo,
    String? snapshotUrl,
  }) => caller.callServerEndpoint<_i32.ARSession>(
    'ar',
    'recordSession',
    {
      'productId': productId,
      'deviceInfo': deviceInfo,
      'snapshotUrl': snapshotUrl,
    },
  );

  _i2.Future<List<_i32.ARSession>> listMySessions({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i32.ARSession>>(
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
class EndpointCart extends _i1.EndpointRef {
  EndpointCart(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'cart';

  _i2.Future<List<_i33.CartItem>> getCartItems() =>
      caller.callServerEndpoint<List<_i33.CartItem>>(
        'cart',
        'getCartItems',
        {},
      );

  _i2.Future<_i33.CartItem> addToCart(
    int productId, {
    required int quantity,
  }) => caller.callServerEndpoint<_i33.CartItem>(
    'cart',
    'addToCart',
    {
      'productId': productId,
      'quantity': quantity,
    },
  );

  _i2.Future<_i33.CartItem> updateCartItemQuantity(
    int productId,
    int quantity,
  ) => caller.callServerEndpoint<_i33.CartItem>(
    'cart',
    'updateCartItemQuantity',
    {
      'productId': productId,
      'quantity': quantity,
    },
  );

  _i2.Future<void> removeFromCart(int productId) =>
      caller.callServerEndpoint<void>(
        'cart',
        'removeFromCart',
        {'productId': productId},
      );

  _i2.Future<void> clearCart() => caller.callServerEndpoint<void>(
    'cart',
    'clearCart',
    {},
  );
}

/// Converts a cart into a persisted order.
/// {@category Endpoint}
class EndpointCheckout extends _i1.EndpointRef {
  EndpointCheckout(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'checkout';

  _i2.Future<_i34.CheckoutResult> checkout(_i35.CheckoutRequest request) =>
      caller.callServerEndpoint<_i34.CheckoutResult>(
        'checkout',
        'checkout',
        {'request': request},
      );
}

/// Notification preference management for profile settings.
/// {@category Endpoint}
class EndpointNotification extends _i1.EndpointRef {
  EndpointNotification(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'notification';

  _i2.Future<_i36.NotificationPreference> getPreferences() =>
      caller.callServerEndpoint<_i36.NotificationPreference>(
        'notification',
        'getPreferences',
        {},
      );

  _i2.Future<_i36.NotificationPreference> updatePreferences({
    bool? orderUpdates,
    bool? refundStatus,
    bool? arReminders,
    bool? priceDropAlerts,
    bool? vendorMessages,
    bool? promotions,
  }) => caller.callServerEndpoint<_i36.NotificationPreference>(
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

  _i2.Future<List<_i37.InAppNotificationSummary>> listInAppNotifications({
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i37.InAppNotificationSummary>>(
    'notification',
    'listInAppNotifications',
    {
      'limit': limit,
      'offset': offset,
    },
  );

  _i2.Future<int> unreadInAppNotificationCount() =>
      caller.callServerEndpoint<int>(
        'notification',
        'unreadInAppNotificationCount',
        {},
      );

  _i2.Future<void> markInAppNotificationRead(int notificationId) =>
      caller.callServerEndpoint<void>(
        'notification',
        'markInAppNotificationRead',
        {'notificationId': notificationId},
      );

  _i2.Future<void> markAllInAppNotificationsRead() =>
      caller.callServerEndpoint<void>(
        'notification',
        'markAllInAppNotificationsRead',
        {},
      );
}

/// Legacy order history endpoint.
///
/// **Deprecated for consumer apps.** Use [UserEndpoint.listMyOrders],
/// [UserEndpoint.getMyOrder], and delivery data on [UserOrderDetail] instead.
/// See `docs/CONSUMER_API_CONTRACT.md`.
/// {@category Endpoint}
class EndpointOrder extends _i1.EndpointRef {
  EndpointOrder(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'order';

  _i2.Future<_i38.OrderPage> listMyOrders({
    _i39.PaginationInput? pagination,
    _i11.OrderStatus? status,
  }) => caller.callServerEndpoint<_i38.OrderPage>(
    'order',
    'listMyOrders',
    {
      'pagination': pagination,
      'status': status,
    },
  );

  _i2.Future<_i40.Order?> getOrder(int orderId) =>
      caller.callServerEndpoint<_i40.Order?>(
        'order',
        'getOrder',
        {'orderId': orderId},
      );

  _i2.Future<List<_i41.OrderDeliveryUpdate>> listDeliveryUpdates(int orderId) =>
      caller.callServerEndpoint<List<_i41.OrderDeliveryUpdate>>(
        'order',
        'listDeliveryUpdates',
        {'orderId': orderId},
      );
}

/// Vendor payment and payout APIs.
/// {@category Endpoint}
class EndpointPayment extends _i1.EndpointRef {
  EndpointPayment(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'payment';

  _i2.Future<_i42.VendorPaymentsOverview> getOverview() =>
      caller.callServerEndpoint<_i42.VendorPaymentsOverview>(
        'payment',
        'getOverview',
        {},
      );

  _i2.Future<List<_i43.PaymentUpdateSummary>> listPaymentUpdates(int orderId) =>
      caller.callServerEndpoint<List<_i43.PaymentUpdateSummary>>(
        'payment',
        'listPaymentUpdates',
        {'orderId': orderId},
      );

  _i2.Future<_i43.PaymentUpdateSummary> updateOrderPaymentStatus(
    int orderId,
    _i44.PaymentTransactionStatus status, {
    required String note,
  }) => caller.callServerEndpoint<_i43.PaymentUpdateSummary>(
    'payment',
    'updateOrderPaymentStatus',
    {
      'orderId': orderId,
      'status': status,
      'note': note,
    },
  );

  _i2.Future<_i45.VendorPayoutSummary> requestPayout() =>
      caller.callServerEndpoint<_i45.VendorPayoutSummary>(
        'payment',
        'requestPayout',
        {},
      );
}

/// Product browsing, search, and filtering.
/// {@category Endpoint}
class EndpointProduct extends _i1.EndpointRef {
  EndpointProduct(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'product';

  _i2.Future<List<_i46.Category>> listCategories() =>
      caller.callServerEndpoint<List<_i46.Category>>(
        'product',
        'listCategories',
        {},
      );

  _i2.Future<_i47.ProductPage> searchProducts(_i48.ProductSearchInput input) =>
      caller.callServerEndpoint<_i47.ProductPage>(
        'product',
        'searchProducts',
        {'input': input},
      );

  _i2.Future<_i20.Product?> getProduct(int productId) =>
      caller.callServerEndpoint<_i20.Product?>(
        'product',
        'getProduct',
        {'productId': productId},
      );

  _i2.Future<_i49.VendorProfileDetail?> getShopProfile(
    _i1.UuidValue vendorId,
  ) => caller.callServerEndpoint<_i49.VendorProfileDetail?>(
    'product',
    'getShopProfile',
    {'vendorId': vendorId},
  );

  _i2.Future<List<_i50.ShopListingSummary>> listApprovedShops({
    String? query,
  }) => caller.callServerEndpoint<List<_i50.ShopListingSummary>>(
    'product',
    'listApprovedShops',
    {'query': query},
  );

  /// Backward-compatible list without pagination wrapper.
  _i2.Future<List<_i20.Product>> listProducts({
    String? categoryName,
    int? limit,
    int? offset,
  }) => caller.callServerEndpoint<List<_i20.Product>>(
    'product',
    'listProducts',
    {
      'categoryName': categoryName,
      'limit': limit,
      'offset': offset,
    },
  );

  _i2.Future<List<_i51.SpecialOfferSummary>> listSpecialOffers({
    required int limit,
  }) => caller.callServerEndpoint<List<_i51.SpecialOfferSummary>>(
    'product',
    'listSpecialOffers',
    {'limit': limit},
  );
}

/// Refund and return requests for authenticated customers.
/// {@category Endpoint}
class EndpointRefund extends _i1.EndpointRef {
  EndpointRefund(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'refund';

  _i2.Future<List<_i52.RefundRequestSummary>> listMyRefundRequests({
    _i39.PaginationInput? pagination,
  }) => caller.callServerEndpoint<List<_i52.RefundRequestSummary>>(
    'refund',
    'listMyRefundRequests',
    {'pagination': pagination},
  );

  _i2.Future<_i52.RefundRequestSummary> getRefundRequest(int refundId) =>
      caller.callServerEndpoint<_i52.RefundRequestSummary>(
        'refund',
        'getRefundRequest',
        {'refundId': refundId},
      );

  _i2.Future<_i52.RefundRequestSummary> createRefundRequest(
    int orderId,
    String reason,
  ) => caller.callServerEndpoint<_i52.RefundRequestSummary>(
    'refund',
    'createRefundRequest',
    {
      'orderId': orderId,
      'reason': reason,
    },
  );
}

/// Product reviews from verified purchasers.
/// {@category Endpoint}
class EndpointReview extends _i1.EndpointRef {
  EndpointReview(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'review';

  _i2.Future<_i53.Review> submitReview(
    int productId,
    int orderId,
    int rating, {
    String? comment,
  }) => caller.callServerEndpoint<_i53.Review>(
    'review',
    'submitReview',
    {
      'productId': productId,
      'orderId': orderId,
      'rating': rating,
      'comment': comment,
    },
  );

  _i2.Future<List<_i53.Review>> listProductReviews(
    int productId, {
    required int limit,
    required int offset,
  }) => caller.callServerEndpoint<List<_i53.Review>>(
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
class EndpointVendor extends _i1.EndpointRef {
  EndpointVendor(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'vendor';

  _i2.Future<_i18.Vendor> getMyShop() => caller.callServerEndpoint<_i18.Vendor>(
    'vendor',
    'getMyShop',
    {},
  );

  _i2.Future<_i54.VendorDashboard> getDashboard() =>
      caller.callServerEndpoint<_i54.VendorDashboard>(
        'vendor',
        'getDashboard',
        {},
      );

  _i2.Future<bool> hasShop() => caller.callServerEndpoint<bool>(
    'vendor',
    'hasShop',
    {},
  );

  _i2.Future<_i18.Vendor> createShop(
    String shopName, {
    String? description,
    String? logoUrl,
    String? phone,
    String? address,
    String? city,
    String? country,
    String? shopCategory,
    String? contactEmail,
    _i55.VendorBankDetailsInput? bankDetails,
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

  _i2.Future<_i56.VendorBankDetails?> getMyBankDetails() =>
      caller.callServerEndpoint<_i56.VendorBankDetails?>(
        'vendor',
        'getMyBankDetails',
        {},
      );

  _i2.Future<_i56.VendorBankDetails> saveMyBankDetails(
    _i55.VendorBankDetailsInput input,
  ) => caller.callServerEndpoint<_i56.VendorBankDetails>(
    'vendor',
    'saveMyBankDetails',
    {'input': input},
  );

  _i2.Future<_i49.VendorProfileDetail> getMyProfile() =>
      caller.callServerEndpoint<_i49.VendorProfileDetail>(
        'vendor',
        'getMyProfile',
        {},
      );

  _i2.Future<_i49.VendorProfileDetail> updateMyProfile(
    _i57.VendorProfileUpdateInput input,
  ) => caller.callServerEndpoint<_i49.VendorProfileDetail>(
    'vendor',
    'updateMyProfile',
    {'input': input},
  );

  _i2.Future<String> uploadShopLogo(
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

  _i2.Future<String> uploadShopBanner(
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

  _i2.Future<String> uploadShopCover(
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

  _i2.Future<String> uploadDocument(
    _i58.VendorDocumentType documentType,
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
  _i2.Future<String> uploadLogo(
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
  _i2.Future<String> uploadBanner(
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

  _i2.Future<_i18.Vendor> updateShop(
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

  _i2.Future<List<_i20.Product>> listMyProducts() =>
      caller.callServerEndpoint<List<_i20.Product>>(
        'vendor',
        'listMyProducts',
        {},
      );

  _i2.Future<_i20.Product> createProduct(
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
  }) => caller.callServerEndpoint<_i20.Product>(
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
  _i2.Future<_i20.Product> uploadProduct(
    _i59.VendorProductUploadInput input,
    _i7.ByteData imageData,
    String imageFileName,
  ) => caller.callServerEndpoint<_i20.Product>(
    'vendor',
    'uploadProduct',
    {
      'input': input,
      'imageData': imageData,
      'imageFileName': imageFileName,
    },
  );

  _i2.Future<_i20.Product> updateProductThumbnail(
    int productId,
    String thumbnailUrl,
  ) => caller.callServerEndpoint<_i20.Product>(
    'vendor',
    'updateProductThumbnail',
    {
      'productId': productId,
      'thumbnailUrl': thumbnailUrl,
    },
  );

  _i2.Future<String> uploadProductImage(
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

  _i2.Future<_i20.Product> regenerateProductModel3d(int productId) =>
      caller.callServerEndpoint<_i20.Product>(
        'vendor',
        'regenerateProductModel3d',
        {'productId': productId},
      );

  _i2.Future<List<_i60.VendorShopOrder>> listShopOrders({
    required int limit,
    required int offset,
    _i11.OrderStatus? status,
  }) => caller.callServerEndpoint<List<_i60.VendorShopOrder>>(
    'vendor',
    'listShopOrders',
    {
      'limit': limit,
      'offset': offset,
      'status': status,
    },
  );

  _i2.Future<_i60.VendorShopOrder> getShopOrder(int orderId) =>
      caller.callServerEndpoint<_i60.VendorShopOrder>(
        'vendor',
        'getShopOrder',
        {'orderId': orderId},
      );

  _i2.Future<_i60.VendorShopOrder> acceptShopOrder(int orderId) =>
      caller.callServerEndpoint<_i60.VendorShopOrder>(
        'vendor',
        'acceptShopOrder',
        {'orderId': orderId},
      );

  _i2.Future<_i60.VendorShopOrder> rejectShopOrder(
    int orderId,
    String reason,
  ) => caller.callServerEndpoint<_i60.VendorShopOrder>(
    'vendor',
    'rejectShopOrder',
    {
      'orderId': orderId,
      'reason': reason,
    },
  );

  _i2.Future<List<_i41.OrderDeliveryUpdate>> listDeliveryUpdates(int orderId) =>
      caller.callServerEndpoint<List<_i41.OrderDeliveryUpdate>>(
        'vendor',
        'listDeliveryUpdates',
        {'orderId': orderId},
      );

  _i2.Future<_i41.OrderDeliveryUpdate> submitDeliveryUpdate(
    int orderId,
    _i61.DeliveryStage stage, {
    String? note,
    String? photoUrl,
  }) => caller.callServerEndpoint<_i41.OrderDeliveryUpdate>(
    'vendor',
    'submitDeliveryUpdate',
    {
      'orderId': orderId,
      'stage': stage,
      'note': note,
      'photoUrl': photoUrl,
    },
  );

  _i2.Future<String> uploadDeliveryProof(
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

  _i2.Future<List<_i62.VendorNotificationSummary>> listNotifications({
    required int limit,
  }) => caller.callServerEndpoint<List<_i62.VendorNotificationSummary>>(
    'vendor',
    'listNotifications',
    {'limit': limit},
  );

  _i2.Future<void> markNotificationRead(int notificationId) =>
      caller.callServerEndpoint<void>(
        'vendor',
        'markNotificationRead',
        {'notificationId': notificationId},
      );

  _i2.Future<void> markAllNotificationsRead() =>
      caller.callServerEndpoint<void>(
        'vendor',
        'markAllNotificationsRead',
        {},
      );
}

/// Wishlist management for authenticated customers.
/// {@category Endpoint}
class EndpointWishlist extends _i1.EndpointRef {
  EndpointWishlist(_i1.EndpointCaller caller) : super(caller);

  @override
  String get name => 'wishlist';

  _i2.Future<_i63.WishlistPage> listMyWishlist({
    _i39.PaginationInput? pagination,
  }) => caller.callServerEndpoint<_i63.WishlistPage>(
    'wishlist',
    'listMyWishlist',
    {'pagination': pagination},
  );

  _i2.Future<_i64.WishlistItem> addToWishlist(int productId) =>
      caller.callServerEndpoint<_i64.WishlistItem>(
        'wishlist',
        'addToWishlist',
        {'productId': productId},
      );

  _i2.Future<void> removeFromWishlist(int productId) =>
      caller.callServerEndpoint<void>(
        'wishlist',
        'removeFromWishlist',
        {'productId': productId},
      );

  _i2.Future<bool> toggleWishlist(int productId) =>
      caller.callServerEndpoint<bool>(
        'wishlist',
        'toggleWishlist',
        {'productId': productId},
      );

  _i2.Future<bool> isWishlisted(int productId) =>
      caller.callServerEndpoint<bool>(
        'wishlist',
        'isWishlisted',
        {'productId': productId},
      );
}

class Modules {
  Modules(Client client) {
    auth = _i4.Caller(client);
    auth_idp = _i3.Caller(client);
  }

  late final _i4.Caller auth;

  late final _i3.Caller auth_idp;
}

class Client extends _i1.ServerpodClientShared {
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
      _i1.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_i1.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
  }) : super(
         host,
         _i65.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection:
             disconnectStreamsOnLostInternetConnection,
       ) {
    devAuth = EndpointDevAuth(this);
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

  late final EndpointDevAuth devAuth;

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
  Map<String, _i1.EndpointRef> get endpointRefLookup => {
    'devAuth': devAuth,
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
  Map<String, _i1.ModuleEndpointCaller> get moduleLookup => {
    'auth': modules.auth,
    'auth_idp': modules.auth_idp,
  };
}
