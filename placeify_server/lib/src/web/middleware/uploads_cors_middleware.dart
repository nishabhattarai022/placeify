import 'package:serverpod/serverpod.dart';

/// Allows Flutter web (and other origins) to load product photos from the
/// web server static `/uploads` route.
class UploadsCorsMiddleware extends MiddlewareObject {
  const UploadsCorsMiddleware();

  @override
  Handler call(Handler next) {
    return (Request req) async {
      if (!_isUploadRequest(req)) {
        return next(req);
      }

      if (req.method == Method.options) {
        return Response(204, headers: _corsHeaders());
      }

      final result = await next(req);
      if (result is Response) {
        return result.copyWith(
          headers: result.headers.transform((mh) {
            mh.accessControlAllowOrigin =
                const AccessControlAllowOriginHeader.wildcard();
          }),
        );
      }

      return result;
    };
  }

  bool _isUploadRequest(Request req) {
    final path = req.url.path;
    return path == '/uploads' || path.startsWith('/uploads/');
  }

  Headers _corsHeaders() {
    return Headers.build((mh) {
      mh.accessControlAllowOrigin =
          const AccessControlAllowOriginHeader.wildcard();
      mh.accessControlAllowMethods = AccessControlAllowMethodsHeader.methods(
        [Method.get, Method.head, Method.options],
      );
    });
  }
}
