import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/rinks_model.dart';
import 'package:wan_android_flutter/core/model/user_rink_model.dart';
import 'package:wan_android_flutter/core/router/router.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/mine/integral/history/history_page.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

class IntegralScreen extends StatefulWidget {
  static const routeName = "/integral";

  const IntegralScreen({super.key});

  @override
  State<IntegralScreen> createState() => _IntegralScreenState();
}

class _IntegralScreenState extends State<IntegralScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.mine_myScores.tr()),
        actions: [
          IconButton(tooltip: LocaleKeys.integral_history.tr(), onPressed: () {
            // Navigator.of(context).pushNamed(HistoryScreen.routeName);
            MyRouter.pushFromRight(context, HistoryScreen());
          }, icon: Icon(Icons.history)),
        ],
      ),
      body: CustomFutureBuilder(
        future: Future.wait([
          HttpCreator.getRinksTop(1),
          HttpCreator.getUserRink(),
        ]),
        builder: (context, snapshot) {
          final List<Object> data = snapshot.data as List<Object>;

          final RinksModel rinksModel = data[0] as RinksModel;
          final UserRinkModel userRinkModel = data[1] as UserRinkModel;
          _updateUserInfo(context, userRinkModel);

          return Column(
            children: [
              Expanded(
                child: RefreshableListView<Datas>(
                  initialItems: rinksModel.data.datas,
                  maxPage: rinksModel.data.pageCount,
                  firstPage: 1,
                  loadMoreCallback: (page) async {
                    try {
                      final RinksModel nextPageUsers =
                      await HttpCreator.getRinksTop(page);
                      return nextPageUsers.data.datas;
                    } catch (e) {
                      ToastUtils.showNetWorkErrorToast();
                      return null;
                    }
                  },
                  itemBuilder: (context, data, index, length) {
                    return ListTile(
                      onTap: () {},
                      leading: Text(
                        data.rank,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      title: Text("${LocaleKeys.integral_userName.tr()}${data.username}"),
                      subtitle: Text("${LocaleKeys.integral_coin.tr()}${data.coinCount}"),
                      trailing: Text("${LocaleKeys.integral_leve.tr()}${data.level}",
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiary)),
                    );
                  },
                ),
              ),
              Container(
                alignment: Alignment.center,
                color: Theme.of(context)
                    .colorScheme
                    .surfaceVariant
                    .withOpacity(0.5),
                child: ListTile(
                  leading: Text(
                    '${userRinkModel.data!.rank}',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  title: Text(
                    "${LocaleKeys.integral_me.tr()}${userRinkModel.data!.username}",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  subtitle: Text("${LocaleKeys.integral_coin.tr()}${userRinkModel.data!.coinCount}",
                      style:
                      TextStyle(color: Theme.of(context).primaryColor)),
                  trailing: Text("${LocaleKeys.integral_leve.tr()}${userRinkModel.data!.level}",
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Theme.of(context).primaryColor)),
                ), // 替换 YourBottomWidget() 为您自己的底部 widget
              ),
            ],
          );
        },
      ),
    );
  }

  void _updateUserInfo(BuildContext context, UserRinkModel userRinkModel) async { //更新积分数
    if (userRinkModel != null) {
      final userInfo = await UserUtils.getUserInfo();
      userInfo!.data!.coinCount = userRinkModel.data!.coinCount;
      await UserUtils.saveUserInfo(userInfo);

      Provider.of<UserViewModel>(context, listen: false).updateUser();

    }
  }
}
