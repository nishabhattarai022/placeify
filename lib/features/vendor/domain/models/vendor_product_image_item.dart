/// A product photo in the upload/edit form — either a newly picked file or an
/// existing remote URL from the catalog.
class VendorProductImageItem {
  const VendorProductImageItem({
    required this.id,
    this.localPath,
    this.remoteUrl,
  }) : assert(
          localPath != null || remoteUrl != null,
          'An image item needs a local path or remote URL.',
        );

  static int _idCounter = 0;

  static String _nextId() =>
      'img-${DateTime.now().microsecondsSinceEpoch}-${_idCounter++}';

  factory VendorProductImageItem.fromLocalPath(String path) {
    return VendorProductImageItem(
      id: _nextId(),
      localPath: path,
    );
  }

  factory VendorProductImageItem.fromRemoteUrl(String url) {
    return VendorProductImageItem(
      id: _nextId(),
      remoteUrl: url,
    );
  }

  final String id;
  final String? localPath;
  final String? remoteUrl;

  bool get isLocal => localPath != null;

  String get displaySource => localPath ?? remoteUrl ?? '';

  VendorProductImageItem copyWith({
    String? localPath,
    String? remoteUrl,
  }) {
    return VendorProductImageItem(
      id: id,
      localPath: localPath ?? this.localPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
    );
  }
}
