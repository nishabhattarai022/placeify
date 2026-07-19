import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/room_snapshot_store.dart';

/// Local AR room shot gallery. Invalidate after capture/delete so profile
/// stats and the Saved Rooms screen stay in sync.
final roomSnapshotsProvider =
    FutureProvider.autoDispose<List<RoomSnapshot>>((ref) async {
  try {
    return await RoomSnapshotStore().list();
  } catch (_) {
    // Web / missing plugins should never crash the profile screen.
    return const [];
  }
});
