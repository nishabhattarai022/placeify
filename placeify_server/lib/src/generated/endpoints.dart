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
import 'package:serverpod/serverpod.dart' as _i1;
import '../auth/email_idp_endpoint.dart' as _i2;
import '../auth/jwt_refresh_endpoint.dart' as _i3;
import '../auth/user_endpoint.dart' as _i4;
import '../greetings/greeting_endpoint.dart' as _i5;
import '../modules/admin/admin_endpoint.dart' as _i6;
import '../modules/ar/ar_endpoint.dart' as _i7;
import '../modules/cart/cart_endpoint.dart' as _i8;
import '../modules/checkout/checkout_endpoint.dart' as _i9;
import '../modules/notification/notification_endpoint.dart' as _i10;
import '../modules/order/order_endpoint.dart' as _i11;
import '../modules/payment/payment_endpoint.dart' as _i12;
import '../modules/product/product_endpoint.dart' as _i13;
import '../modules/refund/refund_endpoint.dart' as _i14;
import '../modules/review/review_endpoint.dart' as _i15;
import '../modules/vendor/vendor_endpoint.dart' as _i16;
import '../modules/wishlist/wishlist_endpoint.dart' as _i17;
import 'package:placeify_server/src/generated/order_status.dart' as _i18;
import 'package:placeify_server/src/generated/user_role.dart' as _i19;
import 'package:placeify_server/src/generated/admin_type.dart' as _i20;
import 'package:placeify_server/src/generated/user_account_status.dart' as _i21;
import 'package:placeify_server/src/generated/complaint_status.dart' as _i22;
import 'package:placeify_server/src/generated/vendor_payout_status.dart'
    as _i23;
import 'package:placeify_server/src/generated/request_status.dart' as _i24;
import 'package:placeify_server/src/generated/checkout_request.dart' as _i25;
import 'package:placeify_server/src/generated/pagination_input.dart' as _i26;
import 'package:placeify_server/src/generated/payment_transaction_status.dart'
    as _i27;
import 'package:placeify_server/src/generated/product_search_input.dart'
    as _i28;
import 'package:placeify_server/src/generated/vendor_bank_details_input.dart'
    as _i29;
import 'package:placeify_server/src/generated/vendor_profile_update_input.dart'
    as _i30;
import 'dart:typed_data' as _i31;
import 'package:placeify_server/src/generated/vendor_document_type.dart'
    as _i32;
import 'package:placeify_server/src/generated/vendor_product_upload_input.dart'
    as _i33;
import 'package:placeify_server/src/generated/delivery_stage.dart' as _i34;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i35;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i36;

