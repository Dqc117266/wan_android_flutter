import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/user_info_model.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/shared/dialog_helper.dart';

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
          if (snapshot.hasError || snapshot.data == null) {
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
                _buildListTileItem(
                    context, "积分数", userInfoModel.data!.coinCount!),
                Container(
                  margin: EdgeInsets.only(top: 60),
                  padding: EdgeInsets.all(16),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      side: MaterialStateProperty.all(BorderSide.none),
                    ),
                    onPressed: () {
                      _showLogoutDialog(context);
                    },
                    child: Text("退出登陆", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.error),),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    DialogHelper.showAlertDialog(
      context: context,
      title: "退出登陆",
      content: "是否退出当前登陆？",
      dismissText: "取消",
      actionText: "确定",
      onAction: () => logoutAndClearUser(context),
    );
  }

  Widget _buildListTileItem(
      BuildContext context, String title, dynamic username) {
    return ListTile(
      onTap: () {},
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
      ),
      trailing: Text('$username', style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
    );
  }

  void logoutAndClearUser(BuildContext context) {
    HttpCreator.logout().then((value) {
      if (value.errorCode == 0) {
        UserUtils.clearUserInfo();

        ToastUtils.showShortToast("已退出登陆");
        Provider.of<UserViewModel>(context, listen: false).updateUser();

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
