import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/user_rink_list_model.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = "/history";

  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int _firstPage = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.integral_history.tr()),
      ),
      body: CustomFutureBuilder(
        future: HttpCreator.getCoinUserList(_firstPage),
        onRefresh: ()=> setState(() {}),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          final userRinkListModel = snapshot.data as UserRinkListModel;
          return RefreshableListView(
            initialItems: userRinkListModel.data!.datas!,
            maxPage: userRinkListModel.data!.pageCount!,
            firstPage: _firstPage,
            loadMoreCallback: (page) async {
              final UserRinkListModel? fetchData = await HttpUtils.handleRequestData(
                  () => HttpCreator.getCoinUserList(page));

              if (fetchData != null) {
                return fetchData.data!.datas;
              }
              return null;
            },
            itemBuilder: (context, data, index, length) {

              DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(data.date!);
              String formattedDateTime = dateTime.toLocal().toString().split('.')[0];

              return ListTile(
                onTap: () {},
                title: Text(data.reason!, style: TextStyle(fontWeight: FontWeight.bold),),
                subtitle: Text(formattedDateTime),
                trailing: Text('+${data.coinCount!}', style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.tertiary),),
              );
            },
          );
        },
      ),
    );
  }
}
