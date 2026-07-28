// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messaging_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(messagingRepository)
final messagingRepositoryProvider = MessagingRepositoryProvider._();

final class MessagingRepositoryProvider
    extends
        $FunctionalProvider<
          MessagingRepository,
          MessagingRepository,
          MessagingRepository
        >
    with $Provider<MessagingRepository> {
  MessagingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'messagingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$messagingRepositoryHash();

  @$internal
  @override
  $ProviderElement<MessagingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MessagingRepository create(Ref ref) {
    return messagingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MessagingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MessagingRepository>(value),
    );
  }
}

String _$messagingRepositoryHash() =>
    r'3928f8a79f70dc8e7f3b76de62a9f0e0923bb563';

@ProviderFor(ConversationInbox)
final conversationInboxProvider = ConversationInboxFamily._();

final class ConversationInboxProvider
    extends
        $AsyncNotifierProvider<ConversationInbox, List<ConversationSummary>> {
  ConversationInboxProvider._({
    required ConversationInboxFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'conversationInboxProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$conversationInboxHash();

  @override
  String toString() {
    return r'conversationInboxProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ConversationInbox create() => ConversationInbox();

  @override
  bool operator ==(Object other) {
    return other is ConversationInboxProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$conversationInboxHash() => r'44a6942333b87aacca43c0c9e983f643bf1b3950';

final class ConversationInboxFamily extends $Family
    with
        $ClassFamilyOverride<
          ConversationInbox,
          AsyncValue<List<ConversationSummary>>,
          List<ConversationSummary>,
          FutureOr<List<ConversationSummary>>,
          bool
        > {
  ConversationInboxFamily._()
    : super(
        retry: null,
        name: r'conversationInboxProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ConversationInboxProvider call({required bool asVendor}) =>
      ConversationInboxProvider._(argument: asVendor, from: this);

  @override
  String toString() => r'conversationInboxProvider';
}

abstract class _$ConversationInbox
    extends $AsyncNotifier<List<ConversationSummary>> {
  late final _$args = ref.$arg as bool;
  bool get asVendor => _$args;

  FutureOr<List<ConversationSummary>> build({required bool asVendor});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<ConversationSummary>>,
              List<ConversationSummary>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<ConversationSummary>>,
                List<ConversationSummary>
              >,
              AsyncValue<List<ConversationSummary>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(asVendor: _$args));
  }
}

@ProviderFor(MessagingUnreadCount)
final messagingUnreadCountProvider = MessagingUnreadCountFamily._();

final class MessagingUnreadCountProvider
    extends $AsyncNotifierProvider<MessagingUnreadCount, int> {
  MessagingUnreadCountProvider._({
    required MessagingUnreadCountFamily super.from,
    required bool super.argument,
  }) : super(
         retry: null,
         name: r'messagingUnreadCountProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$messagingUnreadCountHash();

  @override
  String toString() {
    return r'messagingUnreadCountProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  MessagingUnreadCount create() => MessagingUnreadCount();

  @override
  bool operator ==(Object other) {
    return other is MessagingUnreadCountProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$messagingUnreadCountHash() =>
    r'b4a2adcec8a15d904eb3fc6bb0e0c85265ccb882';

final class MessagingUnreadCountFamily extends $Family
    with
        $ClassFamilyOverride<
          MessagingUnreadCount,
          AsyncValue<int>,
          int,
          FutureOr<int>,
          bool
        > {
  MessagingUnreadCountFamily._()
    : super(
        retry: null,
        name: r'messagingUnreadCountProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MessagingUnreadCountProvider call({required bool asVendor}) =>
      MessagingUnreadCountProvider._(argument: asVendor, from: this);

  @override
  String toString() => r'messagingUnreadCountProvider';
}

abstract class _$MessagingUnreadCount extends $AsyncNotifier<int> {
  late final _$args = ref.$arg as bool;
  bool get asVendor => _$args;

  FutureOr<int> build({required bool asVendor});
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(asVendor: _$args));
  }
}

@ProviderFor(ChatThread)
final chatThreadProvider = ChatThreadFamily._();

final class ChatThreadProvider
    extends $AsyncNotifierProvider<ChatThread, List<ChatMessage>> {
  ChatThreadProvider._({
    required ChatThreadFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'chatThreadProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$chatThreadHash();

  @override
  String toString() {
    return r'chatThreadProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ChatThread create() => ChatThread();

  @override
  bool operator ==(Object other) {
    return other is ChatThreadProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$chatThreadHash() => r'9573be3aee1691c0112cfd32bc51ddc5aba020cb';

final class ChatThreadFamily extends $Family
    with
        $ClassFamilyOverride<
          ChatThread,
          AsyncValue<List<ChatMessage>>,
          List<ChatMessage>,
          FutureOr<List<ChatMessage>>,
          String
        > {
  ChatThreadFamily._()
    : super(
        retry: null,
        name: r'chatThreadProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ChatThreadProvider call(String conversationId) =>
      ChatThreadProvider._(argument: conversationId, from: this);

  @override
  String toString() => r'chatThreadProvider';
}

abstract class _$ChatThread extends $AsyncNotifier<List<ChatMessage>> {
  late final _$args = ref.$arg as String;
  String get conversationId => _$args;

  FutureOr<List<ChatMessage>> build(String conversationId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ChatMessage>>, List<ChatMessage>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ChatMessage>>, List<ChatMessage>>,
              AsyncValue<List<ChatMessage>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}

@ProviderFor(openVendorChat)
final openVendorChatProvider = OpenVendorChatFamily._();

final class OpenVendorChatProvider
    extends
        $FunctionalProvider<
          AsyncValue<ConversationSummary>,
          ConversationSummary,
          FutureOr<ConversationSummary>
        >
    with
        $FutureModifier<ConversationSummary>,
        $FutureProvider<ConversationSummary> {
  OpenVendorChatProvider._({
    required OpenVendorChatFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'openVendorChatProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$openVendorChatHash();

  @override
  String toString() {
    return r'openVendorChatProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ConversationSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ConversationSummary> create(Ref ref) {
    final argument = this.argument as String;
    return openVendorChat(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenVendorChatProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$openVendorChatHash() => r'9ff0d4f91b3bcf7544196ee15f72ce9fd86f6d1b';

final class OpenVendorChatFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ConversationSummary>, String> {
  OpenVendorChatFamily._()
    : super(
        retry: null,
        name: r'openVendorChatProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  OpenVendorChatProvider call(String vendorId) =>
      OpenVendorChatProvider._(argument: vendorId, from: this);

  @override
  String toString() => r'openVendorChatProvider';
}
