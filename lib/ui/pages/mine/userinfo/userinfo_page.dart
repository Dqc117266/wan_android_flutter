import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/user_info_model.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/network/http_creator.dart';

class UserInfoScreen extends StatelessWidget {
  static const routeName = "/userInfo";

  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("用户信息"),
      ),
      body: FutureBuilder(
        future: UserUtils.getUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("error"),
            );
          } else {
            UserInfoModel userInfoModel = snapshot.data!;

            return ListView(
              children: [
                _buildListTileItem(
                    context, "用户名", userInfoModel.data!.username!),
                _buildListTileItem(context, "id", userInfoModel.data!.id!),
                _buildListTileItem(
                    context, "昵称", userInfoModel.data!.nickname!),
                Container(
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    onPressed: () {
                      logoutAndClearUser(context);
                    },
                    child: Text("退出登陆"),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildListTileItem(
      BuildContext context, String title, dynamic username) {
    return ListTile(
      onTap: () {},
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Text('$username'),
    );
  }

  void logoutAndClearUser(BuildContext context) {
    HttpCreator.logout().then((value) {
      if (value.errorCode == 0) {
        UserUtils.clearUserInfo();

        ToastUtils.showShortToast("退出登陆成功");
        Provider.of<UserViewModel>(context).updateUser();

        Navigator.of(context).pop();
      } else {
        ToastUtils.showShortToast("退出登陆错误");
      }
    })
      ..onError((error, stackTrace) {
        ToastUtils.showShortToast(LocaleKeys.user_networkError.tr());
      });
  }
}
