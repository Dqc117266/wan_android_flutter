import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/tree_model.dart';
import 'package:wan_android_flutter/core/utils/article_utils.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/widgets/chapter_list_item.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

class TabContentPage extends StatefulWidget {
  final DataItem dataItem;
  final Future<FrontArtclesModel> Function(int, int) getDataList;

  const TabContentPage({super.key, required this.dataItem, required this.getDataList});

  @override
  State<TabContentPage> createState() => _TabContentPageState();
}

class _TabContentPageState extends State<TabContentPage> with AutomaticKeepAliveClientMixin {
  GlobalKey<RefreshableListViewState<Datas>> refreshableListViewKey = GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
      onRefresh: ()=> setState(() {}),
      future: widget.getDataList(0, widget.dataItem.id!),
      builder: (context, snapshot) {
        final frontArtclesModel = snapshot.data as FrontArtclesModel;

        return Consumer<UserViewModel>(
          builder: (context, viewModel, child) {
            ArticleUtils.updateFavoriteItems(viewModel, refreshableListViewKey);

            return RefreshableListView(
              key: refreshableListViewKey,
              initialItems: frontArtclesModel.data!.datas!,
              loadMoreCallback: (page) async {
                final model = await HttpUtils.handleRequestData(
                        () => widget.getDataList(page, widget.dataItem.id!));
                if (model != null) {
                  return model.data!.datas;
                }

                return null;
              },
              itemBuilder: (context, item, index, length) {
                final result = getItemBorderRadius(index, length);
                final BorderRadius borderRadius = result[0];
                final bool isBottomLine = result[1];

                return ChapterListItem(
                    datas: item,
                    borderRadius: borderRadius,
                    isBottomLine: isBottomLine);
              },
              maxPage: frontArtclesModel.data!.pageCount!,
              firstPage: 0,
            );
          },
        );
      },
    );
  }

}
