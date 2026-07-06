/// Maps home room filter chips to catalog [Product.categoryId] values.
abstract final class HomeRoomCatalog {
  static const Map<String, List<String>> roomCategoryIds = {
    'living': ['sofas', 'chairs', 'tables', 'decor'],
    'dining': ['tables', 'chairs', 'storage'],
    'office': ['desks', 'chairs', 'tables', 'storage'],
  };

  static List<String> categoriesForRoom(String roomId) {
    return roomCategoryIds[roomId] ?? roomCategoryIds['living']!;
  }
}
