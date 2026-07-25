import 'dart:async';

import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/features/messaging/data/serverpod_messaging_repository.dart';
import 'package:placeify_flutter/features/messaging/domain/repositories/messaging_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'messaging_providers.g.dart';

@Riverpod(keepAlive: true)
MessagingRepository messagingRepository(Ref ref) {
  return const ServerpodMessagingRepository();
}

@riverpod
class ConversationInbox extends _$ConversationInbox {
  StreamSubscription<ConversationSummary>? _sub;
  bool _asVendor = false;

  @override
  Future<List<ConversationSummary>> build({required bool asVendor}) async {
    _asVendor = asVendor;
    ref.onDispose(() => _sub?.cancel());
    unawaited(_attachInboxStream());
    final page = await ref
        .watch(messagingRepositoryProvider)
        .listConversations(asVendor: asVendor);
    return page.items;
  }

  Future<void> _attachInboxStream() async {
    await ensurePlaceifyRealtime();
    await _sub?.cancel();
    _sub = ref.read(messagingRepositoryProvider).watchInbox().listen(
      (summary) {
        final current = state.asData?.value;
        if (current == null) {
          ref.invalidateSelf();
          return;
        }
        final next = [
          summary,
          ...current.where((c) => c.id != summary.id),
        ];
        state = AsyncData(next);
        ref.invalidate(messagingUnreadCountProvider(asVendor: _asVendor));
      },
      onError: (_) {
        // Stream reconnect is handled at the client layer for notifications;
        // inbox will refresh on next open / pull-to-refresh.
      },
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final page = await ref
          .read(messagingRepositoryProvider)
          .listConversations(asVendor: _asVendor);
      return page.items;
    });
  }

  Future<void> deleteConversation(String conversationId) async {
    await ref
        .read(messagingRepositoryProvider)
        .deleteConversation(conversationId);
    final current = state.asData?.value ?? const <ConversationSummary>[];
    state = AsyncData(
      current.where((c) => c.id.uuid != conversationId).toList(),
    );
    ref.invalidate(messagingUnreadCountProvider(asVendor: _asVendor));
  }
}

@riverpod
class MessagingUnreadCount extends _$MessagingUnreadCount {
  @override
  Future<int> build({required bool asVendor}) async {
    return ref
        .watch(messagingRepositoryProvider)
        .unreadTotal(asVendor: asVendor);
  }
}

@riverpod
class ChatThread extends _$ChatThread {
  StreamSubscription<ChatMessage>? _sub;

  @override
  Future<List<ChatMessage>> build(String conversationId) async {
    ref.onDispose(() => _sub?.cancel());
    final repo = ref.watch(messagingRepositoryProvider);
    unawaited(() async {
      await repo.markRead(conversationId);
      ref.invalidate(messagingUnreadCountProvider(asVendor: false));
      ref.invalidate(messagingUnreadCountProvider(asVendor: true));
      ref.invalidate(conversationInboxProvider(asVendor: false));
      ref.invalidate(conversationInboxProvider(asVendor: true));
    }());
    unawaited(_attachMessageStream(conversationId));

    final page = await repo.listMessages(conversationId: conversationId);
    return page.items;
  }

  Future<void> _attachMessageStream(String conversationId) async {
    await ensurePlaceifyRealtime();
    await _sub?.cancel();
    _sub = ref.read(messagingRepositoryProvider).watchMessages(conversationId).listen(
      (message) {
        final current = state.asData?.value ?? const <ChatMessage>[];
        if (current.any((m) => m.id == message.id)) return;
        state = AsyncData([...current, message]);
        unawaited(
          ref.read(messagingRepositoryProvider).markRead(conversationId),
        );
        ref.invalidate(conversationInboxProvider(asVendor: false));
        ref.invalidate(conversationInboxProvider(asVendor: true));
        ref.invalidate(messagingUnreadCountProvider(asVendor: false));
        ref.invalidate(messagingUnreadCountProvider(asVendor: true));
      },
    );
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    final message = await ref.read(messagingRepositoryProvider).sendMessage(
          conversationId: conversationId,
          message: trimmed,
        );

    final current = state.asData?.value ?? const <ChatMessage>[];
    if (!current.any((m) => m.id == message.id)) {
      state = AsyncData([...current, message]);
    }
    ref.invalidate(conversationInboxProvider(asVendor: false));
    ref.invalidate(conversationInboxProvider(asVendor: true));
    ref.invalidate(messagingUnreadCountProvider(asVendor: false));
    ref.invalidate(messagingUnreadCountProvider(asVendor: true));
  }

  Future<void> loadOlder() async {
    final current = state.asData?.value;
    if (current == null || current.isEmpty) return;

    // Page 2+ returns older windows; merge uniquely by id.
    final page = await ref.read(messagingRepositoryProvider).listMessages(
          conversationId: conversationId,
          page: 2,
        );
    if (page.items.isEmpty) return;

    final existingIds = current.map((m) => m.id).toSet();
    final older = page.items.where((m) => !existingIds.contains(m.id));
    state = AsyncData([...older, ...current]);
  }
}

@riverpod
Future<ConversationSummary> openVendorChat(Ref ref, String vendorId) async {
  final summary = await ref
      .read(messagingRepositoryProvider)
      .getOrCreateConversation(vendorId);
  ref.invalidate(conversationInboxProvider(asVendor: false));
  return summary;
}
