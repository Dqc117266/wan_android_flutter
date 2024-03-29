import 'package:intl/intl.dart';

class TimeUtils {

  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    print("difference ${difference.inDays}");

    if (now.isAfter(date)) {
      if (difference.inDays == 0) {
        return '今天';
      } else if (difference.inDays == 1) {
        return '昨天';
      } else if (difference.inDays.abs() < 7) {
        return '${difference.inDays.abs()}天前';
      } else if (difference.inDays.abs() >= 7 && difference.inDays.abs() <= 365) {
        final weeksAgo = (difference.inDays.abs() / 7).floor();
        return '$weeksAgo周前';
      } else {
        final yearsAgo = (difference.inDays.abs() / 365).floor();
        return '$yearsAgo年前';
      }
    } else {
      return formatDateTime(date);
    }

  }

  static String formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final formattedMonthDate = DateFormat('M月d日E', 'zh_CN');
    final formattedYearDate = DateFormat('yyyy年MM月dd日E', 'zh_CN');

    if (dateTime.year == now.year) {
      return formattedMonthDate.format(dateTime);
    } else {
      return formattedYearDate.format(dateTime);
    }
  }

}
