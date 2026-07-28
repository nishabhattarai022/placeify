abstract final class MessagingRoutes {
  static const inbox = '/messages';
  static String chat(String conversationId) => '$inbox/$conversationId';

  static const vendorInbox = '/vendor/messages';
  static String vendorChat(String conversationId) =>
      '$vendorInbox/$conversationId';
}
