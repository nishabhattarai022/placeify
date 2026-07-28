import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/widgets/toast_overlay.dart';
import 'package:placeify_flutter/features/auth/presentation/providers/auth_provider.dart';
import 'package:placeify_flutter/features/messaging/presentation/providers/messaging_providers.dart';
import 'package:placeify_flutter/features/messaging/presentation/widgets/chat_input.dart';
import 'package:placeify_flutter/features/messaging/presentation/widgets/date_divider.dart';
import 'package:placeify_flutter/features/messaging/presentation/widgets/message_bubble.dart';
import 'package:placeify_flutter/features/messaging/presentation/widgets/messaging_states.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({
    required this.conversationId,
    super.key,
    this.asVendor = false,
  });

  final String conversationId;
  final bool asVendor;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _scrollController = ScrollController();
  ConversationSummary? _header;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadHeader());
  }

  Future<void> _loadHeader() async {
    try {
      final summary = await ref
          .read(messagingRepositoryProvider)
          .getConversation(widget.conversationId);
      if (mounted) setState(() => _header = summary);
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
      );
    });
  }

  String _timeLabel(DateTime date) {
    final hour = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsync = ref.watch(chatThreadProvider(widget.conversationId));
    final myId = ref.watch(currentUserProvider).value?.id;
    final header = _header;

    ref.listen(chatThreadProvider(widget.conversationId), (prev, next) {
      next.whenData((_) => _scrollToBottom());
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5F1),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.cream,
              backgroundImage: header?.peerAvatarUrl != null &&
                      header!.peerAvatarUrl!.isNotEmpty
                  ? NetworkImage(header.peerAvatarUrl!)
                  : null,
              child: header?.peerAvatarUrl == null ||
                      header!.peerAvatarUrl!.isEmpty
                  ? Text(
                      (header?.peerName.isNotEmpty == true
                              ? header!.peerName[0]
                              : '?')
                          .toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.bark,
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                header?.peerName ?? 'Chat',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.espresso,
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
                  error: (_, __) => const MessagingEmptyState(
                title: 'Could not load chat',
                message: 'Please go back and try again.',
              ),
              data: (messages) {
                if (messages.isEmpty) {
                  return const MessagingEmptyState(
                    title: 'No messages.',
                    message:
                        'Send the first message to start the conversation.',
                  );
                }

                final items = <Widget>[];
                DateTime? lastDay;
                for (final message in messages) {
                  final day = DateTime(
                    message.createdAt.year,
                    message.createdAt.month,
                    message.createdAt.day,
                  );
                  if (lastDay == null || lastDay != day) {
                    items.add(
                      DateDivider(label: chatDayLabel(message.createdAt)),
                    );
                    lastDay = day;
                  }
                  final isMine =
                      myId != null && message.senderId.uuid == myId;
                  items.add(
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: MessageBubble(
                        text: message.message,
                        isMine: isMine,
                        timeLabel: _timeLabel(message.createdAt),
                        isRead: message.isRead,
                      ),
                    ),
                  );
                }

                return ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.only(bottom: 12, top: 8),
                  children: items,
                );
              },
            ),
          ),
          const TypingIndicator(visible: false),
          ChatInput(
            onSend: (text) async {
              try {
                await ref
                    .read(chatThreadProvider(widget.conversationId).notifier)
                    .send(text);
                if (!mounted) return;
                _scrollToBottom();
              } catch (e) {
                if (!mounted) return;
                final message = switch (e) {
                  PlaceifyException(:final message) => message,
                  _ => 'Could not send message. Please try again.',
                };
                PlaceifyToast.show(this.context, message);
              }
            },
          ),
        ],
      ),
    );
  }
}
