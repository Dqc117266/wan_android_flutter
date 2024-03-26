import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/collects_model.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/core/utils/userinfo_storage.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/mine/collect/coolect_item.dart';
import 'package:wan_android_flutter/ui/pages/web/web_page.dart';
import 'package:wan_android_flutter/ui/shared/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/shared/refreshable_listView.dart';

class CollectScreen extends StatefulWidget {
  static const routeName = "/collect";

  const CollectScreen({super.key});

  @override
  State<CollectScreen> createState() => _CollectScreenState();
}

class _CollectScreenState extends State<CollectScreen> {
  GlobalKey<RefreshableListViewState<Datas>> _refreshableListViewKey =
      GlobalKey();
  Datas? removeTempItem;

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
            final CollectsModel collectsModel = snapshot.data as CollectsModel;

            return Consumer<UserViewModel>(
              builder: (context, userViewModel, child) {
                filterItemsAndRefreshListView(context, userViewModel);

                return RefreshableListView<Datas>(
                  key: _refreshableListViewKey,
                  initialItems: collectsModel.data!.datas!,
                  maxPage: collectsModel.data!.pageCount!,
                  firstPage: 0,
                  loadMoreCallback: (page) async {
                    final CollectsModel? collectList =
                        await HttpUtils.handleRequestData(
                            () => HttpCreator.getCollectList(page));

                    if (collectList != null) {
                      return collectList.data!.datas;
                    }
                    return null;
                  },
                  itemBuilder: (context, data, index, length) {
                    final BorderRadius borderRadius;
                    bool isBottomLine = true;
                    if (length == 1) {
                      borderRadius = BorderRadius.all(Radius.circular(12));
                      isBottomLine = false;
                    } else if (index == 0) {
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
                      onItemClicked: (data) {
                        removeTempItem = data;
                        Navigator.pushNamed(context, WebPageScreen.routeName,
                            arguments: {
                              "title": data.title,
                              "url": data.link,
                              "id": data.originId,
                              "collect": true
                            });
                      },
                      onFavoriteClicked: (data) async {
                        final userInfo = await UserUtils.getUserInfo();
                        userInfo!.data!.collectIds!.remove(data.originId);

                        userViewModel.saveUser(userInfo);
                        // final state = _refreshableListViewKey.currentState;
                        // state!.items.remove(data);
                        // state.refreshListView();
                      },
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }

  void filterItemsAndRefreshListView(
      BuildContext context, UserViewModel userViewModel) {
    if (_refreshableListViewKey.currentState != null) {
      final state = _refreshableListViewKey.currentState;

      final items = state!.items;
      final userInfo = userViewModel.userInfo;
      final List<int> collectIds = userInfo!.data!.collectIds!;

      List<Datas> filteredItems = [];

      for (var item in items) {
        // 检查 originId 是否不在 collectIds 中
        if (collectIds.contains(item.originId)) {
          filteredItems.add(item);
        }
      }
      if (removeTempItem != null &&
          collectIds.contains(removeTempItem!.originId)) {
        filteredItems.insert(0, removeTempItem!);
      }
      print(filteredItems);

      state.refreshItems(filteredItems);
    }
  }
}
