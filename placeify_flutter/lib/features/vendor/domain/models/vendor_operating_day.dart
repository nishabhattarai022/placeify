import 'package:freezed_annotation/freezed_annotation.dart';

part 'vendor_operating_day.freezed.dart';
part 'vendor_operating_day.g.dart';

const vendorWeekDayKeys = [
  'sunday',
  'monday',
  'tuesday',
  'wednesday',
  'thursday',
  'friday',
  'saturday',
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

/// Default 7-day schedule for new profiles and legacy JSON migration.
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

/// Display label for a single [VendorOperatingDay] hours range.
String formatVendorDayHours(VendorOperatingDay day) {
  if (day.isClosed) return 'Closed';
  return '${formatVendorTimeDisplay(day.openTime)} – '
      '${formatVendorTimeDisplay(day.closeTime)}';
}

/// Converts 24h `HH:mm` to readable 12h time (e.g. `09:00` → `9:00 AM`).
String formatVendorTimeDisplay(String time) {
  final parts = time.split(':');
  if (parts.length != 2) return time;

  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return time;

  final period = hour >= 12 ? 'PM' : 'AM';
  final hour12 = hour % 12 == 0 ? 12 : hour % 12;
  final minutePadded = minute.toString().padLeft(2, '0');
  return '$hour12:$minutePadded $period';
}

/// Grouped rows for operating-hours UI (view + summary).
class VendorScheduleDisplayGroup {
  const VendorScheduleDisplayGroup({
    required this.daysLabel,
    required this.hoursLabel,
    required this.isClosed,
  });

  final String daysLabel;
  final String hoursLabel;
  final bool isClosed;
}

List<VendorScheduleDisplayGroup> buildVendorScheduleDisplayGroups(
  List<VendorOperatingDay> schedule,
) {
  if (schedule.isEmpty) return const [];

  final ordered = [
    for (final key in vendorWeekDayKeys)
      schedule.firstWhere(
        (day) => day.dayKey == key,
        orElse: () => VendorOperatingDay(dayKey: key, isClosed: true),
      ),
  ];

  final groups = <VendorScheduleDisplayGroup>[];
  var rangeStart = 0;

  String blockKey(VendorOperatingDay day) =>
      day.isClosed ? 'closed' : '${day.openTime}|${day.closeTime}';

  for (var i = 1; i <= ordered.length; i++) {
    final isBreak = i == ordered.length ||
        blockKey(ordered[i]) != blockKey(ordered[rangeStart]);

    if (!isBreak) continue;

    final slice = ordered.sublist(rangeStart, i);
    final first = slice.first;
    groups.add(
      VendorScheduleDisplayGroup(
        daysLabel: _formatDayKeys(slice.map((d) => d.dayKey).toList()),
        hoursLabel: formatVendorDayHours(first),
        isClosed: first.isClosed,
      ),
    );
    rangeStart = i;
  }

  return groups;
}
