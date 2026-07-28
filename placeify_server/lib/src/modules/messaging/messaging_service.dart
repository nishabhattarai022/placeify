import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import 'messaging_repository.dart';

class MessagingService {
  MessagingService({MessagingRepository? repository})
    : _repository = repository ?? MessagingRepository();

  final MessagingRepository _repository;

  Future<ConversationSummary> getOrCreateConversation(
    Session session, {
    required UuidValue vendorId,
  }) {
    return _repository.getOrCreateConversation(
      session,
      vendorId: vendorId,
    );
  }

  Future<ConversationPage> listConversations(
    Session session, {
    required bool asVendor,
    PaginationInput? pagination,
  }) {
    return _repository.listConversations(
      session,
      asVendor: asVendor,
      pagination: pagination,
    );
  }

  Future<ConversationSummary> getConversation(
    Session session,
    UuidValue conversationId,
  ) {
    return _repository.getConversation(session, conversationId);
  }

  Future<ChatMessage> sendMessage(
    Session session, {
    required UuidValue conversationId,
    required String message,
    ChatMessageType messageType = ChatMessageType.text,
  }) {
    return _repository.sendMessage(
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
    return _repository.listMessages(
      session,
      conversationId: conversationId,
      pagination: pagination,
    );
  }

  Future<void> markRead(Session session, UuidValue conversationId) {
    return _repository.markRead(session, conversationId);
  }

  Future<void> deleteConversation(Session session, UuidValue conversationId) {
    return _repository.deleteConversation(session, conversationId);
  }

  Stream<ChatMessage> watchMessages(
    Session session,
    UuidValue conversationId,
  ) {
    return _repository.watchMessages(session, conversationId);
  }

  Stream<ConversationSummary> watchInbox(Session session) {
    return _repository.watchInbox(session);
  }

  Future<int> unreadTotal(Session session, {required bool asVendor}) {
    return _repository.unreadTotal(session, asVendor: asVendor);
  }
}
