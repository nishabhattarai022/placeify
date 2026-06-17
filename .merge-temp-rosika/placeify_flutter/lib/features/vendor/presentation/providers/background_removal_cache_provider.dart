import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'background_removal_cache_provider.g.dart';

/// Caches processed image paths by source image id to avoid re-processing on rebuild.
@Riverpod(keepAlive: true)
class BackgroundRemovalCache extends _$BackgroundRemovalCache {
  @override
  Map<String, String> build() => {};

  String? getProcessedPath(String imageId) => state[imageId];

  void cache(String imageId, String processedPath) {
    state = {...state, imageId: processedPath};
  }

  void remove(String imageId) {
    final next = Map<String, String>.from(state)..remove(imageId);
    state = next;
  }

  void clear() => state = {};
}
