import 'package:placeify_client/placeify_client.dart';
import 'package:placeify_flutter/core/config/placeify_server_client.dart';
import 'package:placeify_flutter/features/messaging/domain/repositories/messaging_repository.dart';

class ServerpodMessagingRepository implements MessagingRepository {
  const ServerpodMessagingRepository();

  @override
  Future<ConversationSummary> getOrCreateConversation(String vendorId) {
    return client.messaging.getOrCreateConversation(
      UuidValue.fromString(vendorId),
    );
  }

  @override
  Future<ConversationPage> listConversations({
    required bool asVendor,
    int page = 1,
    int pageSize = 30,
  }) {
    return client.messaging.listConversations(
      asVendor: asVendor,
      pagination: PaginationInput(page: page, pageSize: pageSize),
    );
  }

  @override
  Future<ConversationSummary> getConversation(String conversationId) {
    return client.messaging.getConversation(
      UuidValue.fromString(conversationId),
    );
  }

  @override
  Future<ChatMessage> sendMessage({
    required String conversationId,
    required String message,
  }) {
    return client.messaging.sendMessage(
      conversationId: UuidValue.fromString(conversationId),
      message: message,
      messageType: ChatMessageType.text,
    );
  }

  @override
  Future<ChatMessagePage> listMessages({
    required String conversationId,
    int page = 1,
    int pageSize = 40,
  }) {
    return client.messaging.listMessages(
      conversationId: UuidValue.fromString(conversationId),
      pagination: PaginationInput(page: page, pageSize: pageSize),
    );
  }

  @override
  Future<void> markRead(String conversationId) {
    return client.messaging.markRead(UuidValue.fromString(conversationId));
  }

  @override
  Future<void> deleteConversation(String conversationId) {
    return client.messaging.deleteConversation(
      UuidValue.fromString(conversationId),
    );
  }

  @override
  Future<int> unreadTotal({required bool asVendor}) {
    return client.messaging.unreadTotal(asVendor: asVendor);
  }

  @override
  Stream<ChatMessage> watchMessages(String conversationId) {
    return client.messaging.watchMessages(
      UuidValue.fromString(conversationId),
    );
  }

  @override
  Stream<ConversationSummary> watchInbox() {
    return client.messaging.watchInbox();
  }
}
