
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/user_info_model.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';

class UserViewModel extends ChangeNotifier {
  UserInfoModel? _userInfo;

  UserViewModel() {
    _initUserInfo();
  }

  void _initUserInfo() {
    updateUser();
  }

  Future<void> updateUser() async {
    _userInfo = await UserUtils.getUserInfo();
    notifyListeners();
  }

  Future<void> saveUser(UserInfoModel userInfoModel) async {
    await UserUtils.saveUserInfo(userInfoModel);
    updateUser();
  }

  UserInfoModel? get userInfo => _userInfo;


}