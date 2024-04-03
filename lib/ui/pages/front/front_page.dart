import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';
import 'package:wan_android_flutter/core/model/front_top_artcles_model.dart';
import 'package:wan_android_flutter/core/utils/article_utils.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/ui/pages/front/banner/create_carousel.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/widgets/chapter_list_item.dart';
import 'package:wan_android_flutter/ui/pages/search/custom_search_delegate.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';
import 'package:wan_android_flutter/ui/widgets/network_error_widget.dart';

import '../../../network/http_creator.dart';

class FrontScreen extends StatefulWidget {
  static const routeName = "/front";

  FrontScreen({super.key});

  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> with AutomaticKeepAliveClientMixin {
  GlobalKey<RefreshableListViewState<Datas>> _refreshableListViewKey =
      GlobalKey();

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.tableNames_frontPage.tr()),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: Icon(Icons.search),
          )
        ],
      ),
      backgroundColor:
          Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.45),
      body: CustomFutureBuilder(
        future: Future.wait([
          HttpCreator.getBanner(),
          HttpCreator.getFrontTopList(),
          HttpCreator.getFrontList(0),
        ]),
        onRefresh: () {
          setState(() {});
        },
        builder: (context, snapshot) {
          final List<Object> data = snapshot.data as List<Object>;
          final FrontBannerModel? bannerData = data[0] as FrontBannerModel?;
          final FrontTopArtclesModel? frontTopListData =
              data[1] as FrontTopArtclesModel?;
          final FrontArtclesModel? frontListData =
              data[2] as FrontArtclesModel?;

          return _buildLoadMoreListView(frontListData, bannerData,
              frontTopListData, frontListData!.data!.pageCount!, 0);
        },
      ),
    );
  }

  Widget _buildLoadMoreListView(
    FrontArtclesModel? frontListData,
    FrontBannerModel? bannerData,
    FrontTopArtclesModel? frontTopListData,
    int maxPage,
    int firstPage,
  ) {
    final List<Datas>? datas = frontTopListData!.data;
    datas!.addAll(frontListData!.data!.datas!);

    return Consumer<UserViewModel>(
      builder: (context, userViewModel, child) {
        ArticleUtils.updateFavoriteItems(userViewModel, _refreshableListViewKey);

        return RefreshableListView(
          key: _refreshableListViewKey,
          initialItems: datas,
          headWidget: _buildHeadView(bannerData!),
          refreshHeadCallback: () => _refreshHead(bannerData),
          loadMoreCallback: (page) => _loadMoreData(page, firstPage),
          itemBuilder: (context, data, index, length) =>
              _buildListItem(data, index, length),
          maxPage: maxPage,
          firstPage: firstPage,
        );
      },
    );
  }

  Future<List<Datas>?> _loadMoreData(int page, int startPage) async {
    if (startPage == page) {
      //顶部刷新时的加载
      try {
        final topList = await HttpCreator.getFrontTopList();
        final list = await HttpCreator.getFrontList(startPage);
        final datas = topList.data;
        datas!.addAll(list.data!.datas!);
        return datas;
      } catch (e) {
        ToastUtils.showNetWorkErrorToast();
        return null;
      }
    }
    final list =
        await HttpUtils.handleRequestData(() => HttpCreator.getFrontList(page));

    if (list != null) {
      return list.data!.datas;
    } else {
      return null;
    }
  }

  Widget _buildListItem(Datas data, int index, int length) {
    final result = getItemBorderRadius(index, length);
    final BorderRadius borderRadius = result[0];
    final bool isBottomLine = result[1];

    return ChapterListItem(
      datas: data,
      borderRadius: borderRadius,
      isBottomLine: isBottomLine,
    );
  }

  Future<Widget> _refreshHead(FrontBannerModel bannerData) async {
    final banner = await HttpCreator.getBanner();
    return _buildHeadView(banner);
  }

  Widget _buildHeadView(FrontBannerModel frontBannerModel) {
    return CreateCarousel(
      frontBannerModel: frontBannerModel,
    );
  }
}
