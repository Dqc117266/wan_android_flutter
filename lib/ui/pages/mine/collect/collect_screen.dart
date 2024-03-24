import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/collects_model.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/mine/collect/coolect_item.dart';
import 'package:wan_android_flutter/ui/shared/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/shared/refreshable_listView.dart';

class CollectScreen extends StatefulWidget {
  static const routeName = "/collect";

  const CollectScreen({super.key});

  @override
  State<CollectScreen> createState() => _CollectScreenState();
}

class _CollectScreenState extends State<CollectScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.mine_myCollect.tr()),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        child: CustomFutureBuilder(
          future: HttpCreator.getCollectList(0),
          builder: (context, snapshot) {

            final CollectsModel collectsModel =
            snapshot.data as CollectsModel;

            return RefreshableListView<Datas>(
              initialItems: collectsModel.data!.datas!,
              maxPage: collectsModel.data!.pageCount!,
              firstPage: 0,
              loadMoreCallback: (page) async {
                final CollectsModel? collectList = await HttpUtils.handleRequestData(() => HttpCreator.getCollectList(page));

                if (collectList != null) {
                  if (page == 0) { //下拉刷新清除
                  }
                  return collectList.data!.datas;
                }
                return null;
              },
              itemBuilder: (context, data, index, length) {
                final BorderRadius borderRadius;
                bool isBottomLine = true;
                if (index == 0) {
                  borderRadius = BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12));
                } else if (index == length - 1) {
                  borderRadius = BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12));
                  isBottomLine = false;
                } else {
                  borderRadius = BorderRadius.zero;
                }

                return CollectItem(
                  data: data,
                  borderRadius: borderRadius,
                  isBottomLine: isBottomLine,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
