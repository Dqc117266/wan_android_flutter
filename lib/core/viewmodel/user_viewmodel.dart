
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/user_info_model.dart';
import 'package:wan_android_flutter/core/model/user_model.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';
import 'package:wan_android_flutter/network/http_creator.dart';

class UserViewModel extends ChangeNotifier {
  UserInfoModel? _userInfo;

  UserViewModel() {
    _initUserInfo();
  }

  void _initUserInfo() async {
    try {
      UserModel userInfoModel = await HttpCreator.getUserInfo(); //更新用户信息
      if (userInfoModel.data!.userData != null) {
        await saveUser(UserInfoModel(data: userInfoModel.data!.userData!));
      } else {
        updateUser();
      }
    } catch (e) {
      updateUser();
    }
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