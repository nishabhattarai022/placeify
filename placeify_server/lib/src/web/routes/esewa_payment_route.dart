import 'package:serverpod/serverpod.dart' hide Order;

import '../../auth/email_verification_service.dart';
import '../../generated/protocol.dart';
import '../../modules/payment/esewa_gateway.dart';

/// Public HTML bootstrap page that auto-posts a signed eSewa form.
///
/// Used when the in-app WebView cannot POST cross-origin (Flutter web / desktop).
class EsewaPaymentRoute extends Route {
  EsewaPaymentRoute() : super(methods: const {Method.get});

  @override
  Future<Response> handleCall(Session session, Request request) async {
    final params = request.url.queryParameters;
    final orderId = int.tryParse(params['orderId'] ?? '');
    final transactionUuid = params['tx']?.trim() ?? '';
    final signature = params['sig']?.trim() ?? '';

    if (orderId == null || transactionUuid.isEmpty || signature.isEmpty) {
      return _textResponse(400, 'Invalid eSewa payment link.');
    }

    late final ({String productCode, String secretKey}) credentials;
    try {
      credentials = EsewaGateway.requireCredentials(session);
    } on StateError {
      return _textResponse(
        503,
        'eSewa is not configured on the server yet.',
      );
    }

    if (!EsewaGateway.verifyBootstrapSig(
      orderId: orderId,
      transactionUuid: transactionUuid,
      secretKey: credentials.secretKey,
      signature: signature,
    )) {
      return _textResponse(
        403,
        'This eSewa payment link is invalid or expired.',
      );
    }

    final order = await Order.db.findById(session, orderId);
    if (order == null) {
      return _textResponse(404, 'Order not found.');
    }
    if (order.status == OrderStatus.cancelled ||
        order.status == OrderStatus.rejected ||
        order.status == OrderStatus.autoCancelled) {
      return _textResponse(409, 'This order can no longer be paid.');
    }

    final payment = await PaymentTransaction.db.findFirstRow(
      session,
      where: (row) => row.orderId.equals(orderId),
    );
    if (payment == null) {
      return _textResponse(404, 'Payment record not found for this order.');
    }
    if (payment.paymentMethod != PaymentMethod.esewa) {
      return _textResponse(409, 'This order was not placed with eSewa.');
    }
    if (payment.status == PaymentTransactionStatus.paid) {
      return _textResponse(409, 'This order is already paid.');
    }
    if (payment.providerTransactionId.trim() != transactionUuid) {
      return _textResponse(403, 'This eSewa payment link is no longer valid.');
    }

    final fields = EsewaGateway.buildFormFields(
      amount: payment.amount,
      transactionUuid: transactionUuid,
      productCode: credentials.productCode,
      secretKey: credentials.secretKey,
    );
    final paymentUrl = fields['payment_url'] ?? EsewaGateway.testPaymentUrl;
    final html = EsewaGateway.buildAutoSubmitHtml(paymentUrl, fields);

    return Response(
      200,
      body: Body.fromString(html, mimeType: MimeType.html),
      headers: Headers.build(
        (headers) => headers.cacheControl = CacheControlHeader(
          noCache: true,
          privateCache: true,
        ),
      ),
    );
  }
}

Response _textResponse(int statusCode, String message) {
  return Response(
    statusCode,
    body: Body.fromString(message, mimeType: MimeType.plainText),
    headers: Headers.build(
      (headers) => headers.cacheControl = CacheControlHeader(
        noCache: true,
        privateCache: true,
      ),
    ),
  );
}

/// Builds an absolute bootstrap URL on the Serverpod web server (port 8082).
Future<String> buildEsewaBootstrapUrl(
  Session session, {
  required int orderId,
  required String transactionUuid,
  required String secretKey,
}) async {
  final base = await resolveFrontendBaseUrl(session);
  final sig = EsewaGateway.signBootstrap(
    orderId: orderId,
    transactionUuid: transactionUuid,
    secretKey: secretKey,
  );
  final uri = Uri.parse(base).replace(
    path: '/pay/esewa',
    queryParameters: {
      'orderId': '$orderId',
      'tx': transactionUuid,
      'sig': sig,
    },
  );
  return uri.toString();
}
