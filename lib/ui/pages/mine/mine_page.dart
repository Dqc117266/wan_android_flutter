import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/user_info_model.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';
import 'package:wan_android_flutter/ui/pages/user/login_page.dart';

class MineScreen extends StatefulWidget {
  const MineScreen({super.key});

  @override
  State<MineScreen> createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  UserInfo? _userInfo;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userInfo = await UserUtils.getUserInfo();

    if (userInfo != null) {
      setState(() {
        _userInfo = userInfo;
      });
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.tableNames_mine.tr()),),
      body: ListView(
        children: [
          _buildHeadItem(context, _userInfo != null, ),
          _buildBodyItem(context, "我的积分", Icons.workspace_premium_outlined, BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
          _buildBodyItem(context, "我的收藏", Icons.star_border_outlined, BorderRadius.zero),
          _buildBodyItem(context, "TODO", Icons.done_outline_outlined, BorderRadius.zero),
          _buildBodyItem(context, "设置", Icons.settings_outlined, BorderRadius.zero),
        ],
      ),
    );
  }

  Widget _buildHeadItem(BuildContext context, bool isLogin) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),

      child: Material(
        child: InkWell(
          onTap: () {
            if (!isLogin) {
              Navigator.of(context).pushNamed(LoginScreen.routeName);
            }
          },
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
                    Text("登陆/注册", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 24,),
              ),
            ],
          ),
        ),
      ),
    );

  }

  Widget _buildBodyItem(BuildContext context, String title, IconData iconData, BorderRadius borderRadius) {
    return ListTile(
      onTap: () {},
      leading: Icon(iconData),
      title: Text(title),
      trailing: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 24,),
    );
  }
}
