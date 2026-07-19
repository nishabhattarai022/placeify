/// User-facing copy for the My AR listing screen.
abstract final class ArStrings {
  static const eyebrow = 'MY AR';
  static const titleLine1 = 'My AR';

  static const searchHint = 'Search saved items...';
  static const emptyTitle = 'No AR items yet';
  static const emptySubtitle =
      'Tap the AR icon on products, then tap Save for now to keep them here.';
  static const emptyCta = 'Browse furniture';

  static String savedCount(int count) =>
      count == 1 ? '1 saved item' : '$count saved items';

  static String searchResults(int count) =>
      count == 1 ? '1 item found' : '$count items found';

  static const savedPillPrefix = 'Saved';

  static const saveForNowSingle = 'Save for now';
  static String saveForNowMultiple(int count) => 'Save for now · $count';

  static const selectHint = 'Tap items to select one or more for AR preview.';
  static String selectedCount(int count) =>
      count == 1 ? '1 item selected' : '$count items selected';
}
