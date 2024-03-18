import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/result_model.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/user/login_page.dart';

import 'toast_utils.dart';

class HttpUtils {
  static Future<void> collectChapter(BuildContext context, int id) async {

    try {
      ResultModel resultModel = await HttpCreator.collectChapter(id);
      print("HttpUtils errorCode ${resultModel.errorCode}");
      if (resultModel.errorCode != 0) {
        ToastUtils.showShortToast('请先登录！');
        Navigator.of(context).pushNamed(LoginScreen.routeName, arguments: {"id": id});
      }
    } catch(e) {
      ToastUtils.showShortToast("网络错误，请稍后再试");
    }

  }
}