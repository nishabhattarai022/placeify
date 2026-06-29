import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'resolve_server_url.dart';

/// Global Serverpod client for backend API calls.
late Client client;
late String serverUrl;

late final FlutterAuthSessionManager _authSessionManager;

StreamController<InAppNotificationSummary>? _inAppNotificationController;
StreamSubscription<InAppNotificationSummary>? _inAppNotificationSubscription;
bool _realtimeActive = false;
Timer? _realtimeReconnectTimer;

/// Broadcast stream of live in-app notification events from the server.
Stream<InAppNotificationSummary> get inAppNotificationEvents {
  _inAppNotificationController ??=
      StreamController<InAppNotificationSummary>.broadcast();
  return _inAppNotificationController!.stream;
}

bool _isOrderActivityNotification(InAppNotificationSummary notification) {
  return switch (notification.type) {
    InAppNotificationType.orderPlaced ||
    InAppNotificationType.orderAccepted ||
    InAppNotificationType.orderCancelled ||
    InAppNotificationType.deliveryUpdate ||
    InAppNotificationType.paymentUpdate ||
    InAppNotificationType.refundUpdate =>
      true,
    _ => false,
  };
}

/// Whether a live notification should trigger order/dashboard refresh.
bool shouldRefreshOrdersForNotification(InAppNotificationSummary notification) {
  return _isOrderActivityNotification(notification);
}

/// Whether a live notification should trigger vendor dashboard refresh.
bool shouldRefreshVendorDashboardForNotification(
  InAppNotificationSummary notification,
) {
  return _isOrderActivityNotification(notification) ||
      notification.type == InAppNotificationType.productUpdate;
}

// #region agent log
void _agentLog(
  String location,
  String message,
  Map<String, Object?> data, {
  required String hypothesisId,
}) {
  try {
    File('/Users/rosikagajurel/Documents/College/placeify/.cursor/debug-1d536e.log')
        .writeAsStringSync(
      '${jsonEncode({
        'sessionId': '1d536e',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'location': location,
        'message': message,
        'data': data,
        'hypothesisId': hypothesisId,
      })}\n',
      mode: FileMode.append,
    );
  } catch (_) {}
}
// #endregion

Future<void> _ensureInAppNotificationWatch() async {
  if (!client.auth.isAuthenticated) return;

  await _inAppNotificationSubscription?.cancel();
  _inAppNotificationSubscription = null;

  final stream = client.notification.watchInAppNotifications();
  _inAppNotificationController ??=
      StreamController<InAppNotificationSummary>.broadcast();

  _inAppNotificationSubscription = stream.listen(
    (notification) {
      // #region agent log
      _agentLog(
        'placeify_server_client.dart:stream',
        'notification received',
        {
          'id': notification.id,
          'type': notification.type.name,
          'referenceId': notification.referenceId,
        },
        hypothesisId: 'H2',
      );
      // #endregion
      final controller = _inAppNotificationController;
      if (controller != null && !controller.isClosed) {
        controller.add(notification);
      }
    },
    onError: (Object error, StackTrace stackTrace) {
      // #region agent log
      _agentLog(
        'placeify_server_client.dart:stream',
        'stream error',
        {'error': error.toString()},
        hypothesisId: 'H3',
      );
      // #endregion
      _scheduleRealtimeReconnect();
    },
    onDone: () {
      // #region agent log
      _agentLog(
        'placeify_server_client.dart:stream',
        'stream closed',
        {},
        hypothesisId: 'H3',
      );
      // #endregion
      _scheduleRealtimeReconnect();
    },
  );

  // #region agent log
  _agentLog(
    'placeify_server_client.dart:_ensureInAppNotificationWatch',
    'stream subscribed',
    {'serverUrl': serverUrl},
    hypothesisId: 'H2',
  );
  // #endregion
}

void _scheduleRealtimeReconnect() {
  if (!_realtimeActive) return;
  _realtimeReconnectTimer?.cancel();
  _realtimeReconnectTimer = Timer(const Duration(seconds: 3), () {
    if (!_realtimeActive || !client.auth.isAuthenticated) return;
    unawaited(_ensureInAppNotificationWatch());
  });
}

/// Starts the shared server notification stream once per authenticated session.
Future<void> ensurePlaceifyRealtime() async {
  if (!client.auth.isAuthenticated) return;
  _realtimeActive = true;
  if (_inAppNotificationSubscription != null) return;
  await _ensureInAppNotificationWatch();
}

/// Stops the shared server notification stream.
Future<void> stopPlaceifyRealtime() async {
  if (!_realtimeActive) return;
  _realtimeActive = false;
  _realtimeReconnectTimer?.cancel();
  _realtimeReconnectTimer = null;
  await _inAppNotificationSubscription?.cancel();
  _inAppNotificationSubscription = null;
}

Future<void> resetPlaceifyRealtime() async {
  _realtimeActive = false;
  _realtimeReconnectTimer?.cancel();
  _realtimeReconnectTimer = null;
  await _inAppNotificationSubscription?.cancel();
  _inAppNotificationSubscription = null;
  await _inAppNotificationController?.close();
  _inAppNotificationController = null;
}

/// Creates the client and restores any saved auth session.
Future<void> initializePlaceifyClient() async {
  _authSessionManager = FlutterAuthSessionManager();
  await _createClient(forceRefresh: false);
  if (client.auth.isAuthenticated) {
    await ensurePlaceifyRealtime();
  }
}

/// Re-probes the network and rebuilds [client] (e.g. after connection errors).
Future<void> reconnectPlaceifyClient({bool forceRefresh = true}) async {
  if (forceRefresh) {
    await clearCachedServerUrl();
  }
  await _createClient(forceRefresh: forceRefresh);
  if (client.auth.isAuthenticated) {
    await ensurePlaceifyRealtime();
  }
}

/// Tripo 3D generation can take several minutes; default Serverpod timeout is 20s.
const Duration placeifyLongRequestTimeout = Duration(minutes: 10);

Future<void> _createClient({required bool forceRefresh}) async {
  await resetPlaceifyRealtime();
  serverUrl = await resolveServerUrl(forceRefresh: forceRefresh);
  client = Client(
    serverUrl,
    connectionTimeout: placeifyLongRequestTimeout,
  )
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = _authSessionManager;
  await client.auth.initialize();
}
