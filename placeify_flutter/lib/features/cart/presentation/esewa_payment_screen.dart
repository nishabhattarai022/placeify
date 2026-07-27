import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../core/config/placeify_server_client.dart';
import '../../../core/debug/agent_debug_log.dart';
import '../../../core/router/app_router.dart';
import '../../orders/presentation/providers/orders_provider.dart';
import '../../profile/presentation/providers/profile_dashboard_provider.dart';
import '../data/cart_api_errors.dart';
import '../domain/constants/cart_strings.dart';
import 'providers/cart_provider.dart';

/// Completes eSewa ePay v2 inside an in-app WebView using the signed server form.
class EsewaPaymentScreen extends ConsumerStatefulWidget {
  const EsewaPaymentScreen({required this.orderId, super.key});

  final int orderId;

  @override
  ConsumerState<EsewaPaymentScreen> createState() => _EsewaPaymentScreenState();
}

class _EsewaPaymentScreenState extends ConsumerState<EsewaPaymentScreen> {
  WebViewController? _controller;
  String? _error;
  bool _loadingForm = true;
  bool _finishing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _startPayment());
  }

  Future<void> _startPayment() async {
    try {
      final raw = await client.user.getEsewaPaymentForm(widget.orderId);
      final decoded = jsonDecode(raw);
      if (decoded is! Map) {
        throw StateError('Invalid eSewa form payload.');
      }
      final fields = <String, String>{
        for (final entry in decoded.entries)
          if (entry.key != 'orderId' && entry.key != 'payment_url')
            entry.key.toString(): '${entry.value}',
      };
      final paymentUrl = '${decoded['payment_url'] ?? ''}';
      if (paymentUrl.isEmpty || fields.isEmpty) {
        throw StateError('eSewa payment form is incomplete.');
      }

      final html = _buildAutoSubmitHtml(paymentUrl, fields);
      final controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setNavigationDelegate(
          NavigationDelegate(
            onNavigationRequest: (request) {
              if (_handleRedirect(request.url)) {
                return NavigationDecision.prevent;
              }
              return NavigationDecision.navigate;
            },
            onUrlChange: (change) {
              final url = change.url;
              if (url != null) {
                _handleRedirect(url);
              }
            },
            onWebResourceError: (error) {
              if (!mounted) return;
              // Ignore subresource noise; only fail the main eSewa document.
              if (error.isForMainFrame == false) return;
              setState(() {
                _controller = null;
                _loadingForm = false;
                _error = CartStrings.esewaUnavailable;
              });
            },
            onHttpError: (error) {
              if (!mounted) return;
              final code = error.response?.statusCode;
              if (code == null || code < 500) return;
              setState(() {
                _controller = null;
                _loadingForm = false;
                _error = CartStrings.esewaUnavailable;
              });
            },
          ),
        )
        ..loadHtmlString(html, baseUrl: paymentUrl);

      if (!mounted) return;
      setState(() {
        _controller = controller;
        _loadingForm = false;
        _error = null;
      });
    } catch (error, stackTrace) {
      debugPrint('[esewa] form load failed: $error');
      debugPrint('$stackTrace');
      if (!mounted) return;
      setState(() {
        _loadingForm = false;
        _error = CartApiErrors.message(
          error,
          fallback: CartStrings.paymentFailed,
        );
      });
    }
  }

  bool _handleRedirect(String url) {
    if (_isSuccessUrl(url)) {
      unawaited(_onPaymentSuccess());
      return true;
    }
    if (_isFailureUrl(url)) {
      unawaited(_onPaymentFailure());
      return true;
    }
    return false;
  }

  String _buildAutoSubmitHtml(String action, Map<String, String> fields) {
    final inputs = fields.entries
        .map(
          (e) =>
              '<input type="hidden" name="${_escape(e.key)}" value="${_escape(e.value)}" />',
        )
        .join('\n');
    return '''
<!DOCTYPE html>
<html>
  <head>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>eSewa Payment</title>
  </head>
  <body onload="document.getElementById('esewa-form').submit();">
    <p style="font-family: sans-serif; text-align: center; margin-top: 48px;">
      Redirecting to eSewa…
    </p>
    <form id="esewa-form" action="${_escape(action)}" method="POST">
      $inputs
    </form>
  </body>
</html>
''';
  }

  String _escape(String value) => const HtmlEscape().convert(value);

  bool _isSuccessUrl(String url) =>
      url.contains('placeify.local/esewa/success') ||
      url.contains('/esewa/success');

  bool _isFailureUrl(String url) =>
      url.contains('placeify.local/esewa/failure') ||
      url.contains('/esewa/failure');

  Future<void> _onPaymentSuccess() async {
    if (_finishing) return;
    _finishing = true;
    try {
      // Verify with backend before treating payment as complete.
      await client.user.completePayment(widget.orderId);
      // #region agent log
      agentDebugLog(
        location: 'esewa_payment_screen.dart:_onPaymentSuccess',
        message: 'completePayment succeeded',
        hypothesisId: 'H4',
        data: {
          'orderId': widget.orderId,
          'willNavigateTo': '/profile/orders/${widget.orderId}',
        },
        runId: 'post-fix',
      );
      // #endregion
      ref.read(cartProvider.notifier).replaceItems(const []);
      ref.invalidate(ordersProvider);
      ref.invalidate(orderByIdProvider('${widget.orderId}'));
      ref.invalidate(profileDashboardProvider);
      ref.invalidate(profileOrdersProvider);

      // Prefer SnackBar — toast Overlay can throw on root navigator context.
      final messenger = rootScaffoldMessengerKey.currentState;
      if (messenger != null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text(CartStrings.paymentSuccessful),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
      await Future<void>.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      context.go('/profile/orders/${widget.orderId}');
    } catch (error) {
      _finishing = false;
      // #region agent log
      agentDebugLog(
        location: 'esewa_payment_screen.dart:_onPaymentSuccess:catch',
        message: 'completePayment failed',
        hypothesisId: 'H4',
        data: {'orderId': widget.orderId, 'error': error.toString()},
        runId: 'pre-fix',
      );
      // #endregion
      final messenger = rootScaffoldMessengerKey.currentState;
      if (messenger != null) {
        messenger
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                CartApiErrors.message(
                  error,
                  fallback: CartStrings.paymentFailed,
                ),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
      }
    }
  }

  Future<void> _onPaymentFailure() async {
    if (_finishing) return;
    _finishing = true;
    final messenger = rootScaffoldMessengerKey.currentState;
    if (messenger != null) {
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(
            content: Text(CartStrings.paymentFailed),
            behavior: SnackBarBehavior.floating,
          ),
        );
    }
    // Server already cleared cart when the unpaid order was created; keep local
    // cart empty and send the customer to the unpaid order to retry payment.
    await ref.read(cartProvider.notifier).refresh();
    ref.invalidate(ordersProvider);
    ref.invalidate(orderByIdProvider('${widget.orderId}'));
    if (!mounted) return;
    context.go('/profile/orders/${widget.orderId}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSewa Payment'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () async {
            await ref.read(cartProvider.notifier).refresh();
            if (!context.mounted) return;
            context.go('/profile/orders/${widget.orderId}');
          },
        ),
      ),
      body: _loadingForm
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        FilledButton(
                          onPressed: () {
                            setState(() {
                              _loadingForm = true;
                              _error = null;
                            });
                            _startPayment();
                          },
                          child: const Text('Retry'),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () =>
                              context.go('/profile/orders/${widget.orderId}'),
                          child: const Text('View order'),
                        ),
                      ],
                    ),
                  ),
                )
              : WebViewWidget(controller: _controller!),
    );
  }
}
