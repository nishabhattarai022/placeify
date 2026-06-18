// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_audit_log_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AdminAuditLog)
final adminAuditLogProvider = AdminAuditLogProvider._();

final class AdminAuditLogProvider
    extends $AsyncNotifierProvider<AdminAuditLog, List<AdminAuditLogEntry>> {
  AdminAuditLogProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'adminAuditLogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$adminAuditLogHash();

  @$internal
  @override
  AdminAuditLog create() => AdminAuditLog();
}

String _$adminAuditLogHash() => r'e0ff3d37ae8491103d17aed392b01a7bca349b1a';

abstract class _$AdminAuditLog
    extends $AsyncNotifier<List<AdminAuditLogEntry>> {
  FutureOr<List<AdminAuditLogEntry>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<AdminAuditLogEntry>>,
              List<AdminAuditLogEntry>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<AdminAuditLogEntry>>,
                List<AdminAuditLogEntry>
              >,
              AsyncValue<List<AdminAuditLogEntry>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
