import 'package:placeify_client/placeify_client.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

import 'resolve_server_url.dart';

/// Global Serverpod client for backend API calls.
late Client client;
late String serverUrl;

late final FlutterAuthSessionManager _authSessionManager;

/// Creates the client and restores any saved auth session.
Future<void> initializePlaceifyClient() async {
  _authSessionManager = FlutterAuthSessionManager();
  await _createClient(forceRefresh: false);
}

/// Re-probes the network and rebuilds [client] (e.g. after connection errors).
Future<void> reconnectPlaceifyClient({bool forceRefresh = true}) async {
  if (forceRefresh) {
    await clearCachedServerUrl();
  }
  await _createClient(forceRefresh: forceRefresh);
}

/// Tripo 3D generation can take several minutes; default Serverpod timeout is 20s.
const Duration placeifyLongRequestTimeout = Duration(minutes: 10);

Future<void> _createClient({required bool forceRefresh}) async {
  serverUrl = await resolveServerUrl(forceRefresh: forceRefresh);
  client =
      Client(
          serverUrl,
          connectionTimeout: placeifyLongRequestTimeout,
        )
        ..connectivityMonitor = FlutterConnectivityMonitor()
        ..authSessionManager = _authSessionManager;
  await client.auth.initialize();
}
