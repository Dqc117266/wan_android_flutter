import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';
import 'package:wan_android_flutter/core/model/front_top_artcles_model.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/ui/pages/front/banner/create_carousel.dart';
import 'package:wan_android_flutter/ui/pages/front/sliver_list_item.dart';
import 'package:wan_android_flutter/ui/pages/search/custom_search_delegate.dart';
import 'package:wan_android_flutter/ui/shared/refreshable_listView.dart';
import 'package:wan_android_flutter/ui/widgets/network_error_widget.dart';

import '../../../network/http_creator.dart';

class FrontScreen extends StatefulWidget {
  static const routeName = "/front";

  FrontScreen({super.key});

  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
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
      body: FutureBuilder(
        future: Future.wait([
          HttpCreator.getBanner(),
          HttpCreator.getFrontTopList(),
          HttpCreator.getFrontList(0),
        ]),
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
            final List<Object> data = snapshot.data as List<Object>;
            final FrontBannerModel? bannerData = data[0] as FrontBannerModel?;
            final FrontTopArtclesModel? frontTopListData =
                data[1] as FrontTopArtclesModel?;
            final FrontArtclesModel? frontListData =
                data[2] as FrontArtclesModel?;

            return _buildLoadMoreListView(frontListData, bannerData,
                frontTopListData, frontListData!.data!.pageCount!, 0);
          }
        },
      ),
    );
  }

  Widget _buildLoadMoreListView(
      FrontArtclesModel? frontListData,
      FrontBannerModel? bannerData,
      FrontTopArtclesModel? frontTopListData,
      int maxPage,
      int startPage,
      ) {
    final List<Datas>? datas = frontTopListData!.data;
    datas!.addAll(frontListData!.data!.datas!);

    return RefreshableListView(
      initialItems: datas,
      headWidget: _buildHeadView(bannerData!),
      refreshHeadCallback: () => _refreshHead(bannerData),
      loadMoreCallback: (page) => _loadMoreData(page, startPage),
      itemBuilder: (context, data, index, length) => _buildListItem(data, index, length),
      maxPage: maxPage,
      startPage: startPage,
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
    try {
      final list = await HttpCreator.getFrontList(page);
      return list.data!.datas;
    } catch (e) {
      ToastUtils.showNetWorkErrorToast();
      return null;
    }
  }

  Widget _buildListItem(Datas data, int index, int length) {
    final BorderRadius borderRadius;
    bool isBottomLine = true;
    if (index == 0) {
      borderRadius = BorderRadius.only(
          topLeft: Radius.circular(12), topRight: Radius.circular(12));
    } else if (index == length - 1) {
      borderRadius = BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12));
      isBottomLine = false;
    } else {
      borderRadius = BorderRadius.zero;
    }
    return SliverListItem(
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
