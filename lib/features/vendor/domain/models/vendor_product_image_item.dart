/// A product photo in the upload/edit form — either a newly picked file or an
/// existing remote URL from the catalog.
class VendorProductImageItem {
  const VendorProductImageItem({
    required this.id,
    this.localPath,
    this.remoteUrl,
    this.processedLocalPath,
    this.isProcessingBg = false,
    this.bgRemovalError,
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
  final String? processedLocalPath;
  final bool isProcessingBg;
  final String? bgRemovalError;

  bool get isLocal => localPath != null;

  bool get hasBackgroundRemoved => processedLocalPath != null;

  String get displaySource =>
      processedLocalPath ?? localPath ?? remoteUrl ?? '';

  String? get originalLocalPath => localPath;

  VendorProductImageItem copyWith({
    String? localPath,
    String? remoteUrl,
    String? processedLocalPath,
    bool? isProcessingBg,
    String? bgRemovalError,
    bool clearProcessedPath = false,
    bool clearBgError = false,
  }) {
    return VendorProductImageItem(
      id: id,
      localPath: localPath ?? this.localPath,
      remoteUrl: remoteUrl ?? this.remoteUrl,
      processedLocalPath: clearProcessedPath
          ? null
          : (processedLocalPath ?? this.processedLocalPath),
      isProcessingBg: isProcessingBg ?? this.isProcessingBg,
      bgRemovalError:
          clearBgError ? null : (bgRemovalError ?? this.bgRemovalError),
    );
  }
}
