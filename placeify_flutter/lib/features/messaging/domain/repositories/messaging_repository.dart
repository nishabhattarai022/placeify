import 'package:placeify_client/placeify_client.dart';

abstract class MessagingRepository {
  Future<ConversationSummary> getOrCreateConversation(String vendorId);

  Future<ConversationPage> listConversations({
    required bool asVendor,
    int page = 1,
    int pageSize = 30,
  });

  Future<ConversationSummary> getConversation(String conversationId);

  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String message,
  });

  Future<ChatMessagePage> listMessages({
    required String conversationId,
    int page = 1,
    int pageSize = 40,
  });

  Future<void> markRead(String conversationId);

  Future<void> deleteConversation(String conversationId);

  Future<int> unreadTotal({required bool asVendor});

  Stream<ChatMessage> watchMessages(String conversationId);

  Stream<ConversationSummary> watchInbox();
}
