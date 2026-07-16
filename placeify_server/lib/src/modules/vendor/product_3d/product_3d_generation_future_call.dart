import 'dart:async';

import 'package:serverpod/serverpod.dart' hide Order;

import '../../../generated/product_3d_generation_trigger.dart';
import '../../../generated/protocol.dart';
import '../../notification/in_app_notification_store.dart';
import 'product_3d_generation_result.dart';
import 'product_3d_generator.dart';
import 'product_model_3d_status.dart';

/// Runs Tripo generation for [productId] on a background [InternalSession].
///
/// Used so the vendor HTTP request can return immediately. Survives client
/// disconnect / logout; does not survive a full server process restart.
Future<void> runProduct3dGenerationInBackground(
  Serverpod pod,
  int productId,
) async {
  final session = await pod.createSession(enableLogging: true);
  try {
    await Product3dGenerationRunner.run(session, productId);
  } catch (error, stackTrace) {
    session.log(
      'Background Tripo generation crashed for product $productId: $error',
      level: LogLevel.error,
      exception: error,
      stackTrace: stackTrace,
    );
    try {
      final product = await Product.db.findById(session, productId);
      if (product != null &&
          product.model3dStatus == ProductModel3dStatus.building) {
        await Product.db.updateRow(
          session,
          product.copyWith(
            model3dStatus: ProductModel3dStatus.failed,
            model3dError: error.toString(),
            updatedAt: DateTime.now(),
          ),
        );
      }
    } catch (_) {
      // Best-effort status update only.
    }
  } finally {
    await session.close();
  }
}

/// Shared Tripo + notify logic used by the background runner and FutureCall.
abstract final class Product3dGenerationRunner {
  static Future<void> run(Session session, int productId) async {
    final product = await Product.db.findById(session, productId);
    if (product == null || product.isDeleted) {
      session.log(
        'Product3dGenerationRunner product $productId missing/deleted',
        level: LogLevel.warning,
      );
      return;
    }

    session.log(
      'Product3dGenerationRunner starting Tripo for product $productId',
      level: LogLevel.info,
    );

    final generator = Product3dGenerator();
    final result = await generator.generateForProduct(
      session,
      product: product,
    );

    if (result is Product3dGenerationSuccess) {
      final updated = await Product.db.updateRow(
        session,
        product.copyWith(
          model3dUrl: result.modelUrl,
          model3dStatus: ProductModel3dStatus.ready,
          model3dError: null,
          updatedAt: DateTime.now(),
        ),
      );
      await _notifyVendor(
        session,
        product: updated,
        title: '3D model ready',
        message:
            '${updated.name} is ready for AR. Customers can try it in their room.',
      );
      session.log(
        'Product3dGenerationRunner ready for product $productId',
        level: LogLevel.info,
      );
      return;
    }

    if (result is Product3dGenerationFailure) {
      await Product.db.updateRow(
        session,
        product.copyWith(
          model3dStatus: ProductModel3dStatus.failed,
          model3dError: result.message,
          updatedAt: DateTime.now(),
        ),
      );
      await _notifyVendor(
        session,
        product: product,
        title: '3D model failed',
        message: '${product.name}: ${result.message}',
      );
      session.log(
        'Product3dGenerationRunner failed for product $productId: '
        '${result.code} ${result.message}',
        level: LogLevel.warning,
      );
    }
  }

  static Future<void> _notifyVendor(
    Session session, {
    required Product product,
    required String title,
    required String message,
  }) async {
    final notifications = InAppNotificationStore();
    final userId = await notifications.vendorUserId(session, product.vendorId);
    if (userId == null) return;

    await notifications.create(
      session,
      userId: userId,
      title: title,
      message: message,
      type: InAppNotificationType.productUpdate,
      referenceId: product.id,
    );
  }
}

/// Serverpod FutureCall wrapper — kept for codegen registration compatibility.
class Product3dGenerationFutureCall
    extends FutureCall<Product3dGenerationTrigger> {
  @override
  Future<void> invoke(
    Session session,
    Product3dGenerationTrigger? object,
  ) async {
    final productId = object?.productId;
    if (productId == null) {
      session.log(
        'Product3dGenerationFutureCall missing productId',
        level: LogLevel.warning,
      );
      return;
    }
    await Product3dGenerationRunner.run(session, productId);
  }
}
