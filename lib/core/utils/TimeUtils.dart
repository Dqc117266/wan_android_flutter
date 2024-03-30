import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtils {

  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

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

  static bool isLateTime(DateTime date) {
    final now = DateTime.now();
    if (now.year > date.year) {
      return true;
    } else if (now.year == date.year && now.month > date.month) {
      return true;
    } else if (now.year == date.year && now.month == date.month && now.day > date.day) {
      return true;
    }

    return false;
  }

  static bool isSameDay(int dateMillis, DateTime selectDate) {
    // 将毫秒数转换为 DateTime 对象
    DateTime itemDate = DateTime.fromMillisecondsSinceEpoch(dateMillis);

    print("itemDate ${itemDate} selectDate ${selectDate}");
    // 比较日期部分是否相等
    if (itemDate.year == selectDate.year &&
        itemDate.month == selectDate.month &&
        itemDate.day == selectDate.day) {
      return true;
    }

    return false;
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

  static String formatDateYearTime(DateTime dateTime) {
    final formattedYearDate = DateFormat('yyyy-MM-dd', 'zh_CN');
    return formattedYearDate.format(dateTime);
  }


  static Future<DateTime?> selectTime(
      BuildContext context, DateTime initialDate) async {
    // Show the time picker dialog
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: initialDate, // Set the initial date
      firstDate: DateTime(initialDate.year - 5), // Set the first allowable date
      lastDate: DateTime(initialDate.year + 5), // Set the last allowable date
    );

    return selectedDate;
  }

}
