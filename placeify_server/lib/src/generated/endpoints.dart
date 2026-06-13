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
import '../modules/ar/ar_endpoint.dart' as _i6;
import '../modules/cart/cart_endpoint.dart' as _i7;
import '../modules/checkout/checkout_endpoint.dart' as _i8;
import '../modules/notification/notification_endpoint.dart' as _i9;
import '../modules/order/order_endpoint.dart' as _i10;
import '../modules/product/product_endpoint.dart' as _i11;
import '../modules/refund/refund_endpoint.dart' as _i12;
import '../modules/review/review_endpoint.dart' as _i13;
import '../modules/vendor/vendor_endpoint.dart' as _i14;
import '../modules/wishlist/wishlist_endpoint.dart' as _i15;
import 'package:placeify_server/src/generated/order_status.dart' as _i16;
import 'package:placeify_server/src/generated/user_role.dart' as _i17;
import 'package:placeify_server/src/generated/checkout_request.dart' as _i18;
import 'package:placeify_server/src/generated/pagination_input.dart' as _i19;
import 'package:placeify_server/src/generated/product_search_input.dart'
    as _i20;
import 'dart:typed_data' as _i21;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i22;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i23;

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
      'ar': _i6.ArEndpoint()
        ..initialize(
          server,
          'ar',
          null,
        ),
      'cart': _i7.CartEndpoint()
        ..initialize(
          server,
          'cart',
          null,
        ),
      'checkout': _i8.CheckoutEndpoint()
        ..initialize(
          server,
          'checkout',
          null,
        ),
      'notification': _i9.NotificationEndpoint()
        ..initialize(
          server,
          'notification',
          null,
        ),
      'order': _i10.OrderEndpoint()
        ..initialize(
          server,
          'order',
          null,
        ),
      'product': _i11.ProductEndpoint()
        ..initialize(
          server,
          'product',
          null,
        ),
      'refund': _i12.RefundEndpoint()
        ..initialize(
          server,
          'refund',
          null,
        ),
      'review': _i13.ReviewEndpoint()
        ..initialize(
          server,
          'review',
          null,
        ),
      'vendor': _i14.VendorEndpoint()
        ..initialize(
          server,
          'vendor',
          null,
        ),
      'wishlist': _i15.WishlistEndpoint()
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
              type: _i1.getType<_i16.OrderStatus?>(),
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
              type: _i1.getType<Set<_i17.UserRole>>(),
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
              ) async => (endpoints['ar'] as _i6.ArEndpoint).recordSession(
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
              ) async => (endpoints['ar'] as _i6.ArEndpoint).listMySessions(
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
                  (endpoints['cart'] as _i7.CartEndpoint).getCartItems(session),
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
              ) async => (endpoints['cart'] as _i7.CartEndpoint).addToCart(
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
              ) async => (endpoints['cart'] as _i7.CartEndpoint)
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
              ) async => (endpoints['cart'] as _i7.CartEndpoint).removeFromCart(
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
                  (endpoints['cart'] as _i7.CartEndpoint).clearCart(session),
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
              type: _i1.getType<_i18.CheckoutRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['checkout'] as _i8.CheckoutEndpoint).checkout(
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
              ) async => (endpoints['notification'] as _i9.NotificationEndpoint)
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
              ) async => (endpoints['notification'] as _i9.NotificationEndpoint)
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
              type: _i1.getType<_i19.PaginationInput?>(),
              nullable: true,
            ),
            'status': _i1.ParameterDescription(
              name: 'status',
              type: _i1.getType<_i16.OrderStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['order'] as _i10.OrderEndpoint).listMyOrders(
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
              ) async => (endpoints['order'] as _i10.OrderEndpoint).getOrder(
                session,
                params['orderId'],
              ),
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
              ) async => (endpoints['product'] as _i11.ProductEndpoint)
                  .listCategories(session),
        ),
        'searchProducts': _i1.MethodConnector(
          name: 'searchProducts',
          params: {
            'input': _i1.ParameterDescription(
              name: 'input',
              type: _i1.getType<_i20.ProductSearchInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['product'] as _i11.ProductEndpoint).searchProducts(
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
                  (endpoints['product'] as _i11.ProductEndpoint).getProduct(
                    session,
                    params['productId'],
                  ),
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
                  (endpoints['product'] as _i11.ProductEndpoint).listProducts(
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
              type: _i1.getType<_i19.PaginationInput?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['refund'] as _i12.RefundEndpoint)
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
                  (endpoints['refund'] as _i12.RefundEndpoint).getRefundRequest(
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
              ) async => (endpoints['refund'] as _i12.RefundEndpoint)
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
                  (endpoints['review'] as _i13.ReviewEndpoint).submitReview(
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
              ) async => (endpoints['review'] as _i13.ReviewEndpoint)
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
              ) async => (endpoints['vendor'] as _i14.VendorEndpoint).getMyShop(
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
              ) async => (endpoints['vendor'] as _i14.VendorEndpoint)
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
                  (endpoints['vendor'] as _i14.VendorEndpoint).hasShop(session),
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i14.VendorEndpoint).createShop(
                    session,
                    params['shopName'],
                    description: params['description'],
                    logoUrl: params['logoUrl'],
                    phone: params['phone'],
                    address: params['address'],
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
                  (endpoints['vendor'] as _i14.VendorEndpoint).updateShop(
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
              ) async => (endpoints['vendor'] as _i14.VendorEndpoint)
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
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i14.VendorEndpoint).createProduct(
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
              ) async => (endpoints['vendor'] as _i14.VendorEndpoint)
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
              type: _i1.getType<_i21.ByteData>(),
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
              ) async => (endpoints['vendor'] as _i14.VendorEndpoint)
                  .uploadProductImage(
                    session,
                    params['fileData'],
                    params['fileName'],
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
              type: _i1.getType<_i16.OrderStatus?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async =>
                  (endpoints['vendor'] as _i14.VendorEndpoint).listShopOrders(
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
                  (endpoints['vendor'] as _i14.VendorEndpoint).getShopOrder(
                    session,
                    params['orderId'],
                  ),
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
              type: _i1.getType<_i19.PaginationInput?>(),
              nullable: true,
            ),
          },
          call:
              (
                _i1.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['wishlist'] as _i15.WishlistEndpoint)
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
              ) async => (endpoints['wishlist'] as _i15.WishlistEndpoint)
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
              ) async => (endpoints['wishlist'] as _i15.WishlistEndpoint)
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
              ) async => (endpoints['wishlist'] as _i15.WishlistEndpoint)
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
                  (endpoints['wishlist'] as _i15.WishlistEndpoint).isWishlisted(
                    session,
                    params['productId'],
                  ),
        ),
      },
    );
    modules['serverpod_auth_core'] = _i22.Endpoints()
      ..initializeEndpoints(server);
    modules['serverpod_auth_idp'] = _i23.Endpoints()
      ..initializeEndpoints(server);
  }
}
