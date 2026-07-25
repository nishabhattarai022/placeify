import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'messaging_service.dart';

/// Customer ↔ vendor direct messaging.
class MessagingEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  final _service = MessagingService();

  /// Creates or returns the conversation between the signed-in customer and [vendorId].
  Future<ConversationSummary> getOrCreateConversation(
    Session session,
    UuidValue vendorId,
  ) {
    return _service.getOrCreateConversation(session, vendorId: vendorId);
  }

  /// Lists inbox conversations. Set [asVendor] true for the shop inbox.
  Future<ConversationPage> listConversations(
    Session session, {
    bool asVendor = false,
    PaginationInput? pagination,
  }) {
    return _service.listConversations(
      session,
      asVendor: asVendor,
      pagination: pagination,
    );
  }

  Future<ConversationSummary> getConversation(
    Session session,
    UuidValue conversationId,
  ) {
    return _service.getConversation(session, conversationId);
  }

  Future<ChatMessage> sendMessage(
    Session session, {
    required UuidValue conversationId,
    required String message,
    ChatMessageType messageType = ChatMessageType.text,
  }) {
    return _service.sendMessage(
      session,
      conversationId: conversationId,
      message: message,
      messageType: messageType,
    );
  }

  Future<ChatMessagePage> listMessages(
    Session session, {
    required UuidValue conversationId,
    PaginationInput? pagination,
  }) {
    return _service.listMessages(
      session,
      conversationId: conversationId,
      pagination: pagination,
    );
  }

  Future<void> markRead(Session session, UuidValue conversationId) {
    return _service.markRead(session, conversationId);
  }

  Future<void> deleteConversation(Session session, UuidValue conversationId) {
    return _service.deleteConversation(session, conversationId);
  }

  Future<int> unreadTotal(Session session, {bool asVendor = false}) {
    return _service.unreadTotal(session, asVendor: asVendor);
  }

  /// Live messages for an open conversation thread.
  Stream<ChatMessage> watchMessages(
    Session session,
    UuidValue conversationId,
  ) {
    return _service.watchMessages(session, conversationId);
  }

  /// Live inbox updates for the signed-in user.
  Stream<ConversationSummary> watchInbox(Session session) {
    return _service.watchInbox(session);
  }
}
