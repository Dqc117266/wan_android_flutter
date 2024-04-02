import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/user_info_model.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/shared/dialog_helper.dart';

class UserInfoScreen extends StatelessWidget {
  static const routeName = "/userInfo";

  const UserInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.userInfo_name.tr()),
      ),
      body: CustomFutureBuilder(
        future: UserUtils.getUserInfo(),
        builder: (context, snapshot) {
          UserInfoModel userInfoModel = snapshot.data!;

          return ListView(
            children: [
              _buildListTileItem(
                  context, LocaleKeys.userInfo_userName.tr(), userInfoModel.data!.username!),
              _buildListTileItem(context, LocaleKeys.userInfo_userId.tr(), userInfoModel.data!.id!),
              _buildListTileItem(
                  context, LocaleKeys.userInfo_nickName.tr(), userInfoModel.data!.nickname!),
              _buildListTileItem(
                  context, LocaleKeys.userInfo_coin.tr(), userInfoModel.data!.coinCount!),
              Container(
                margin: EdgeInsets.only(top: 60),
                padding: EdgeInsets.all(16),
                child: OutlinedButton(
                  style: ButtonStyle(
                    side: MaterialStateProperty.all(BorderSide.none),
                  ),
                  onPressed: () {
                    _showLogoutDialog(context);
                  },
                  child: Text(LocaleKeys.userInfo_outLogin.tr(), style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary),),
                ),
              ),
            ],
          );

        },
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    DialogHelper.showAlertDialog(
      context: context,
      title: Text(LocaleKeys.userInfo_outLogin.tr()),
      content: Text(LocaleKeys.userInfo_outLoginContent.tr()),
      dismissText: LocaleKeys.dialogDismiss.tr(),
      actionText: LocaleKeys.dialogAction.tr(),
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

        Provider.of<UserViewModel>(context, listen: false).updateUser();

        Navigator.of(context).pop();
      } else {
        ToastUtils.showNetWorkErrorToast();
      }
    })
      ..onError((error, stackTrace) {
        ToastUtils.showNetWorkErrorToast();
      });
  }
}