class Endpoints extends _i1.EndpointDispatch {
  @override
  void initializeEndpoints(_i1.Server server) {
    var endpoints = <String, _i1.Endpoint>{
      'emailIdp': _i2.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'jwtRefresh': _i3.JwtRefreshEndpoint()
        ..initialize(
          server,
          'jwtRefresh',
          null,
        ),
      'user': _i4.UserEndpoint()
        ..initialize(
          server,
          'user',
          null,
        ),
      'greeting': _i5.GreetingEndpoint()
        ..initialize(
          server,
          'greeting',
          null,
        ),
      'admin': _i6.AdminEndpoint()
        ..initialize(
          server,
          'admin',
          null,
        ),
      'ar': _i7.ArEndpoint()
        ..initialize(
          server,
          'ar',
          null,
        ),
      'cart': _i8.CartEndpoint()
        ..initialize(
          server,
          'cart',
          null,
        ),
      'checkout': _i9.CheckoutEndpoint()
        ..initialize(
          server,
          'checkout',
          null,
        ),
      'notification': _i10.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'order': _i11.OrderEndpoint()
        ..initialize(
          server,
          'order',
          null,
        ),
      'payment': _i12.PaymentEndpoint()
        ..initialize(
          server,
          'payment',
          null,
        ),
      'product': _i13.ProductEndpoint()
        ..initialize(
          server,
          'product',
          null,
        ),
      'refund': _i14.RefundEndpoint()
        ..initialize(
          server,
          'refund',
          null,
        ),
      'review': _i15.ReviewEndpoint()
        ..initialize(
          server,
          'review',
          null,
        ),
      'vendor': _i16.VendorEndpoint()
        ..initialize(
          server,
          'vendor',
          null,
        ),
      'wishlist': _i17.WishlistEndpoint()
        ..initialize(
          server,
          'wishlist',
          null,
        ),
    };
    connectors['emailIdp'] = _i1.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _i1.MethodConnector(
          name: 'login',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _i1.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startRegistration(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyRegistrationCode': _i1.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _i1.ParameterDescription(
              name: 'accountRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyRegistrationCode(
                    session,
                    accountRequestId: params['accountRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishRegistration': _i1.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _i1.ParameterDescription(
              name: 'registrationToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'password': _i1.ParameterDescription(
              name: 'password',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishRegistration(
                    session,
                    registrationToken: params['registrationToken'],
                    password: params['password'],
                  ),
        ),
        'startPasswordReset': _i1.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .startPasswordReset(
                    session,
                    email: params['email'],
                  ),
        ),
        'verifyPasswordResetCode': _i1.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _i1.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _i1.ParameterDescription(
              name: 'verificationCode',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .verifyPasswordResetCode(
                    session,
                    passwordResetRequestId: params['passwordResetRequestId'],
                    verificationCode: params['verificationCode'],
                  ),
        ),
        'finishPasswordReset': _i1.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _i1.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'newPassword': _i1.ParameterDescription(
              name: 'newPassword',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .finishPasswordReset(
                    session,
                    finishPasswordResetToken:
                        params['finishPasswordResetToken'],
                    newPassword: params['newPassword'],
                  ),
        ),
        'hasAccount': _i1.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _i2.EmailIdpEndpoint)
                  .hasAccount(session),
        ),
      },
    );
    connectors['jwtRefresh'] = _i1.EndpointConnector(
      name: 'jwtRefresh',
      endpoint: endpoints['jwtRefresh']!,
      methodConnectors: {
        'refreshAccessToken': _i1.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _i1.ParameterDescription(
              name: 'refreshToken',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['jwtRefresh'] as _i3.JwtRefreshEndpoint)
                  .refreshAccessToken(
                    session,
                    refreshToken: params['refreshToken'],
                  ),
        ),
      },
    );
    connectors['user'] = _i1.EndpointConnector(
      name: 'user',
      endpoint: endpoints['user']!,
      methodConnectors: {
        'getCurrentUser': _i1.MethodConnector(
          name: 'getCurrentUser',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i4.UserEndpoint).getCurrentUser(
                session,
              ),
        ),
        'updateProfile': _i1.MethodConnector(
          name: 'updateProfile',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'phone': _i1.ParameterDescription(
              name: 'phone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'address': _i1.ParameterDescription(
              name: 'address',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i4.UserEndpoint).updateProfile(
                session,
                params['name'],
                phone: params['phone'],
                address: params['address'],
              ),
        ),
        'becomeVendor': _i1.MethodConnector(
          name: 'becomeVendor',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i4.UserEndpoint).becomeVendor(session),
        ),
        'becomeConsumer': _i1.MethodConnector(
          name: 'becomeConsumer',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i4.UserEndpoint).becomeConsumer(
                session,
              ),
        ),
        'getDashboard': _i1.MethodConnector(
          name: 'getDashboard',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i4.UserEndpoint).getDashboard(session),
        ),
        'ensureDemoAdmin': _i1.MethodConnector(
          name: 'ensureDemoAdmin',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i4.UserEndpoint)
                  .ensureDemoAdmin(session),
        ),
        'listMyOrders': _i1.MethodConnector(
          name: 'listMyOrders',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i18.OrderStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i4.UserEndpoint).listMyOrders(
                session,
                limit: params['limit'],
                offset: params['offset'],
                status: params['status'],
              ),
        ),
        'getMyOrder': _i1.MethodConnector(
          name: 'getMyOrder',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i4.UserEndpoint).getMyOrder(
                session,
                params['orderId'],
              ),
        ),
        'cancelMyOrder': _i1.MethodConnector(
          name: 'cancelMyOrder',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i4.UserEndpoint).cancelMyOrder(
                session,
                params['orderId'],
                params['reason'],
              ),
        ),
        'getMyOrderPayment': _i1.MethodConnector(
          name: 'getMyOrderPayment',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i4.UserEndpoint).getMyOrderPayment(
                    session,
                    params['orderId'],
                  ),
        ),
        'completePayment': _i1.MethodConnector(
          name: 'completePayment',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i4.UserEndpoint).completePayment(
                    session,
                    params['orderId'],
                  ),
        ),
        'listMyArSessions': _i1.MethodConnector(
          name: 'listMyArSessions',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['user'] as _i4.UserEndpoint).listMyArSessions(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
        'requirePlaceifyUser': _i1.MethodConnector(
          name: 'requirePlaceifyUser',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i4.UserEndpoint)
                  .requirePlaceifyUser(session),
        ),
        'requireRole': _i1.MethodConnector(
          name: 'requireRole',
          params: {
            'allowedRoles': _i1.ParameterDescription(
              name: 'allowedRoles',
              type: _i1.getType<Set<_i19.UserRole>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['user'] as _i4.UserEndpoint).requireRole(
                session,
                params['allowedRoles'],
              ),
        ),
      },
    );
    connectors['greeting'] = _i1.EndpointConnector(
      name: 'greeting',
      endpoint: endpoints['greeting']!,
      methodConnectors: {
        'hello': _i1.MethodConnector(
          name: 'hello',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['greeting'] as _i5.GreetingEndpoint).hello(
                session,
                params['name'],
              ),
        ),
      },
    );
    connectors['admin'] = _i1.EndpointConnector(
      name: 'admin',
      endpoint: endpoints['admin']!,
      methodConnectors: {
        'hasAdminProfile': _i1.MethodConnector(
          name: 'hasAdminProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint)
                  .hasAdminProfile(session),
        ),
        'getMyAdmin': _i1.MethodConnector(
          name: 'getMyAdmin',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).getMyAdmin(session),
        ),
        'getMyProfile': _i1.MethodConnector(
          name: 'getMyProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint).getMyProfile(
                session,
              ),
        ),
        'updateMyProfile': _i1.MethodConnector(
          name: 'updateMyProfile',
          params: {
            'fullName': _i1.ParameterDescription(
              name: 'fullName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'email': _i1.ParameterDescription(
              name: 'email',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'phoneNumber': _i1.ParameterDescription(
              name: 'phoneNumber',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'adminType': _i1.ParameterDescription(
              name: 'adminType',
              type: _i1.getType<_i20.AdminType?>(),
              nullable: true,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).updateMyProfile(
                    session,
                    params['fullName'],
                    email: params['email'],
                    phoneNumber: params['phoneNumber'],
                    adminType: params['adminType'],
                    isActive: params['isActive'],
                  ),
        ),
        'approveVendor': _i1.MethodConnector(
          name: 'approveVendor',
          params: {
            'vendorUserId': _i1.ParameterDescription(
              name: 'vendorUserId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).approveVendor(
                    session,
                    params['vendorUserId'],
                  ),
        ),
        'rejectVendor': _i1.MethodConnector(
          name: 'rejectVendor',
          params: {
            'vendorUserId': _i1.ParameterDescription(
              name: 'vendorUserId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint).rejectVendor(
                session,
                params['vendorUserId'],
              ),
        ),
        'updateUserStatus': _i1.MethodConnector(
          name: 'updateUserStatus',
          params: {
            'targetUserId': _i1.ParameterDescription(
              name: 'targetUserId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i21.UserAccountStatus>(),
              nullable: false,
            ),
            'isActive': _i1.ParameterDescription(
              name: 'isActive',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).updateUserStatus(
                    session,
                    params['targetUserId'],
                    params['status'],
                    isActive: params['isActive'],
                  ),
        ),
        'deactivateUser': _i1.MethodConnector(
          name: 'deactivateUser',
          params: {
            'targetUserId': _i1.ParameterDescription(
              name: 'targetUserId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).deactivateUser(
                    session,
                    params['targetUserId'],
                  ),
        ),
        'removeProduct': _i1.MethodConnector(
          name: 'removeProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).removeProduct(
                    session,
                    params['productId'],
                    params['reason'],
                  ),
        ),
        'deleteProduct': _i1.MethodConnector(
          name: 'deleteProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).deleteProduct(
                    session,
                    params['productId'],
                  ),
        ),
        'restoreProduct': _i1.MethodConnector(
          name: 'restoreProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).restoreProduct(
                    session,
                    params['productId'],
                  ),
        ),
        'flagProduct': _i1.MethodConnector(
          name: 'flagProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint).flagProduct(
                session,
                params['productId'],
              ),
        ),
        'fileComplaint': _i1.MethodConnector(
          name: 'fileComplaint',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).fileComplaint(
                    session,
                    params['productId'],
                    params['reason'],
                    params['description'],
                  ),
        ),
        'listComplaints': _i1.MethodConnector(
          name: 'listComplaints',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i22.ComplaintStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).listComplaints(
                    session,
                    status: params['status'],
                  ),
        ),
        'resolveComplaint': _i1.MethodConnector(
          name: 'resolveComplaint',
          params: {
            'complaintId': _i1.ParameterDescription(
              name: 'complaintId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).resolveComplaint(
                    session,
                    params['complaintId'],
                  ),
        ),
        'getPlatformStats': _i1.MethodConnector(
          name: 'getPlatformStats',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint)
                  .getPlatformStats(session),
        ),
        'listUsers': _i1.MethodConnector(
          name: 'listUsers',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'role': _i1.ParameterDescription(
              name: 'role',
              type: _i1.getType<_i19.UserRole?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint).listUsers(
                session,
                query: params['query'],
                role: params['role'],
              ),
        ),
        'listVendorApplications': _i1.MethodConnector(
          name: 'listVendorApplications',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i21.UserAccountStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint)
                  .listVendorApplications(
                    session,
                    status: params['status'],
                  ),
        ),
        'getVendorApplication': _i1.MethodConnector(
          name: 'getVendorApplication',
          params: {
            'vendorId': _i1.ParameterDescription(
              name: 'vendorId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint)
                  .getVendorApplication(
                    session,
                    params['vendorId'],
                  ),
        ),
        'getAuditLog': _i1.MethodConnector(
          name: 'getAuditLog',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint).getAuditLog(
                session,
                limit: params['limit'],
              ),
        ),
        'listVendorPayouts': _i1.MethodConnector(
          name: 'listVendorPayouts',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i23.VendorPayoutStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).listVendorPayouts(
                    session,
                    status: params['status'],
                  ),
        ),
        'approveVendorPayout': _i1.MethodConnector(
          name: 'approveVendorPayout',
          params: {
            'payoutId': _i1.ParameterDescription(
              name: 'payoutId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).approveVendorPayout(
                    session,
                    params['payoutId'],
                  ),
        ),
        'failVendorPayout': _i1.MethodConnector(
          name: 'failVendorPayout',
          params: {
            'payoutId': _i1.ParameterDescription(
              name: 'payoutId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).failVendorPayout(
                    session,
                    params['payoutId'],
                    reason: params['reason'],
                  ),
        ),
        'listRefundRequests': _i1.MethodConnector(
          name: 'listRefundRequests',
          params: {
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i24.RequestStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).listRefundRequests(
                    session,
                    status: params['status'],
                  ),
        ),
        'approveRefundRequest': _i1.MethodConnector(
          name: 'approveRefundRequest',
          params: {
            'refundId': _i1.ParameterDescription(
              name: 'refundId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint)
                  .approveRefundRequest(
                    session,
                    params['refundId'],
                  ),
        ),
        'rejectRefundRequest': _i1.MethodConnector(
          name: 'rejectRefundRequest',
          params: {
            'refundId': _i1.ParameterDescription(
              name: 'refundId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['admin'] as _i6.AdminEndpoint).rejectRefundRequest(
                    session,
                    params['refundId'],
                  ),
        ),
        'requirePlaceifyUser': _i1.MethodConnector(
          name: 'requirePlaceifyUser',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint)
                  .requirePlaceifyUser(session),
        ),
        'requireRole': _i1.MethodConnector(
          name: 'requireRole',
          params: {
            'allowedRoles': _i1.ParameterDescription(
              name: 'allowedRoles',
              type: _i1.getType<Set<_i19.UserRole>>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['admin'] as _i6.AdminEndpoint).requireRole(
                session,
                params['allowedRoles'],
              ),
        ),
      },
    );
    connectors['ar'] = _i1.EndpointConnector(
      name: 'ar',
      endpoint: endpoints['ar']!,
      methodConnectors: {
        'recordSession': _i1.MethodConnector(
          name: 'recordSession',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'deviceInfo': _i1.ParameterDescription(
              name: 'deviceInfo',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'snapshotUrl': _i1.ParameterDescription(
              name: 'snapshotUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ar'] as _i7.ArEndpoint).recordSession(
                session,
                params['productId'],
                deviceInfo: params['deviceInfo'],
                snapshotUrl: params['snapshotUrl'],
              ),
        ),
        'listMySessions': _i1.MethodConnector(
          name: 'listMySessions',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['ar'] as _i7.ArEndpoint).listMySessions(
                session,
                limit: params['limit'],
                offset: params['offset'],
              ),
        ),
      },
    );
    connectors['cart'] = _i1.EndpointConnector(
      name: 'cart',
      endpoint: endpoints['cart']!,
      methodConnectors: {
        'getCartItems': _i1.MethodConnector(
          name: 'getCartItems',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cart'] as _i8.CartEndpoint).getCartItems(session),
        ),
        'addToCart': _i1.MethodConnector(
          name: 'addToCart',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'quantity': _i1.ParameterDescription(
              name: 'quantity',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cart'] as _i8.CartEndpoint).addToCart(
                session,
                params['productId'],
                quantity: params['quantity'],
              ),
        ),
        'updateCartItemQuantity': _i1.MethodConnector(
          name: 'updateCartItemQuantity',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'quantity': _i1.ParameterDescription(
              name: 'quantity',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cart'] as _i8.CartEndpoint)
                  .updateCartItemQuantity(
                    session,
                    params['productId'],
                    params['quantity'],
                  ),
        ),
        'removeFromCart': _i1.MethodConnector(
          name: 'removeFromCart',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['cart'] as _i8.CartEndpoint).removeFromCart(
                session,
                params['productId'],
              ),
        ),
        'clearCart': _i1.MethodConnector(
          name: 'clearCart',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['cart'] as _i8.CartEndpoint).clearCart(session),
        ),
      },
    );
    connectors['checkout'] = _i1.EndpointConnector(
      name: 'checkout',
      endpoint: endpoints['checkout']!,
      methodConnectors: {
        'checkout': _i1.MethodConnector(
          name: 'checkout',
          params: {
            'request': _i1.ParameterDescription(
              name: 'request',
              type: _i1.getType<_i25.CheckoutRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checkout'] as _i9.CheckoutEndpoint).checkout(
                    session,
                    params['request'],
                  ),
        ),
      },
    );
    connectors['notification'] = _i1.EndpointConnector(
      name: 'notification',
      endpoint: endpoints['notification']!,
      methodConnectors: {
        'getPreferences': _i1.MethodConnector(
          name: 'getPreferences',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i10.NotificationEndpoint)
                      .getPreferences(session),
        ),
        'updatePreferences': _i1.MethodConnector(
          name: 'updatePreferences',
          params: {
            'orderUpdates': _i1.ParameterDescription(
              name: 'orderUpdates',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'refundStatus': _i1.ParameterDescription(
              name: 'refundStatus',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'arReminders': _i1.ParameterDescription(
              name: 'arReminders',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'priceDropAlerts': _i1.ParameterDescription(
              name: 'priceDropAlerts',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'vendorMessages': _i1.ParameterDescription(
              name: 'vendorMessages',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
            'promotions': _i1.ParameterDescription(
              name: 'promotions',
              type: _i1.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i10.NotificationEndpoint)
                      .updatePreferences(
                        session,
                        orderUpdates: params['orderUpdates'],
                        refundStatus: params['refundStatus'],
                        arReminders: params['arReminders'],
                        priceDropAlerts: params['priceDropAlerts'],
                        vendorMessages: params['vendorMessages'],
                        promotions: params['promotions'],
                      ),
        ),
        'listInAppNotifications': _i1.MethodConnector(
          name: 'listInAppNotifications',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i10.NotificationEndpoint)
                      .listInAppNotifications(
                        session,
                        limit: params['limit'],
                        offset: params['offset'],
                      ),
        ),
        'unreadInAppNotificationCount': _i1.MethodConnector(
          name: 'unreadInAppNotificationCount',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i10.NotificationEndpoint)
                      .unreadInAppNotificationCount(session),
        ),
        'markInAppNotificationRead': _i1.MethodConnector(
          name: 'markInAppNotificationRead',
          params: {
            'notificationId': _i1.ParameterDescription(
              name: 'notificationId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i10.NotificationEndpoint)
                      .markInAppNotificationRead(
                        session,
                        params['notificationId'],
                      ),
        ),
        'markAllInAppNotificationsRead': _i1.MethodConnector(
          name: 'markAllInAppNotificationsRead',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['notification'] as _i10.NotificationEndpoint)
                      .markAllInAppNotificationsRead(session),
        ),
      },
    );
    connectors['order'] = _i1.EndpointConnector(
      name: 'order',
      endpoint: endpoints['order']!,
      methodConnectors: {
        'listMyOrders': _i1.MethodConnector(
          name: 'listMyOrders',
          params: {
            'pagination': _i1.ParameterDescription(
              name: 'pagination',
              type: _i1.getType<_i26.PaginationInput?>(),
              nullable: true,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i18.OrderStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i11.OrderEndpoint).listMyOrders(
                    session,
                    pagination: params['pagination'],
                    status: params['status'],
                  ),
        ),
        'getOrder': _i1.MethodConnector(
          name: 'getOrder',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i11.OrderEndpoint).getOrder(
                session,
                params['orderId'],
              ),
        ),
        'listDeliveryUpdates': _i1.MethodConnector(
          name: 'listDeliveryUpdates',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['order'] as _i11.OrderEndpoint)
                  .listDeliveryUpdates(
                    session,
                    params['orderId'],
                  ),
        ),
      },
    );
    connectors['payment'] = _i1.EndpointConnector(
      name: 'payment',
      endpoint: endpoints['payment']!,
      methodConnectors: {
        'getOverview': _i1.MethodConnector(
          name: 'getOverview',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i12.PaymentEndpoint)
                  .getOverview(session),
        ),
        'listPaymentUpdates': _i1.MethodConnector(
          name: 'listPaymentUpdates',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i12.PaymentEndpoint)
                  .listPaymentUpdates(
                    session,
                    params['orderId'],
                  ),
        ),
        'updateOrderPaymentStatus': _i1.MethodConnector(
          name: 'updateOrderPaymentStatus',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i27.PaymentTransactionStatus>(),
              nullable: false,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i12.PaymentEndpoint)
                  .updateOrderPaymentStatus(
                    session,
                    params['orderId'],
                    params['status'],
                    note: params['note'],
                  ),
        ),
        'requestPayout': _i1.MethodConnector(
          name: 'requestPayout',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['payment'] as _i12.PaymentEndpoint)
                  .requestPayout(session),
        ),
      },
    );
    connectors['product'] = _i1.EndpointConnector(
      name: 'product',
      endpoint: endpoints['product']!,
      methodConnectors: {
        'listCategories': _i1.MethodConnector(
          name: 'listCategories',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i13.ProductEndpoint)
                  .listCategories(session),
        ),
        'searchProducts': _i1.MethodConnector(
          name: 'searchProducts',
          params: {
            'input': _i1.ParameterDescription(
              name: 'input',
              type: _i1.getType<_i28.ProductSearchInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i13.ProductEndpoint).searchProducts(
                    session,
                    params['input'],
                  ),
        ),
        'getProduct': _i1.MethodConnector(
          name: 'getProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i13.ProductEndpoint).getProduct(
                    session,
                    params['productId'],
                  ),
        ),
        'getShopProfile': _i1.MethodConnector(
          name: 'getShopProfile',
          params: {
            'vendorId': _i1.ParameterDescription(
              name: 'vendorId',
              type: _i1.getType<_i1.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i13.ProductEndpoint).getShopProfile(
                    session,
                    params['vendorId'],
                  ),
        ),
        'listApprovedShops': _i1.MethodConnector(
          name: 'listApprovedShops',
          params: {
            'query': _i1.ParameterDescription(
              name: 'query',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i13.ProductEndpoint)
                  .listApprovedShops(
                    session,
                    query: params['query'],
                  ),
        ),
        'getMarketplaceHighlights': _i1.MethodConnector(
          name: 'getMarketplaceHighlights',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['product'] as _i13.ProductEndpoint)
                  .getMarketplaceHighlights(session),
        ),
        'listProducts': _i1.MethodConnector(
          name: 'listProducts',
          params: {
            'categoryName': _i1.ParameterDescription(
              name: 'categoryName',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i13.ProductEndpoint).listProducts(
                    session,
                    categoryName: params['categoryName'],
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
      },
    );
    connectors['refund'] = _i1.EndpointConnector(
      name: 'refund',
      endpoint: endpoints['refund']!,
      methodConnectors: {
        'listMyRefundRequests': _i1.MethodConnector(
          name: 'listMyRefundRequests',
          params: {
            'pagination': _i1.ParameterDescription(
              name: 'pagination',
              type: _i1.getType<_i26.PaginationInput?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['refund'] as _i14.RefundEndpoint)
                  .listMyRefundRequests(
                    session,
                    pagination: params['pagination'],
                  ),
        ),
        'getRefundRequest': _i1.MethodConnector(
          name: 'getRefundRequest',
          params: {
            'refundId': _i1.ParameterDescription(
              name: 'refundId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['refund'] as _i14.RefundEndpoint).getRefundRequest(
                    session,
                    params['refundId'],
                  ),
        ),
        'createRefundRequest': _i1.MethodConnector(
          name: 'createRefundRequest',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['refund'] as _i14.RefundEndpoint)
                  .createRefundRequest(
                    session,
                    params['orderId'],
                    params['reason'],
                  ),
        ),
      },
    );
    connectors['review'] = _i1.EndpointConnector(
      name: 'review',
      endpoint: endpoints['review']!,
      methodConnectors: {
        'submitReview': _i1.MethodConnector(
          name: 'submitReview',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'rating': _i1.ParameterDescription(
              name: 'rating',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'comment': _i1.ParameterDescription(
              name: 'comment',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['review'] as _i15.ReviewEndpoint).submitReview(
                    session,
                    params['productId'],
                    params['orderId'],
                    params['rating'],
                    comment: params['comment'],
                  ),
        ),
        'listProductReviews': _i1.MethodConnector(
          name: 'listProductReviews',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['review'] as _i15.ReviewEndpoint)
                  .listProductReviews(
                    session,
                    params['productId'],
                    limit: params['limit'],
                    offset: params['offset'],
                  ),
        ),
      },
    );
    connectors['vendor'] = _i1.EndpointConnector(
      name: 'vendor',
      endpoint: endpoints['vendor']!,
      methodConnectors: {
        'getMyShop': _i1.MethodConnector(
          name: 'getMyShop',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint).getMyShop(
                session,
              ),
        ),
        'getDashboard': _i1.MethodConnector(
          name: 'getDashboard',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .getDashboard(session),
        ),
        'hasShop': _i1.MethodConnector(
          name: 'hasShop',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).hasShop(session),
        ),
        'createShop': _i1.MethodConnector(
          name: 'createShop',
          params: {
            'shopName': _i1.ParameterDescription(
              name: 'shopName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'logoUrl': _i1.ParameterDescription(
              name: 'logoUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'phone': _i1.ParameterDescription(
              name: 'phone',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'address': _i1.ParameterDescription(
              name: 'address',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'city': _i1.ParameterDescription(
              name: 'city',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'country': _i1.ParameterDescription(
              name: 'country',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'shopCategory': _i1.ParameterDescription(
              name: 'shopCategory',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'contactEmail': _i1.ParameterDescription(
              name: 'contactEmail',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'bankDetails': _i1.ParameterDescription(
              name: 'bankDetails',
              type: _i1.getType<_i29.VendorBankDetailsInput?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).createShop(
                    session,
                    params['shopName'],
                    description: params['description'],
                    logoUrl: params['logoUrl'],
                    phone: params['phone'],
                    address: params['address'],
                    city: params['city'],
                    country: params['country'],
                    shopCategory: params['shopCategory'],
                    contactEmail: params['contactEmail'],
                    bankDetails: params['bankDetails'],
                  ),
        ),
        'getMyBankDetails': _i1.MethodConnector(
          name: 'getMyBankDetails',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .getMyBankDetails(session),
        ),
        'saveMyBankDetails': _i1.MethodConnector(
          name: 'saveMyBankDetails',
          params: {
            'input': _i1.ParameterDescription(
              name: 'input',
              type: _i1.getType<_i29.VendorBankDetailsInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .saveMyBankDetails(
                    session,
                    params['input'],
                  ),
        ),
        'getMyProfile': _i1.MethodConnector(
          name: 'getMyProfile',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .getMyProfile(session),
        ),
        'updateMyProfile': _i1.MethodConnector(
          name: 'updateMyProfile',
          params: {
            'input': _i1.ParameterDescription(
              name: 'input',
              type: _i1.getType<_i30.VendorProfileUpdateInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).updateMyProfile(
                    session,
                    params['input'],
                  ),
        ),
        'uploadShopLogo': _i1.MethodConnector(
          name: 'uploadShopLogo',
          params: {
            'fileData': _i1.ParameterDescription(
              name: 'fileData',
              type: _i1.getType<_i31.ByteData>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).uploadShopLogo(
                    session,
                    params['fileData'],
                    params['fileName'],
                  ),
        ),
        'uploadShopBanner': _i1.MethodConnector(
          name: 'uploadShopBanner',
          params: {
            'fileData': _i1.ParameterDescription(
              name: 'fileData',
              type: _i1.getType<_i31.ByteData>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).uploadShopBanner(
                    session,
                    params['fileData'],
                    params['fileName'],
                  ),
        ),
        'uploadShopCover': _i1.MethodConnector(
          name: 'uploadShopCover',
          params: {
            'fileData': _i1.ParameterDescription(
              name: 'fileData',
              type: _i1.getType<_i31.ByteData>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).uploadShopCover(
                    session,
                    params['fileData'],
                    params['fileName'],
                  ),
        ),
        'uploadDocument': _i1.MethodConnector(
          name: 'uploadDocument',
          params: {
            'documentType': _i1.ParameterDescription(
              name: 'documentType',
              type: _i1.getType<_i32.VendorDocumentType>(),
              nullable: false,
            ),
            'fileData': _i1.ParameterDescription(
              name: 'fileData',
              type: _i1.getType<_i31.ByteData>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).uploadDocument(
                    session,
                    params['documentType'],
                    params['fileData'],
                    params['fileName'],
                  ),
        ),
        'uploadLogo': _i1.MethodConnector(
          name: 'uploadLogo',
          params: {
            'fileData': _i1.ParameterDescription(
              name: 'fileData',
              type: _i1.getType<_i31.ByteData>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).uploadLogo(
                    session,
                    params['fileData'],
                    params['fileName'],
                  ),
        ),
        'uploadBanner': _i1.MethodConnector(
          name: 'uploadBanner',
          params: {
            'fileData': _i1.ParameterDescription(
              name: 'fileData',
              type: _i1.getType<_i31.ByteData>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).uploadBanner(
                    session,
                    params['fileData'],
                    params['fileName'],
                  ),
        ),
        'updateShop': _i1.MethodConnector(
          name: 'updateShop',
          params: {
            'shopName': _i1.ParameterDescription(
              name: 'shopName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'logoUrl': _i1.ParameterDescription(
              name: 'logoUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).updateShop(
                    session,
                    params['shopName'],
                    description: params['description'],
                    logoUrl: params['logoUrl'],
                  ),
        ),
        'listMyProducts': _i1.MethodConnector(
          name: 'listMyProducts',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .listMyProducts(session),
        ),
        'createProduct': _i1.MethodConnector(
          name: 'createProduct',
          params: {
            'name': _i1.ParameterDescription(
              name: 'name',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'description': _i1.ParameterDescription(
              name: 'description',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'price': _i1.ParameterDescription(
              name: 'price',
              type: _i1.getType<double>(),
              nullable: false,
            ),
            'categoryId': _i1.ParameterDescription(
              name: 'categoryId',
              type: _i1.getType<int?>(),
              nullable: true,
            ),
            'materials': _i1.ParameterDescription(
              name: 'materials',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'widthCm': _i1.ParameterDescription(
              name: 'widthCm',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'depthCm': _i1.ParameterDescription(
              name: 'depthCm',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'heightCm': _i1.ParameterDescription(
              name: 'heightCm',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'weightKg': _i1.ParameterDescription(
              name: 'weightKg',
              type: _i1.getType<double?>(),
              nullable: true,
            ),
            'assemblyNote': _i1.ParameterDescription(
              name: 'assemblyNote',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'careInstructions': _i1.ParameterDescription(
              name: 'careInstructions',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'warranty': _i1.ParameterDescription(
              name: 'warranty',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'model3dUrl': _i1.ParameterDescription(
              name: 'model3dUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'thumbnailUrl': _i1.ParameterDescription(
              name: 'thumbnailUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'viewImageUrls': _i1.ParameterDescription(
              name: 'viewImageUrls',
              type: _i1.getType<List<String>?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).createProduct(
                    session,
                    params['name'],
                    params['description'],
                    params['price'],
                    categoryId: params['categoryId'],
                    materials: params['materials'],
                    widthCm: params['widthCm'],
                    depthCm: params['depthCm'],
                    heightCm: params['heightCm'],
                    weightKg: params['weightKg'],
                    assemblyNote: params['assemblyNote'],
                    careInstructions: params['careInstructions'],
                    warranty: params['warranty'],
                    model3dUrl: params['model3dUrl'],
                    thumbnailUrl: params['thumbnailUrl'],
                    viewImageUrls: params['viewImageUrls'],
                  ),
        ),
        'uploadProduct': _i1.MethodConnector(
          name: 'uploadProduct',
          params: {
            'input': _i1.ParameterDescription(
              name: 'input',
              type: _i1.getType<_i33.VendorProductUploadInput>(),
              nullable: false,
            ),
            'imageData': _i1.ParameterDescription(
              name: 'imageData',
              type: _i1.getType<_i31.ByteData>(),
              nullable: false,
            ),
            'imageFileName': _i1.ParameterDescription(
              name: 'imageFileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).uploadProduct(
                    session,
                    params['input'],
                    params['imageData'],
                    params['imageFileName'],
                  ),
        ),
        'updateProductThumbnail': _i1.MethodConnector(
          name: 'updateProductThumbnail',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'thumbnailUrl': _i1.ParameterDescription(
              name: 'thumbnailUrl',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .updateProductThumbnail(
                    session,
                    params['productId'],
                    params['thumbnailUrl'],
                  ),
        ),
        'uploadProductImage': _i1.MethodConnector(
          name: 'uploadProductImage',
          params: {
            'fileData': _i1.ParameterDescription(
              name: 'fileData',
              type: _i1.getType<_i31.ByteData>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
            'removeBackground': _i1.ParameterDescription(
              name: 'removeBackground',
              type: _i1.getType<bool>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .uploadProductImage(
                    session,
                    params['fileData'],
                    params['fileName'],
                    removeBackground: params['removeBackground'],
                  ),
        ),
        'regenerateProductModel3d': _i1.MethodConnector(
          name: 'regenerateProductModel3d',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .regenerateProductModel3d(
                    session,
                    params['productId'],
                  ),
        ),
        'deleteProduct': _i1.MethodConnector(
          name: 'deleteProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).deleteProduct(
                    session,
                    params['productId'],
                  ),
        ),
        'restoreProduct': _i1.MethodConnector(
          name: 'restoreProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).restoreProduct(
                    session,
                    params['productId'],
                  ),
        ),
        'archiveProduct': _i1.MethodConnector(
          name: 'archiveProduct',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).archiveProduct(
                    session,
                    params['productId'],
                  ),
        ),
        'listShopOrders': _i1.MethodConnector(
          name: 'listShopOrders',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'offset': _i1.ParameterDescription(
              name: 'offset',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i18.OrderStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).listShopOrders(
                    session,
                    limit: params['limit'],
                    offset: params['offset'],
                    status: params['status'],
                  ),
        ),
        'getShopOrder': _i1.MethodConnector(
          name: 'getShopOrder',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).getShopOrder(
                    session,
                    params['orderId'],
                  ),
        ),
        'acceptShopOrder': _i1.MethodConnector(
          name: 'acceptShopOrder',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).acceptShopOrder(
                    session,
                    params['orderId'],
                  ),
        ),
        'rejectShopOrder': _i1.MethodConnector(
          name: 'rejectShopOrder',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'reason': _i1.ParameterDescription(
              name: 'reason',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i16.VendorEndpoint).rejectShopOrder(
                    session,
                    params['orderId'],
                    params['reason'],
                  ),
        ),
        'listDeliveryUpdates': _i1.MethodConnector(
          name: 'listDeliveryUpdates',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .listDeliveryUpdates(
                    session,
                    params['orderId'],
                  ),
        ),
        'submitDeliveryUpdate': _i1.MethodConnector(
          name: 'submitDeliveryUpdate',
          params: {
            'orderId': _i1.ParameterDescription(
              name: 'orderId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
            'stage': _i1.ParameterDescription(
              name: 'stage',
              type: _i1.getType<_i34.DeliveryStage>(),
              nullable: false,
            ),
            'note': _i1.ParameterDescription(
              name: 'note',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
            'photoUrl': _i1.ParameterDescription(
              name: 'photoUrl',
              type: _i1.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .submitDeliveryUpdate(
                    session,
                    params['orderId'],
                    params['stage'],
                    note: params['note'],
                    photoUrl: params['photoUrl'],
                  ),
        ),
        'uploadDeliveryProof': _i1.MethodConnector(
          name: 'uploadDeliveryProof',
          params: {
            'fileData': _i1.ParameterDescription(
              name: 'fileData',
              type: _i1.getType<_i31.ByteData>(),
              nullable: false,
            ),
            'fileName': _i1.ParameterDescription(
              name: 'fileName',
              type: _i1.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .uploadDeliveryProof(
                    session,
                    params['fileData'],
                    params['fileName'],
                  ),
        ),
        'listNotifications': _i1.MethodConnector(
          name: 'listNotifications',
          params: {
            'limit': _i1.ParameterDescription(
              name: 'limit',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .listNotifications(
                    session,
                    limit: params['limit'],
                  ),
        ),
        'markNotificationRead': _i1.MethodConnector(
          name: 'markNotificationRead',
          params: {
            'notificationId': _i1.ParameterDescription(
              name: 'notificationId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .markNotificationRead(
                    session,
                    params['notificationId'],
                  ),
        ),
        'markAllNotificationsRead': _i1.MethodConnector(
          name: 'markAllNotificationsRead',
          params: {},
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['vendor'] as _i16.VendorEndpoint)
                  .markAllNotificationsRead(session),
        ),
      },
    );
    connectors['wishlist'] = _i1.EndpointConnector(
      name: 'wishlist',
      endpoint: endpoints['wishlist']!,
      methodConnectors: {
        'listMyWishlist': _i1.MethodConnector(
          name: 'listMyWishlist',
          params: {
            'pagination': _i1.ParameterDescription(
              name: 'pagination',
              type: _i1.getType<_i26.PaginationInput?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wishlist'] as _i17.WishlistEndpoint)
                  .listMyWishlist(
                    session,
                    pagination: params['pagination'],
                  ),
        ),
        'addToWishlist': _i1.MethodConnector(
          name: 'addToWishlist',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wishlist'] as _i17.WishlistEndpoint)
                  .addToWishlist(
                    session,
                    params['productId'],
                  ),
        ),
        'removeFromWishlist': _i1.MethodConnector(
          name: 'removeFromWishlist',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wishlist'] as _i17.WishlistEndpoint)
                  .removeFromWishlist(
                    session,
                    params['productId'],
                  ),
        ),
        'toggleWishlist': _i1.MethodConnector(
          name: 'toggleWishlist',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wishlist'] as _i17.WishlistEndpoint)
                  .toggleWishlist(
                    session,
                    params['productId'],
                  ),
        ),
        'isWishlisted': _i1.MethodConnector(
          name: 'isWishlisted',
          params: {
            'productId': _i1.ParameterDescription(
              name: 'productId',
              type: _i1.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['wishlist'] as _i17.WishlistEndpoint).isWishlisted(
                    session,
                    params['productId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_core'] = _i35.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _i36.Endpoints()
      ..initializeEndpoints(server);
  }
}
