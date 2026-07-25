import 'package:flutter/material.dart';
import 'package:placeify_flutter/core/constants/app_colors.dart';
import 'package:placeify_flutter/core/utils/relative_time.dart';
import 'package:placeify_flutter/features/messaging/presentation/widgets/unread_badge.dart';
import 'package:placeify_client/placeify_client.dart';

class ConversationTile extends StatelessWidget {
  const ConversationTile({
    required this.conversation,
    required this.onTap,
    super.key,
  });

  final ConversationSummary conversation;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final initial = conversation.peerName.isNotEmpty
        ? conversation.peerName.characters.first.toUpperCase()
        : '?';
    final time = conversation.lastMessageTime != null
        ? RelativeTime.format(conversation.lastMessageTime!)
        : '';

    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.cream,
                backgroundImage: conversation.peerAvatarUrl != null &&
                        conversation.peerAvatarUrl!.isNotEmpty
                    ? NetworkImage(conversation.peerAvatarUrl!)
                    : null,
                child: conversation.peerAvatarUrl == null ||
                        conversation.peerAvatarUrl!.isEmpty
                    ? Text(
                        initial,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.bark,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.peerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.espresso,
                            ),
                          ),
                        ),
                        if (time.isNotEmpty)
                          Text(
                            time,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textMuted,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            conversation.lastMessage?.trim().isNotEmpty == true
                                ? conversation.lastMessage!
                                : 'No messages yet',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              color: conversation.unreadCount > 0
                                  ? AppColors.espresso
                                  : AppColors.textMuted,
                              fontWeight: conversation.unreadCount > 0
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        UnreadBadge(count: conversation.unreadCount),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
