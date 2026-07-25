import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/features/admin/data/serverpod_admin_api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_refunds_provider.g.dart';

@riverpod
class AdminRefundsList extends _$AdminRefundsList {
  final _api = const ServerpodAdminApi();

  @override
  Future<List<AdminRefundRequestSummary>> build() {
    return _api.listRefundRequests();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(_api.listRefundRequests);
  }

  Future<void> approve(int refundId) async {
    await _api.approveRefundRequest(refundId);
    await refresh();
  }

  Future<void> reject(int refundId) async {
    await _api.rejectRefundRequest(refundId);
    await refresh();
  }

  Future<void> checkEsewaStatus(int refundId) async {
    await _api.checkEsewaRefundStatus(refundId);
    await refresh();
  }

  Future<void> retryEsewaStatus(int refundId) async {
    await _api.retryEsewaRefundStatusCheck(refundId);
    await refresh();
  }

  Future<void> completeManualSettlement(int refundId) async {
    await _api.completeManualEsewaSettlement(refundId);
    await refresh();
  }
}
