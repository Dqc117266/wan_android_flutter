import 'dart:convert';
import 'package:wan_android_flutter/core/model/user_info_model.dart';
import 'package:wan_android_flutter/ui/shared/shared_preferences_helper.dart';

class UserUtils {
  static const String _keyUserInfo = 'user_info';

  // 保存用户信息
  static Future<void> saveUserInfo(UserInfo userInfo) async {
    final String jsonString = json.encode(userInfo.toJson());
    await SharedPreferencesHelper.setValue(_keyUserInfo, jsonString);
  }

  // 获取用户信息
  static Future<UserInfo?> getUserInfo() async {
    final String? jsonString = SharedPreferencesHelper.getString(_keyUserInfo);
    if (jsonString != null) {
      final Map<String, dynamic> jsonMap = json.decode(jsonString);
      return UserInfo.fromJson(jsonMap);
    }
    return null;
  }

  // 清除用户信息
  static Future<void> clearUserInfo() async {
    await SharedPreferencesHelper.remove(_keyUserInfo);
  }
}