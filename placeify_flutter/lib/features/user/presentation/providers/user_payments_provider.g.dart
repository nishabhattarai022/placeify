// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_payments_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(UserPayments)
final userPaymentsProvider = UserPaymentsProvider._();

final class UserPaymentsProvider
    extends $AsyncNotifierProvider<UserPayments, List<UserPaymentRecord>> {
  UserPaymentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userPaymentsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userPaymentsHash();

  @$internal
  @override
  UserPayments create() => UserPayments();
}

String _$userPaymentsHash() => r'bc617c441f32011786f704c3e1ef86d55859a4e8';

abstract class _$UserPayments extends $AsyncNotifier<List<UserPaymentRecord>> {
  FutureOr<List<UserPaymentRecord>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<UserPaymentRecord>>,
              List<UserPaymentRecord>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<UserPaymentRecord>>,
                List<UserPaymentRecord>
              >,
              AsyncValue<List<UserPaymentRecord>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
