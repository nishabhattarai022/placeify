import '../generated/protocol.dart';

/// Normalizes pagination input for list endpoints.
abstract final class PaginationHelper {
  static const defaultPageSize = 20;
  static const maxPageSize = 100;

  static ({int page, int pageSize, int offset}) resolve(
    PaginationInput? input,
  ) {
    final page = (input?.page ?? 1).clamp(1, 1000000);
    final pageSize = (input?.pageSize ?? defaultPageSize).clamp(1, maxPageSize);
    final offset = (page - 1) * pageSize;
    return (page: page, pageSize: pageSize, offset: offset);
  }
}
