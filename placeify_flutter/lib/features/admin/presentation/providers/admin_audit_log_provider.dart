import 'package:placeify_flutter/features/admin/domain/models/admin_audit_log_entry.dart';
import 'package:placeify_flutter/features/admin/presentation/providers/admin_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'admin_audit_log_provider.g.dart';

@riverpod
class AdminAuditLog extends _$AdminAuditLog {
  @override
  Future<List<AdminAuditLogEntry>> build() => _load();

  Future<void> refresh() async {
    state = await AsyncValue.guard(_load);
  }

  Future<List<AdminAuditLogEntry>> _load() async {
    final repo = await ref.watch(adminRepositoryProvider.future);
    return repo.getAuditLog();
  }
}
