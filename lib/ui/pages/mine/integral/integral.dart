import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/extensions/string_extension.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/rinks_model.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/network/api.dart';
import 'package:wan_android_flutter/network/api_service.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/mine/integral/refreshable_listView.dart';
import 'package:wan_android_flutter/ui/widgets/network_error_widget.dart';

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
      appBar: AppBar(title: Text(LocaleKeys.mine_myScores.tr()),),
      body: FutureBuilder(
        future: HttpCreator.getRinksTop(1),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || snapshot.data == null) {
            // 检查是否有错误或数据为空
            return NetWorkErrorWidget(
              onRefresh: () => setState(() {}),
            );
          } else {
            final RinksModel rinksModel = snapshot.data as RinksModel;

            return RefreshableListView<Datas>(
              initialItems: rinksModel.data.datas,
              maxPage: rinksModel.data.pageCount,
              startPage: 1,
              loadMoreCallback: (page) async {
                try {
                  final RinksModel nextPageUsers = await HttpCreator.getRinksTop(page);
                  return nextPageUsers.data.datas;
                } catch (e) {
                  ToastUtils.showNetWorkErrorToast();
                  return null;
                }
              },
              itemBuilder: (context, rink) {
                return ListTile(
                  onTap: () {},
                  leading: Text(rink.rank, style: Theme.of(context).textTheme.titleMedium,),
                  title: Text("用户名：${rink.username}"),
                  subtitle: Text("积分数：${rink.coinCount}"),
                  trailing: Text("等级：${rink.level}", style: Theme.of(context).textTheme.bodySmall!.copyWith(color: Theme.of(context).colorScheme.tertiary)),
                );
              },
            );
          }
        },
      ),
    );
  }

}
