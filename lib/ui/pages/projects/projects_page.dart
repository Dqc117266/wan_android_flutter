import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/tree_model.dart';
import 'package:wan_android_flutter/core/utils/article_utils.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/widgets/chapter_list_item.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

class ProjectsScreen extends StatefulWidget {
  const ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return CustomFutureBuilder(
        onRefresh: () {
          setState(() {});
        },
        future: HttpCreator.getProjectClassify(),
        builder: (context, snapshot) {
          TreeModel treeModel = snapshot.data as TreeModel;
          _tabController = TabController(
              length: treeModel.data!.length, vsync: this); // 设置选项卡数量

          return Scaffold(
            appBar: AppBar(
              title: Text(LocaleKeys.tableNames_projects.tr()),
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabs: treeModel.data!
                    .map((element) => Text(element.name!))
                    .toList(),
              ),
            ),
            backgroundColor:
                Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.45),
            body: TabBarView(
              controller: _tabController,
              children: treeModel.data!
                  .map((element) => _buildPage(element))
                  .toList(),
            ),
          );
        });
  }

  Widget _buildPage(DataItem dataItem) {

    GlobalKey<RefreshableListViewState<Datas>> refreshableListViewKey =
        GlobalKey();

    return CustomFutureBuilder(
      onRefresh: () {
        setState(() {});
      },
      future: HttpCreator.getProjectList(0, dataItem.id!),
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
                    () => HttpCreator.getProjectList(page, dataItem.id!));
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
