import 'dart:io';

import 'package:serverpod/serverpod.dart';

import 'src/auth/auth_services_setup.dart';
import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/modules/order/order_auto_cancel_future_call.dart';
import 'src/shared/server_static_paths.dart';
import 'src/web/middleware/uploads_cors_middleware.dart';
import 'src/web/routes/app_config_route.dart';
import 'src/web/routes/root.dart';

/// The starting point of the Serverpod server.
void run(List<String> args) async {
  // Initialize Serverpod and connect it with your generated code.
  final pod = Serverpod(args, Protocol(), Endpoints());

  setupPlaceifyAuthServices(pod, args: args);

  pod.registerFutureCall(OrderAutoCancelFutureCall(), 'orderAutoCancel');

  // Setup a default page at the web root.
  // These are used by the default page.
  pod.webServer.addRoute(RootRoute(), '/');
  pod.webServer.addRoute(RootRoute(), '/index.html');

  // Serve all files in the web/static relative directory under /.
  // These are used by the default web page.
  final root = Directory(ServerStaticPaths.root);
  pod.webServer.addMiddleware(const UploadsCorsMiddleware().call, '/');
  pod.webServer.addRoute(StaticRoute.directory(root));

  // Setup the app config route.
  // We build this configuration based on the servers api url and serve it to
  // the flutter app.
  pod.webServer.addRoute(
    AppConfigRoute(apiConfig: pod.config.apiServer),
    '/app/assets/assets/config.json',
  );

  // Checks if the flutter web app has been built and serves it if it has.
  final appDir = Directory(Uri(path: 'web/app').toFilePath());
  if (appDir.existsSync()) {
    // Serve the flutter web app under the /app path.
    pod.webServer.addRoute(
      FlutterRoute(
        Directory(
          Uri(path: 'web/app').toFilePath(),
        ),
      ),
      '/app',
    );
  } else {
    // If the flutter web app has not been built, serve the build app page.
    pod.webServer.addRoute(
      StaticRoute.file(
        File(
          Uri(path: 'web/pages/build_flutter_app.html').toFilePath(),
        ),
      ),
      '/app/**',
    );
  }

  // Start the server.
  await pod.start();

  await pod.futureCallAtTime(
    'orderAutoCancel',
    OrderAutoCancelTrigger(scheduledAt: DateTime.now().add(const Duration(days: 1))),
    DateTime.now().add(const Duration(seconds: 5)),
  );
}
