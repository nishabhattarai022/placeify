import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_operating_day.freezed.dart';
part 'vendor_operating_day.g.dart';

const vendorWeekDayKeys = [
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
  'sunday',
];

@freezed
abstract class VendorOperatingDay with _$VendorOperatingDay {
  const factory VendorOperatingDay({
    required String dayKey,
    @Default(false) bool isClosed,
    @Default('09:00') String openTime,
    @Default('17:00') String closeTime,
  }) = _VendorOperatingDay;

  factory VendorOperatingDay.fromJson(Map<String, dynamic> json) =>
      _$VendorOperatingDayFromJson(json);
}

/// Default 7-day schedule for mock seed and legacy JSON migration.
List<VendorOperatingDay> defaultVendorWeekSchedule({
  String weekdayOpen = '10:00',
  String weekdayClose = '18:00',
  String saturdayOpen = '11:00',
  String saturdayClose = '16:00',
}) {
  return [
    for (final day in vendorWeekDayKeys)
      VendorOperatingDay(
        dayKey: day,
        openTime: day == 'saturday' ? saturdayOpen : weekdayOpen,
        closeTime: day == 'saturday' ? saturdayClose : weekdayClose,
      ),
  ];
}

String formatVendorScheduleSummary(List<VendorOperatingDay> schedule) {
  if (schedule.isEmpty) return '';

  final openDays = schedule.where((day) => !day.isClosed).toList();
  if (openDays.isEmpty) return 'Closed';

  final byHours = <String, List<String>>{};
  for (final day in openDays) {
    final key = '${day.openTime}–${day.closeTime}';
    byHours.putIfAbsent(key, () => []).add(day.dayKey);
  }

  return byHours.entries
      .map((entry) => '${_formatDayKeys(entry.value)} ${entry.key}')
      .join(', ');
}

String _formatDayKeys(List<String> dayKeys) {
  const shortLabels = {
    'monday': 'Mon',
    'tuesday': 'Tue',
    'wednesday': 'Wed',
    'thursday': 'Thu',
    'friday': 'Fri',
    'saturday': 'Sat',
    'sunday': 'Sun',
  };

  final indices = dayKeys
      .map((key) => vendorWeekDayKeys.indexOf(key))
      .where((index) => index >= 0)
      .toList()
    ..sort();

  if (indices.isEmpty) return dayKeys.join(', ');

  final ranges = <String>[];
  var rangeStart = indices.first;
  var rangeEnd = indices.first;

  for (var i = 1; i < indices.length; i++) {
    if (indices[i] == rangeEnd + 1) {
      rangeEnd = indices[i];
      continue;
    }
    ranges.add(_dayRangeLabel(rangeStart, rangeEnd, shortLabels));
    rangeStart = indices[i];
    rangeEnd = indices[i];
  }
  ranges.add(_dayRangeLabel(rangeStart, rangeEnd, shortLabels));
  return ranges.join(', ');
}

String _dayRangeLabel(
  int start,
  int end,
  Map<String, String> shortLabels,
) {
  final startKey = vendorWeekDayKeys[start];
  final endKey = vendorWeekDayKeys[end];
  final startLabel = shortLabels[startKey] ?? startKey;
  final endLabel = shortLabels[endKey] ?? endKey;
  return start == end ? startLabel : '$startLabel–$endLabel';
}
