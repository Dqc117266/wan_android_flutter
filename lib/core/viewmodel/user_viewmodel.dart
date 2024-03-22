
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/user_info_model.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';

class UserViewModel extends ChangeNotifier {
  UserInfoModel? userInfo;

  UserViewModel() {
    _initUserInfo();
  }

  void _initUserInfo() {
    updateUser();
  }

  void updateUser() async {
    userInfo = await UserUtils.getUserInfo();
    notifyListeners();
  }


}