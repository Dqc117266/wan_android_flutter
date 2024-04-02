import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

import '../model/front_articles_model.dart';

class ArticleUtils {

  //刷新文章列表收藏的ui
  static void updateFavoriteItems(UserViewModel userViewModel, GlobalKey<RefreshableListViewState<Datas>> globalKey) {
    if (globalKey.currentState != null) {
      final state = globalKey.currentState;
      final items = state!.items;
      final collectIds = userViewModel.userInfo != null ? userViewModel.userInfo!.data!.collectIds : [];

      // 遍历项目列表并更新收藏状态
      for (var item in items) {
        if (collectIds!.contains(item.id)) {
          item.collect = true;
        } else {
          item.collect = false;
        }
      }

      // 刷新列表视图以反映更改
      state.refreshListView();
    }
  }
}