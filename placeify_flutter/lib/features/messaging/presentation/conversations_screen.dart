import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/services/haptic_service.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/messaging/domain/constants/messaging_routes.dart';
import 'package:placeify_flutter/features/messaging/presentation/providers/messaging_providers.dart';
import 'package:placeify_flutter/features/messaging/presentation/widgets/conversation_tile.dart';
import 'package:placeify_flutter/features/messaging/presentation/widgets/messaging_states.dart';

class ConversationsScreen extends ConsumerWidget {
  const ConversationsScreen({
    super.key,
    this.asVendor = false,
  });

  final bool asVendor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inboxAsync = ref.watch(conversationInboxProvider(asVendor: asVendor));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F5F1),
        elevation: 0,
        title: Text(
          asVendor ? 'Inbox' : 'Messages',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.espresso,
          ),
        ),
      ),
      body: inboxAsync.when(
        loading: () => const MessagingSkeleton(),
        error: (_, __) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const MessagingEmptyState(
                title: 'Could not load messages',
                message: 'Pull to retry or check your connection.',
              ),
              TextButton(
                onPressed: () => ref
                    .read(
                      conversationInboxProvider(asVendor: asVendor).notifier,
                    )
                    .refresh(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (items) {
          if (items.isEmpty) {
            return RefreshIndicator(
              color: AppColors.adminSlate,
              onRefresh: () => ref
                  .read(conversationInboxProvider(asVendor: asVendor).notifier)
                  .refresh(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 120),
                  MessagingEmptyState(
                    title: 'No messages.',
                    message:
                        'Start a chat from a product, shop, or order to talk with a vendor.',
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            color: AppColors.adminSlate,
            onRefresh: () => ref
                .read(conversationInboxProvider(asVendor: asVendor).notifier)
                .refresh(),
            child: ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              itemCount: items.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                indent: 76,
                color: Colors.black.withValues(alpha: 0.05),
              ),
              itemBuilder: (context, index) {
                final conversation = items[index];
                return Dismissible(
                  key: ValueKey(conversation.id.uuid),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: AppColors.coral,
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  confirmDismiss: (_) async {
                    return true;
                  },
                  onDismissed: (_) async {
                    await ref
                        .read(
                          conversationInboxProvider(asVendor: asVendor)
                              .notifier,
                        )
                        .deleteConversation(conversation.id.uuid);
                  },
                  child: ConversationTile(
                    conversation: conversation,
                    onTap: () {
                      HapticService.light();
                      final path = asVendor
                          ? MessagingRoutes.vendorChat(conversation.id.uuid)
                          : MessagingRoutes.chat(conversation.id.uuid);
                      context.push(path);
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

/// Opens (or creates) a customer→vendor conversation and navigates to chat.
Future<void> openChatWithVendor(
  BuildContext context,
  WidgetRef ref,
  String vendorId,
) async {
  HapticService.light();
  final trimmed = vendorId.trim();
  if (trimmed.isEmpty || trimmed == '0') {
    PlaceifyToast.show(context, 'Vendor unavailable for chat.');
    return;
  }

  try {
    // Call the repository directly so a previous failed open does not stick.
    ref.invalidate(openVendorChatProvider(trimmed));
    final summary = await ref
        .read(messagingRepositoryProvider)
        .getOrCreateConversation(trimmed);
    ref.invalidate(conversationInboxProvider(asVendor: false));
    if (!context.mounted) return;
    context.push(MessagingRoutes.chat(summary.id.uuid));
  } catch (e) {
    if (!context.mounted) return;
    final message = switch (e) {
      PlaceifyException(:final message) => message,
      FormatException() => 'Invalid shop id for chat.',
      _ => 'Could not open chat. Please try again.',
    };
    PlaceifyToast.show(context, message);
  }
}
