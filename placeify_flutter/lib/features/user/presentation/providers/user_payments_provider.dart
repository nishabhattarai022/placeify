import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';

import '../../../../core/config/placeify_server_client.dart';
import '../../data/user_payment_mappers.dart';
import '../../domain/models/user_payment_record.dart';

part 'user_payments_provider.g.dart';

@Riverpod(keepAlive: true)
class UserPayments extends _$UserPayments {
  static const _pageSize = 100;

  @override
  Future<List<UserPaymentRecord>> build() async {
    if (!client.auth.isAuthenticated) return [];
    return _load();
  }

  Future<void> refresh({bool silent = false}) async {
    if (!client.auth.isAuthenticated) {
      state = const AsyncData([]);
      return;
    }
    if (!silent) {
      state = const AsyncLoading();
    }
    state = await AsyncValue.guard(_load);
  }

  Future<List<UserPaymentRecord>> _load() async {
    final summaries = await client.user.listMyPayments(
      limit: _pageSize,
      offset: 0,
    );
    final records = <UserPaymentRecord>[];
    for (final summary in summaries) {
      records.add(await UserPaymentMappers.toRecord(summary));
    }
    records.sort((a, b) {
      final aDate = a.paymentDate ??
          a.orderDate ??
          DateTime.fromMillisecondsSinceEpoch(0);
      final bDate = b.paymentDate ??
          b.orderDate ??
          DateTime.fromMillisecondsSinceEpoch(0);
      return bDate.compareTo(aDate);
    });
    return records;
  }
}
