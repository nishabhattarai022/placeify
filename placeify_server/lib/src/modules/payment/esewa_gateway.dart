import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// eSewa ePay v2 form signing and status verification (RC / production).
///
/// Uses `esewaProductCode` and `esewaSecretKey` from Serverpod passwords.
abstract final class EsewaGateway {
  static const testPaymentUrl =
      'https://rc-epay.esewa.com.np/api/epay/main/v2/form';
  static const livePaymentUrl =
      'https://epay.esewa.com.np/api/epay/main/v2/form';
  static const testStatusUrl =
      'https://rc.esewa.com.np/api/epay/transaction/status/';
  static const liveStatusUrl =
      'https://epay.esewa.com.np/api/epay/transaction/status/';

  /// Merchant redirect intercept URLs for the in-app WebView.
  static const successRedirectUrl = 'https://placeify.local/esewa/success';
  static const failureRedirectUrl = 'https://placeify.local/esewa/failure';

  static bool isTestProductCode(String productCode) =>
      productCode.toUpperCase().contains('TEST');

  static ({String productCode, String secretKey}) requireCredentials(
    Session session,
  ) {
    final productCode = session.passwords['esewaProductCode']?.trim();
    final secretKey = session.passwords['esewaSecretKey']?.trim();
    if (productCode == null ||
        productCode.isEmpty ||
        secretKey == null ||
        secretKey.isEmpty) {
      throw StateError(
        'eSewa credentials are not configured (esewaProductCode / esewaSecretKey).',
      );
    }
    return (productCode: productCode, secretKey: secretKey);
  }

  static String formatAmount(double amount) {
    // eSewa ePay v2 status checks are strict about decimal formatting.
    return amount.toStringAsFixed(2);
  }

  static String sign({
    required String totalAmount,
    required String transactionUuid,
    required String productCode,
    required String secretKey,
  }) {
    final message = 'total_amount=$totalAmount,'
        'transaction_uuid=$transactionUuid,'
        'product_code=$productCode';
    final digest = Hmac(sha256, utf8.encode(secretKey)).convert(utf8.encode(message));
    return base64Encode(digest.bytes);
  }

  static Map<String, String> buildFormFields({
    required double amount,
    required String transactionUuid,
    required String productCode,
    required String secretKey,
  }) {
    final totalAmount = formatAmount(amount);
    final signature = sign(
      totalAmount: totalAmount,
      transactionUuid: transactionUuid,
      productCode: productCode,
      secretKey: secretKey,
    );

    return {
      'amount': totalAmount,
      'tax_amount': '0',
      'total_amount': totalAmount,
      'transaction_uuid': transactionUuid,
      'product_code': productCode,
      'product_service_charge': '0',
      'product_delivery_charge': '0',
      'success_url': successRedirectUrl,
      'failure_url': failureRedirectUrl,
      'signed_field_names': 'total_amount,transaction_uuid,product_code',
      'signature': signature,
      'payment_url': isTestProductCode(productCode) ? testPaymentUrl : livePaymentUrl,
    };
  }

  /// Returns true when eSewa reports the transaction as complete.
  static Future<bool> isPaymentComplete({
    required Session session,
    required double amount,
    required String transactionUuid,
  }) async {
    final credentials = requireCredentials(session);
    final statusBase = isTestProductCode(credentials.productCode)
        ? testStatusUrl
        : liveStatusUrl;
    final uri = Uri.parse(statusBase).replace(
      queryParameters: {
        'product_code': credentials.productCode,
        'total_amount': formatAmount(amount),
        'transaction_uuid': transactionUuid,
      },
    );

    final response = await http.get(uri).timeout(const Duration(seconds: 20));
    if (response.statusCode < 200 || response.statusCode >= 300) {
      return false;
    }

    try {
      final body = jsonDecode(response.body);
      if (body is! Map) return false;
      final status = '${body['status'] ?? body['transaction_status'] ?? ''}'
          .toUpperCase();
      return status == 'COMPLETE' || status == 'COMPLETED';
    } catch (_) {
      return false;
    }
  }
}
