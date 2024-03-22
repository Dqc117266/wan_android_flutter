import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/user_info_model.dart';
import 'package:wan_android_flutter/core/router/router.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/ui/pages/mine/collect/collect_screen.dart';
import 'package:wan_android_flutter/ui/pages/mine/integral/integral.dart';
import 'package:wan_android_flutter/ui/pages/mine/settings/settings_page.dart';
import 'package:wan_android_flutter/ui/pages/mine/todo/todo_page.dart';
import 'package:wan_android_flutter/ui/pages/mine/userinfo/userinfo_page.dart';
import 'package:wan_android_flutter/ui/pages/user/login_page.dart';

class MineScreen extends StatefulWidget {
  const MineScreen({super.key});

  @override
  State<MineScreen> createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  UserInfoModel? userInfo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.tableNames_mine.tr()),
      ),
      body: Consumer<UserViewModel>(
        builder: (context, userViewModel, child) {
          userInfo = userViewModel.userInfo;
          final isUserInfoEmpty = userInfo == null;
          print('user_info ${userInfo != null}');

          return ListView(
            children: [
              _buildHeadItem(
                context,
                isUserInfoEmpty,
                isUserInfoEmpty
                      ? () => _navigateToLogin(context)
                      : () => _navigateToUserInfo(context),
              ),
              _buildBodyItem(
                context,
                LocaleKeys.mine_myScores.tr(),
                Icons.workspace_premium_outlined,
                trailContent: !isUserInfoEmpty ? '${userInfo!.data!.coinCount!}' : null,
                isUserInfoEmpty
                    ? () => _navigateToLogin(context)
                    : () => _navigateToIntegral(context),

              ),
              _buildBodyItem(
                context,
                LocaleKeys.mine_myCollect.tr(),
                Icons.favorite_border,
                isUserInfoEmpty
                    ? () => _navigateToLogin(context)
                    : () => _navigateToCollect(context),

              ),
              _buildBodyItem(
                context,
                LocaleKeys.mine_todo.tr(),
                Icons.done_outline_outlined,
                isUserInfoEmpty
                    ? () => _navigateToLogin(context)
                    : () => _navigateToTodo(context),

              ),
              _buildBodyItem(
                context,
                LocaleKeys.mine_settings.tr(),
                Icons.settings_outlined,
                () => _navigateToSettings(context),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeadItem(BuildContext context, bool isUserInfoEmpty, Function clickHandle) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      child: Material(
        child: InkWell(
          onTap: () => clickHandle(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 56.0,
                height: 56.0,
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                child: Icon(
                  Icons.account_circle_outlined,
                  size: 56,
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isUserInfoEmpty ? LocaleKeys.mine_notLogin.tr() : userInfo!.data!.username!,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    if (!isUserInfoEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text("id：${userInfo!.data!.id}"),
                      ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBodyItem(BuildContext context, String title, IconData iconData,
      Function clickHandle, {String? trailContent}) {
    return ListTile(
      onTap: () => clickHandle(),
      leading: Icon(iconData),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailContent != null)
            Text(trailContent, style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: Theme.of(context).colorScheme.tertiary),),
          Icon(
            Icons.chevron_right,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
        ],
      ),
    );
  }

  void _navigateToLogin(BuildContext context) {
    MyRouter.pushFromRight(context, LoginScreen());
  }

  void _navigateToUserInfo(BuildContext context) {
    MyRouter.pushFromRight(context, UserInfoScreen());
  }

  void _navigateToIntegral(BuildContext context) {
    MyRouter.pushFromRight(context, IntegralScreen());
  }

  void _navigateToCollect(BuildContext context) {
    MyRouter.pushFromRight(context, CollectScreen());
  }

  void _navigateToTodo(BuildContext context) {
    MyRouter.pushFromRight(context, TodoScreen());
  }

  void _navigateToSettings(BuildContext context) {
    MyRouter.pushFromRight(context, SettingsScreen());
  }
}
