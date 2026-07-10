import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../auth/password_reset_service.dart';

class ForgotPasswordRoute extends Route {
  ForgotPasswordRoute() : super(methods: const {Method.post});

  final _service = PasswordResetService();

  @override
  Future<Response> handleCall(Session session, Request request) async {
    try {
      final payload = await _decodeJsonBody(request);
      await _service.forgotPassword(
        session,
        email: payload['email']?.toString() ?? '',
        ipAddress: _resolveIpAddress(request),
      );
      return _jsonResponse(
        200,
        {'message': PasswordResetService.genericForgotPasswordMessage},
      );
    } on PasswordResetHttpException catch (error) {
      return _jsonResponse(
        error.statusCode,
        {'message': error.message, 'code': error.code},
      );
    } on FormatException {
      return _jsonResponse(
        400,
        {
          'message': 'Malformed JSON request body.',
          'code': 'INVALID_JSON',
        },
      );
    }
  }
}

class ResetPasswordRoute extends Route {
  ResetPasswordRoute() : super(methods: const {Method.post});

  final _service = PasswordResetService();

  @override
  Future<Response> handleCall(Session session, Request request) async {
    try {
      final payload = await _decodeJsonBody(request);
      await _service.resetPassword(
        session,
        token: payload['token']?.toString() ?? '',
        newPassword: payload['newPassword']?.toString() ?? '',
      );
      return _jsonResponse(
        200,
        {'message': PasswordResetService.genericResetPasswordMessage},
      );
    } on PasswordResetHttpException catch (error) {
      return _jsonResponse(
        error.statusCode,
        {'message': error.message, 'code': error.code},
      );
    } on FormatException {
      return _jsonResponse(
        400,
        {
          'message': 'Malformed JSON request body.',
          'code': 'INVALID_JSON',
        },
      );
    }
  }
}

Future<Map<String, dynamic>> _decodeJsonBody(Request request) async {
  final rawBody = await request.readAsString(maxLength: 32 * 1024);
  if (rawBody.trim().isEmpty) {
    throw const PasswordResetHttpException(
      statusCode: 400,
      message: 'Request body is required.',
      code: 'EMPTY_BODY',
    );
  }

  final decoded = jsonDecode(rawBody);
  if (decoded is! Map<String, dynamic>) {
    throw const PasswordResetHttpException(
      statusCode: 400,
      message: 'JSON object body is required.',
      code: 'INVALID_BODY',
    );
  }
  return decoded;
}

String _resolveIpAddress(Request request) {
  final forwardedFor = request.headers['x-forwarded-for'];
  if (forwardedFor != null && forwardedFor.isNotEmpty) {
    final first = forwardedFor.first.split(',').first.trim();
    if (first.isNotEmpty) {
      return first;
    }
  }
  return request.connectionInfo.remote.address.toString();
}

Response _jsonResponse(int statusCode, Map<String, Object?> body) {
  return Response(
    statusCode,
    body: Body.fromString(jsonEncode(body), mimeType: MimeType.json),
    headers: Headers.build(
      (headers) => headers.cacheControl = CacheControlHeader(
        noCache: true,
        privateCache: true,
      ),
    ),
  );
}
