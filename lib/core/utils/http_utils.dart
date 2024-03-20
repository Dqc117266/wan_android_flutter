import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/result_model.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/user/login_page.dart';

import 'toast_utils.dart';

class HttpUtils {
  static Future<void> collectChapter(BuildContext context, int id) async {

    try {
      ResultModel resultModel = await HttpCreator.collectChapter(id);
      print("HttpUtils errorCode ${resultModel.errorCode}");

      //未登录的错误码为-1001，其他错误码为-1，成功为0
      if (resultModel.errorCode != 0) {
        ToastUtils.showShortToast(LocaleKeys.user_notLogin.tr());
        Navigator.of(context).pushNamed(LoginScreen.routeName, arguments: {"id": id});
      }
    } catch(e) {
      ToastUtils.showShortToast(LocaleKeys.user_networkError.tr());
    }

  }
}