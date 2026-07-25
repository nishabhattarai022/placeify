import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../shared/pagination_helper.dart';
import '../../shared/session_service.dart';
import '../notification/in_app_notification_store.dart';

/// Persistence and authorization for customer ↔ vendor chat.
class MessagingRepository {
  MessagingRepository({InAppNotificationStore? notifications})
    : _notifications = notifications ?? InAppNotificationStore();

  final InAppNotificationStore _notifications;

  static String conversationChannel(UuidValue conversationId) =>
      'chat_conv_$conversationId';

  static String userInboxChannel(UuidValue userId) => 'chat_inbox_$userId';

  Future<Vendor> _requireVendor(Session session, UuidValue vendorId) async {
    final vendor = await Vendor.db.findById(session, vendorId);
    if (vendor == null) {
      throw PlaceifyException(
        message: 'Shop not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }
    return vendor;
  }

  Future<Vendor?> _vendorForUser(Session session, UuidValue userId) {
    return Vendor.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(userId),
    );
  }

  Future<({Conversation conversation, bool isCustomer})> _requireAccess(
    Session session, {
    required User user,
    required UuidValue conversationId,
  }) async {
    final conversation = await Conversation.db.findById(
      session,
      conversationId,
    );
    if (conversation == null) {
      throw PlaceifyException(
        message: 'Conversation not found.',
        code: 'CONVERSATION_NOT_FOUND',
      );
    }

    final vendor = await _vendorForUser(session, user.id!);
    final isCustomer = conversation.customerId == user.id;
    final isVendorOwner = vendor != null && conversation.vendorId == vendor.id;

    if (!isCustomer && !isVendorOwner) {
      throw PlaceifyException(
        message: 'You do not have access to this conversation.',
        code: 'FORBIDDEN',
      );
    }

    if (isCustomer && conversation.customerDeletedAt != null) {
      throw PlaceifyException(
        message: 'Conversation not found.',
        code: 'CONVERSATION_NOT_FOUND',
      );
    }
    if (isVendorOwner && conversation.vendorDeletedAt != null) {
      throw PlaceifyException(
        message: 'Conversation not found.',
        code: 'CONVERSATION_NOT_FOUND',
      );
    }

    return (conversation: conversation, isCustomer: isCustomer);
  }

  Future<ConversationSummary> _toSummary(
    Session session,
    Conversation conversation, {
    required bool viewerIsCustomer,
  }) async {
    late final UuidValue peerUserId;
    late final String peerName;
    String? peerAvatarUrl;

    if (viewerIsCustomer) {
      final vendor = await Vendor.db.findById(session, conversation.vendorId);
      if (vendor == null) {
        throw PlaceifyException(
          message: 'Shop not found.',
          code: 'VENDOR_NOT_FOUND',
        );
      }
      peerUserId = vendor.userId;
      peerName = vendor.shopName;
      peerAvatarUrl = vendor.logoUrl;
      if (peerAvatarUrl == null || peerAvatarUrl.isEmpty) {
        final owner = await User.db.findById(session, vendor.userId);
        peerAvatarUrl = owner?.profileImageUrl;
      }
    } else {
      final customer = await User.db.findById(session, conversation.customerId);
      if (customer == null) {
        throw PlaceifyException(
          message: 'Customer not found.',
          code: 'USER_NOT_FOUND',
        );
      }
      peerUserId = customer.id!;
      peerName = customer.name;
      peerAvatarUrl = customer.profileImageUrl;
    }

    return ConversationSummary(
      id: conversation.id!,
      customerId: conversation.customerId,
      vendorId: conversation.vendorId,
      peerUserId: peerUserId,
      peerName: peerName,
      peerAvatarUrl: peerAvatarUrl,
      lastMessage: conversation.lastMessage,
      lastMessageTime: conversation.lastMessageTime,
      lastSenderId: conversation.lastSenderId,
      unreadCount: viewerIsCustomer
          ? conversation.unreadCustomerCount
          : conversation.unreadVendorCount,
      createdAt: conversation.createdAt,
      updatedAt: conversation.updatedAt,
    );
  }

  Future<void> _broadcastMessage(Session session, ChatMessage message) async {
    final useRedis = session.serverpod.redisController != null;
    await session.messages.postMessage(
      conversationChannel(message.conversationId),
      message,
      global: useRedis,
    );
  }

  Future<void> _broadcastInbox(
    Session session, {
    required UuidValue userId,
    required ConversationSummary summary,
  }) async {
    final useRedis = session.serverpod.redisController != null;
    await session.messages.postMessage(
      userInboxChannel(userId),
      summary,
      global: useRedis,
    );
  }

  Future<ConversationSummary> getOrCreateConversation(
    Session session, {
    required UuidValue vendorId,
  }) async {
    final user = await SessionService.requireUser(session);
    if (user.role == UserRole.admin) {
      throw PlaceifyException(
        message: 'Admins cannot start marketplace chats.',
        code: 'FORBIDDEN',
      );
    }

    final vendor = await _requireVendor(session, vendorId);
    if (vendor.userId == user.id) {
      throw PlaceifyException(
        message: 'You cannot message your own shop.',
        code: 'INVALID_CONVERSATION',
      );
    }

    final existing = await Conversation.db.findFirstRow(
      session,
      where: (row) =>
          row.customerId.equals(user.id!) & row.vendorId.equals(vendorId),
    );

    if (existing != null) {
      var conversation = existing;
      if (conversation.customerDeletedAt != null) {
        conversation = await Conversation.db.updateRow(
          session,
          conversation.copyWith(
            customerDeletedAt: null,
            updatedAt: DateTime.now(),
          ),
        );
      }
      return _toSummary(session, conversation, viewerIsCustomer: true);
    }

    final now = DateTime.now();
    final created = await Conversation.db.insertRow(
      session,
      Conversation(
        customerId: user.id!,
        vendorId: vendorId,
        createdAt: now,
        updatedAt: now,
      ),
    );

    return _toSummary(session, created, viewerIsCustomer: true);
  }

  Future<ConversationPage> listConversations(
    Session session, {
    required bool asVendor,
    PaginationInput? pagination,
  }) async {
    final user = await SessionService.requireUser(session);
    final pageInfo = PaginationHelper.resolve(pagination);
    final page = pageInfo.page;
    final pageSize = pageInfo.pageSize;
    final offset = pageInfo.offset;

    late final Expression where;
    late final bool viewerIsCustomer;

    if (asVendor) {
      final vendor = await _vendorForUser(session, user.id!);
      if (vendor == null) {
        throw PlaceifyException(
          message: 'Vendor shop not found.',
          code: 'VENDOR_NOT_FOUND',
        );
      }
      where =
          Conversation.t.vendorId.equals(vendor.id!) &
          Conversation.t.vendorDeletedAt.equals(null);
      viewerIsCustomer = false;
    } else {
      where =
          Conversation.t.customerId.equals(user.id!) &
          Conversation.t.customerDeletedAt.equals(null);
      viewerIsCustomer = true;
    }

    final total = await Conversation.db.count(session, where: (_) => where);
    final rows = await Conversation.db.find(
      session,
      where: (_) => where,
      orderBy: (row) => row.updatedAt,
      orderDescending: true,
      limit: pageSize,
      offset: offset,
    );

    rows.sort((a, b) {
      final aTime = a.lastMessageTime ?? a.updatedAt;
      final bTime = b.lastMessageTime ?? b.updatedAt;
      return bTime.compareTo(aTime);
    });

    final items = <ConversationSummary>[];
    for (final row in rows) {
      items.add(
        await _toSummary(session, row, viewerIsCustomer: viewerIsCustomer),
      );
    }

    return ConversationPage(
      items: items,
      totalCount: total,
      page: page,
      pageSize: pageSize,
      hasMore: offset + rows.length < total,
    );
  }

  Future<ConversationSummary> getConversation(
    Session session,
    UuidValue conversationId,
  ) async {
    final user = await SessionService.requireUser(session);
    final access = await _requireAccess(
      session,
      user: user,
      conversationId: conversationId,
    );
    return _toSummary(
      session,
      access.conversation,
      viewerIsCustomer: access.isCustomer,
    );
  }

  Future<ChatMessage> sendMessage(
    Session session, {
    required UuidValue conversationId,
    required String message,
    ChatMessageType messageType = ChatMessageType.text,
  }) async {
    final user = await SessionService.requireUser(session);
    final trimmed = message.trim();
    if (trimmed.isEmpty) {
      throw PlaceifyException(
        message: 'Message cannot be empty.',
        code: 'INVALID_MESSAGE',
      );
    }
    if (trimmed.length > 4000) {
      throw PlaceifyException(
        message: 'Message is too long.',
        code: 'INVALID_MESSAGE',
      );
    }
    if (messageType != ChatMessageType.text) {
      throw PlaceifyException(
        message: 'Only text messages are supported right now.',
        code: 'UNSUPPORTED_MESSAGE_TYPE',
      );
    }

    final access = await _requireAccess(
      session,
      user: user,
      conversationId: conversationId,
    );
    final conversation = access.conversation;
    final isCustomer = access.isCustomer;

    final vendor = await Vendor.db.findById(session, conversation.vendorId);
    if (vendor == null) {
      throw PlaceifyException(
        message: 'Shop not found.',
        code: 'VENDOR_NOT_FOUND',
      );
    }

    final receiverId = isCustomer ? vendor.userId : conversation.customerId;
    final now = DateTime.now();

    final chatMessage = await ChatMessage.db.insertRow(
      session,
      ChatMessage(
        conversationId: conversationId,
        senderId: user.id!,
        receiverId: receiverId,
        message: trimmed,
        messageType: messageType,
        isRead: false,
        createdAt: now,
      ),
    );

    var updated = await Conversation.db.updateRow(
      session,
      conversation.copyWith(
        lastMessage: trimmed,
        lastMessageTime: now,
        lastSenderId: user.id!,
        updatedAt: now,
        customerDeletedAt: null,
        vendorDeletedAt: null,
        unreadCustomerCount: isCustomer
            ? 0
            : conversation.unreadCustomerCount + 1,
        unreadVendorCount: isCustomer ? conversation.unreadVendorCount + 1 : 0,
      ),
    );

    // Ensure soft-delete flags are cleared even if copyWith ignores nulls.
    if (updated.customerDeletedAt != null || updated.vendorDeletedAt != null) {
      updated = await Conversation.db.updateRow(
        session,
        Conversation(
          id: updated.id,
          customerId: updated.customerId,
          vendorId: updated.vendorId,
          lastMessage: updated.lastMessage,
          lastMessageTime: updated.lastMessageTime,
          lastSenderId: updated.lastSenderId,
          unreadCustomerCount: updated.unreadCustomerCount,
          unreadVendorCount: updated.unreadVendorCount,
          customerDeletedAt: null,
          vendorDeletedAt: null,
          createdAt: updated.createdAt,
          updatedAt: now,
        ),
      );
    }

    await _broadcastMessage(session, chatMessage);

    final customerSummary = await _toSummary(
      session,
      updated,
      viewerIsCustomer: true,
    );
    final vendorSummary = await _toSummary(
      session,
      updated,
      viewerIsCustomer: false,
    );
    await _broadcastInbox(
      session,
      userId: conversation.customerId,
      summary: customerSummary,
    );
    await _broadcastInbox(
      session,
      userId: vendor.userId,
      summary: vendorSummary,
    );

    await _notifyReceiver(
      session,
      receiverId: receiverId,
      senderName: isCustomer ? user.name : vendor.shopName,
      preview: trimmed,
      conversationId: conversationId,
    );

    return chatMessage;
  }

  Future<void> _notifyReceiver(
    Session session, {
    required UuidValue receiverId,
    required String senderName,
    required String preview,
    required UuidValue conversationId,
  }) async {
    final prefs = await NotificationPreference.db.findFirstRow(
      session,
      where: (row) => row.userId.equals(receiverId),
    );
    if (prefs != null && !prefs.vendorMessages) return;

    final previewText = preview.length > 120
        ? '${preview.substring(0, 117)}...'
        : preview;

    await _notifications.create(
      session,
      userId: receiverId,
      title: senderName,
      message: previewText,
      type: InAppNotificationType.chatMessage,
      referenceKey: conversationId.uuid,
    );
  }

  Future<ChatMessagePage> listMessages(
    Session session, {
    required UuidValue conversationId,
    PaginationInput? pagination,
  }) async {
    final user = await SessionService.requireUser(session);
    await _requireAccess(
      session,
      user: user,
      conversationId: conversationId,
    );

    final pageInfo = PaginationHelper.resolve(
      pagination ?? PaginationInput(page: 1, pageSize: 40),
    );
    final page = pageInfo.page;
    final pageSize = pageInfo.pageSize.clamp(1, 100);

    final where = ChatMessage.t.conversationId.equals(conversationId);
    final total = await ChatMessage.db.count(session, where: (_) => where);

    // Page 1 = newest window; higher pages = older history.
    final endExclusive = total - ((page - 1) * pageSize);
    final start = (endExclusive - pageSize).clamp(0, total);
    final limit = (endExclusive - start).clamp(0, pageSize);

    final items = limit == 0
        ? <ChatMessage>[]
        : await ChatMessage.db.find(
            session,
            where: (_) => where,
            orderBy: (row) => row.createdAt,
            orderDescending: false,
            limit: limit,
            offset: start,
          );

    return ChatMessagePage(
      items: items,
      totalCount: total,
      page: page,
      pageSize: pageSize,
      hasMore: start > 0,
    );
  }

  Future<void> markRead(
    Session session,
    UuidValue conversationId,
  ) async {
    final user = await SessionService.requireUser(session);
    final access = await _requireAccess(
      session,
      user: user,
      conversationId: conversationId,
    );
    final conversation = access.conversation;
    final isCustomer = access.isCustomer;

    await ChatMessage.db.updateWhere(
      session,
      where: (row) =>
          row.conversationId.equals(conversationId) &
          row.receiverId.equals(user.id!) &
          row.isRead.equals(false),
      columnValues: (row) => [row.isRead(true)],
    );

    var updated = conversation;
    if (isCustomer && conversation.unreadCustomerCount > 0) {
      updated = await Conversation.db.updateRow(
        session,
        conversation.copyWith(
          unreadCustomerCount: 0,
          updatedAt: DateTime.now(),
        ),
      );
    } else if (!isCustomer && conversation.unreadVendorCount > 0) {
      updated = await Conversation.db.updateRow(
        session,
        conversation.copyWith(
          unreadVendorCount: 0,
          updatedAt: DateTime.now(),
        ),
      );
    }

    final vendor = await Vendor.db.findById(session, conversation.vendorId);
    if (vendor == null) return;

    await _broadcastInbox(
      session,
      userId: conversation.customerId,
      summary: await _toSummary(session, updated, viewerIsCustomer: true),
    );
    await _broadcastInbox(
      session,
      userId: vendor.userId,
      summary: await _toSummary(session, updated, viewerIsCustomer: false),
    );
  }

  Future<void> deleteConversation(
    Session session,
    UuidValue conversationId,
  ) async {
    final user = await SessionService.requireUser(session);
    final conversation = await Conversation.db.findById(
      session,
      conversationId,
    );
    if (conversation == null) {
      throw PlaceifyException(
        message: 'Conversation not found.',
        code: 'CONVERSATION_NOT_FOUND',
      );
    }

    final vendor = await _vendorForUser(session, user.id!);
    final isCustomer = conversation.customerId == user.id;
    final isVendorOwner = vendor != null && conversation.vendorId == vendor.id;

    if (!isCustomer && !isVendorOwner) {
      throw PlaceifyException(
        message: 'You do not have access to this conversation.',
        code: 'FORBIDDEN',
      );
    }

    final now = DateTime.now();
    final updated = await Conversation.db.updateRow(
      session,
      conversation.copyWith(
        customerDeletedAt: isCustomer ? now : conversation.customerDeletedAt,
        vendorDeletedAt: isVendorOwner ? now : conversation.vendorDeletedAt,
        unreadCustomerCount: isCustomer ? 0 : conversation.unreadCustomerCount,
        unreadVendorCount: isVendorOwner ? 0 : conversation.unreadVendorCount,
        updatedAt: now,
      ),
    );

    if (updated.customerDeletedAt != null && updated.vendorDeletedAt != null) {
      await ChatMessage.db.deleteWhere(
        session,
        where: (row) => row.conversationId.equals(conversationId),
      );
      await Conversation.db.deleteRow(session, updated);
    }
  }

  Stream<ChatMessage> watchMessages(
    Session session,
    UuidValue conversationId,
  ) async* {
    final user = await SessionService.requireUser(session);
    await _requireAccess(
      session,
      user: user,
      conversationId: conversationId,
    );
    yield* session.messages.createStream<ChatMessage>(
      conversationChannel(conversationId),
    );
  }

  Stream<ConversationSummary> watchInbox(Session session) async* {
    final user = await SessionService.requireUser(session);
    yield* session.messages.createStream<ConversationSummary>(
      userInboxChannel(user.id!),
    );
  }

  Future<int> unreadTotal(Session session, {required bool asVendor}) async {
    final user = await SessionService.requireUser(session);
    if (asVendor) {
      final vendor = await _vendorForUser(session, user.id!);
      if (vendor == null) return 0;
      final rows = await Conversation.db.find(
        session,
        where: (row) =>
            row.vendorId.equals(vendor.id!) & row.vendorDeletedAt.equals(null),
      );
      return rows.fold<int>(0, (sum, row) => sum + row.unreadVendorCount);
    }

    final rows = await Conversation.db.find(
      session,
      where: (row) =>
          row.customerId.equals(user.id!) & row.customerDeletedAt.equals(null),
    );
    return rows.fold<int>(0, (sum, row) => sum + row.unreadCustomerCount);
  }
}
