import 'dart:async';

import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'resolve_media_url.dart';
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
      notification.type == InAppNotificationType.productUpdate ||
      notification.type == InAppNotificationType.paymentUpdate ||
      notification.type == InAppNotificationType.refundUpdate;
}

Future<void> _ensureInAppNotificationWatch() async {
  if (!client.auth.isAuthenticated) return;

  await _inAppNotificationSubscription?.cancel();
  _inAppNotificationSubscription = null;

  final stream = client.notification.watchInAppNotifications();
  _inAppNotificationController ??=
      StreamController<InAppNotificationSummary>.broadcast();

  _inAppNotificationSubscription = stream.listen(
    (notification) {
      final controller = _inAppNotificationController;
      if (controller != null && !controller.isClosed) {
        controller.add(notification);
      }
    },
    onError: (Object error, StackTrace stackTrace) {
      _scheduleRealtimeReconnect();
    },
    onDone: () {
      _scheduleRealtimeReconnect();
    },
  );
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
    unawaited(ensurePlaceifyRealtime());
  }
}

/// Re-probes the network and rebuilds [client] (e.g. after connection errors).
Future<void> reconnectPlaceifyClient({bool forceRefresh = true}) async {
  if (forceRefresh) {
    await clearCachedServerUrl();
    clearResolvedMediaApiBase();
  }
  await _createClient(forceRefresh: forceRefresh);
  if (client.auth.isAuthenticated) {
    unawaited(ensurePlaceifyRealtime());
  }
}

/// Default endpoint timeout. Keep short so login/catalog fail fast when the
/// server is unreachable. Build 3D no longer needs a long client timeout
/// because Tripo runs in a server background job.
const Duration placeifyRequestTimeout = Duration(seconds: 20);

Future<void> _createClient({required bool forceRefresh}) async {
  await resetPlaceifyRealtime();
  serverUrl = await resolveServerUrl(forceRefresh: forceRefresh);
  client = Client(
    serverUrl,
    connectionTimeout: placeifyRequestTimeout,
  )
    ..connectivityMonitor = FlutterConnectivityMonitor()
    ..authSessionManager = _authSessionManager;
  try {
    await client.auth.initialize(
      timeout: const Duration(seconds: 8),
    );
  } on TimeoutException {
    // Server unreachable at startup; app can still launch and retry later.
  } on ServerpodClientException {
    // Auth validation failed due to connectivity; session stays restored locally.
  }
}
