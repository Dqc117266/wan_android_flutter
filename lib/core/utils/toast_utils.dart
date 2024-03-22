
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';

class ToastUtils {
  static void showShortToast(String msg) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }

  static void showNetWorkErrorToast() {
    showShortToast(LocaleKeys.user_networkError.tr());
  }

}