import 'package:intl/intl.dart';

abstract class HrmDateUtils {
  static final _displayDate = DateFormat('dd MMM yyyy');
  static final _displayDateTime = DateFormat('dd MMM yyyy, hh:mm a');
  static final _apiDate = DateFormat('yyyy-MM-dd');
  static final _monthYear = DateFormat('MMMM yyyy');
  static final _time = DateFormat('hh:mm a');
  static final _relative = DateFormat('MMM d');

  static String formatDisplay(DateTime date) => _displayDate.format(date);
  static String formatDisplayTime(DateTime date) =>
      _displayDateTime.format(date);
  static String formatApi(DateTime date) => _apiDate.format(date);
  static String formatMonthYear(DateTime date) => _monthYear.format(date);
  static String formatTime(DateTime date) => _time.format(date);
  static String formatRelative(DateTime date) => _relative.format(date);

  static DateTime? parseApi(String? date) {
    if (date == null) return null;
    return DateTime.tryParse(date);
  }

  static String? formatApiNullable(DateTime? date) {
    if (date == null) return null;
    return _apiDate.format(date);
  }

  static int daysBetween(DateTime start, DateTime end) {
    final a = DateTime(start.year, start.month, start.day);
    final b = DateTime(end.year, end.month, end.day);
    return b.difference(a).inDays + 1;
  }

  static int workingDaysBetween(DateTime start, DateTime end) {
    int count = 0;
    var current = start;
    while (!current.isAfter(end)) {
      if (current.weekday != DateTime.saturday &&
          current.weekday != DateTime.sunday) {
        count++;
      }
      current = current.add(const Duration(days: 1));
    }
    return count;
  }

  static String timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return formatRelative(date);
  }

  static String lastUpdatedLabel(DateTime? date) {
    if (date == null) return '';
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 1) return 'Updated just now';
    return 'Updated ${diff.inMinutes}m ago';
  }
}
