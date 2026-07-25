import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

import 'esewa_gateway.dart';

/// Parsed eSewa transaction status enquiry response.
class EsewaTransactionStatusResult {
  const EsewaTransactionStatusResult({
    required this.status,
    required this.rawBody,
    this.refId,
    this.httpStatusCode,
    this.errorMessage,
  });

  /// Normalized uppercase status string (e.g. COMPLETE, FULL_REFUND).
  final String status;
  final String rawBody;
  final String? refId;
  final int? httpStatusCode;
  final String? errorMessage;

  bool get isFullRefund => status == 'FULL_REFUND';
  bool get isComplete => status == 'COMPLETE' || status == 'COMPLETED';
  bool get ok => errorMessage == null && status.isNotEmpty;
}

/// Shared eSewa ePay transaction status enquiry (pay + refund Mode B).
abstract final class EsewaStatusApi {
  static Future<EsewaTransactionStatusResult> fetchTransactionStatus({
    required Session session,
    required double amount,
    required String transactionUuid,
    http.Client? httpClient,
  }) async {
    final credentials = EsewaGateway.requireCredentials(session);
    final statusBase = EsewaGateway.isTestProductCode(credentials.productCode)
        ? EsewaGateway.testStatusUrl
        : EsewaGateway.liveStatusUrl;
    final uri = Uri.parse(statusBase).replace(
      queryParameters: {
        'product_code': credentials.productCode,
        'total_amount': EsewaGateway.formatAmount(amount),
        'transaction_uuid': transactionUuid,
      },
    );

    final client = httpClient ?? http.Client();
    final ownsClient = httpClient == null;
    try {
      final response =
          await client.get(uri).timeout(const Duration(seconds: 20));
      final raw = response.body;
      if (response.statusCode < 200 || response.statusCode >= 300) {
        return EsewaTransactionStatusResult(
          status: '',
          rawBody: raw,
          httpStatusCode: response.statusCode,
          errorMessage: 'eSewa status HTTP ${response.statusCode}',
        );
      }

      try {
        final body = jsonDecode(raw);
        if (body is! Map) {
          return EsewaTransactionStatusResult(
            status: '',
            rawBody: raw,
            httpStatusCode: response.statusCode,
            errorMessage: 'Unexpected eSewa status body',
          );
        }
        final map = Map<String, dynamic>.from(body);
        final status = '${map['status'] ?? map['transaction_status'] ?? ''}'
            .toUpperCase()
            .trim();
        final refId = '${map['ref_id'] ?? map['refId'] ?? ''}'.trim();
        return EsewaTransactionStatusResult(
          status: status,
          rawBody: raw.length > 4000 ? raw.substring(0, 4000) : raw,
          refId: refId.isEmpty ? null : refId,
          httpStatusCode: response.statusCode,
        );
      } catch (_) {
        return EsewaTransactionStatusResult(
          status: '',
          rawBody: raw,
          httpStatusCode: response.statusCode,
          errorMessage: 'Failed to parse eSewa status JSON',
        );
      }
    } finally {
      if (ownsClient) client.close();
    }
  }
}
