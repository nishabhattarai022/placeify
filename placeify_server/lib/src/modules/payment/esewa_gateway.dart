import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import 'esewa_status_api.dart';

/// eSewa ePay v2 form signing and status verification (RC / production).
///
/// Uses `esewaProductCode` and `esewaSecretKey` from Serverpod passwords.
abstract final class EsewaGateway {
  static const testPaymentUrl =
      'https://rc.esewa.com.np/api/epay/main/v2/form';
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

  /// HMAC for short-lived `/pay/esewa` bootstrap links (in-app + browser fallback).
  static String signBootstrap({
    required int orderId,
    required String transactionUuid,
    required String secretKey,
  }) {
    final message = 'bootstrap:$orderId:$transactionUuid';
    final digest = Hmac(
      sha256,
      utf8.encode(secretKey),
    ).convert(utf8.encode(message));
    return base64Url.encode(digest.bytes).replaceAll('=', '');
  }

  static bool verifyBootstrapSig({
    required int orderId,
    required String transactionUuid,
    required String secretKey,
    required String signature,
  }) {
    if (signature.trim().isEmpty) return false;
    final expected = signBootstrap(
      orderId: orderId,
      transactionUuid: transactionUuid,
      secretKey: secretKey,
    );
    return expected == signature.trim();
  }

  static String buildAutoSubmitHtml(
    String action,
    Map<String, String> fields,
  ) {
    String escape(String value) {
      return const HtmlEscape().convert(value);
    }

    final inputs = fields.entries
        .where((entry) => entry.key != 'payment_url')
        .map(
          (entry) =>
              '<input type="hidden" name="${escape(entry.key)}" '
              'value="${escape(entry.value)}" />',
        )
        .join('\n');
    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>eSewa Payment</title>
  </head>
  <body onload="document.getElementById('esewa-form').submit();">
    <p style="font-family: sans-serif; text-align: center; margin-top: 48px;">
      Redirecting to eSewa…
    </p>
    <form id="esewa-form" action="${escape(action)}" method="POST">
      $inputs
    </form>
  </body>
</html>
''';
  }

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
    final message =
        'total_amount=$totalAmount,'
        'transaction_uuid=$transactionUuid,'
        'product_code=$productCode';
    final digest = Hmac(
      sha256,
      utf8.encode(secretKey),
    ).convert(utf8.encode(message));
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
      'payment_url': isTestProductCode(productCode)
          ? testPaymentUrl
          : livePaymentUrl,
    };
  }

  /// Returns true when eSewa reports the transaction as complete.
  static Future<bool> isPaymentComplete({
    required Session session,
    required double amount,
    required String transactionUuid,
  }) async {
    final result = await EsewaStatusApi.fetchTransactionStatus(
      session: session,
      amount: amount,
      transactionUuid: transactionUuid,
    );
    return result.isComplete;
  }
}
