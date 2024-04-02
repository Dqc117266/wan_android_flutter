import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';

class TimeUtils {

  static String formatRelativeDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (now.isAfter(date)) {
      if (difference.inDays == 0) {
        return LocaleKeys.todo_date_today.tr();
      } else if (difference.inDays == 1) {
        return LocaleKeys.todo_date_yesterday.tr();
      } else if (difference.inDays.abs() < 7) {
        return '${difference.inDays.abs()}${LocaleKeys.todo_date_dayAgo.tr()}';
      } else if (difference.inDays.abs() >= 7 && difference.inDays.abs() <= 365) {
        final weeksAgo = (difference.inDays.abs() / 7).floor();
        return '$weeksAgo${LocaleKeys.todo_date_weekAgo.tr()}';
      } else {
        final yearsAgo = (difference.inDays.abs() / 365).floor();
        return '$yearsAgo${LocaleKeys.todo_date_yearAgo.tr()}';
      }
    } else {
      if (difference.inDays == 0) {
        return LocaleKeys.todo_date_tomorrow.tr();
      }
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
    final formattedMonthDate = DateFormat(LocaleKeys.todo_date_monthDay.tr(), LocaleKeys.todo_date_localeIdentifier.tr());
    final formattedYearDate = DateFormat(LocaleKeys.todo_date_yearMonthDay.tr(), LocaleKeys.todo_date_localeIdentifier.tr());

    if (dateTime.year == now.year) {
      return formattedMonthDate.format(dateTime);
    } else {
      return formattedYearDate.format(dateTime);
    }
  }

  static String formatDateYearTime(DateTime dateTime) {
    final formattedYearDate = DateFormat('yyyy-MM-dd');
    return formattedYearDate.format(dateTime);
  }

  static DateTime getDateTime(int dateMillis) {
    return DateTime.fromMillisecondsSinceEpoch(dateMillis);
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
