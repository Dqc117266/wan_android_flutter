import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/widgets/chapter_list_item.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';

import '../../core/model/front_top_artcles_model.dart';
import '../pages/front/banner/create_carousel.dart';

class LoadModeSliverList extends StatefulWidget {
  final FrontBannerModel? bannerData;
  final FrontTopArtclesModel? frontTopListData;
  final FrontArtclesModel? frontListData;

  const LoadModeSliverList({
    super.key,
    this.bannerData,
    this.frontTopListData,
    this.frontListData,
  });

  @override
  State<LoadModeSliverList> createState() => _LoadModeSliverListState();
}

class _LoadModeSliverListState extends State<LoadModeSliverList> {
  ScrollController _scrollController = ScrollController();
  late List<Datas>? _datas = [];

  bool _isLoading = false;
  int _page = 1;
  int maxPage = 0;

  LoadState _loadState = LoadState.success;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _datas!.addAll(widget.frontTopListData!.data as Iterable<Datas>);
    if (widget.frontTopListData != null &&
        widget.frontTopListData!.data! != null) {
      _datas!.addAll(widget.frontTopListData!.data!);
    }

    if (widget.frontListData!.data! != null &&
        widget.frontListData!.data!.datas! != null) {
      _datas!.addAll(widget.frontListData!.data!.datas!);
      maxPage = widget.frontListData!.data!.pageCount!;
    }

    print("maxPage: ${maxPage}");
    _scrollController.addListener(_onScroll);

    //只有一页或者只有0页数据为0的时候 为加载到底状态
    if (maxPage == _page || (maxPage == 0 && _datas!.length != 0)) {
      _loadState = LoadState.end;
    } else if (maxPage == 0 && _datas!.length == 0) {
      _loadState = LoadState.empty;
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      if (_page < maxPage) {
        _loadModeData();
      } else {
        setState(() {
          _loadState = LoadState.end;
        });
      }
    }
  }

  void _loadModeData() async {
    setState(() {
      _loadState = LoadState.loading;
      _isLoading = true;
    });

    try {
      final getFrontList = await HttpCreator.getFrontList(_page);

      if (getFrontList.errorCode != null && getFrontList.errorCode != 0) {
        _setFailedState();
      } else {
        setState(() {
          _datas!.addAll(getFrontList.data!.datas!);
          _isLoading = false;
          _page++;
          _loadState = LoadState.success;
        });
      }
    } catch (e) {
      _setFailedState();
    }
  }

  void _setFailedState() {
    setState(() {
      _isLoading = false;
      _loadState = LoadState.failed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        controller: _scrollController,
        slivers: [
          //加载轮播图
          if (widget.bannerData != null)
            SliverToBoxAdapter(
              child: CreateCarousel(
                frontBannerModel: widget.bannerData!,
              ),
            ),

          SliverPadding(
            padding: EdgeInsets.only(top: 16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final BorderRadius borderRadius;
                  bool isBottomLine = true;
                  if (index == 0) {
                    borderRadius = BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12));
                  } else if (index == _datas!.length - 1) {
                    borderRadius = BorderRadius.only(bottomLeft: Radius.circular(12), bottomRight: Radius.circular(12));
                    isBottomLine = false;
                  } else {
                    borderRadius = BorderRadius.zero;
                  }

                  return ChapterListItem(datas: _datas![index], borderRadius: borderRadius, isBottomLine: isBottomLine,);
                },
                childCount: _datas!.length,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: _buildLoadStateIndicator(),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadStateIndicator() {
    switch (_loadState) {
      case LoadState.loading:
        return _buildLoadingIndicator();
      case LoadState.failed:
        return _buildFailedIndicator();
      case LoadState.success:
        return SizedBox(height: 32);
      case LoadState.end:
        return _buildEndIndicator();
      case LoadState.empty:
        return _buildEmptyIndicator();
    }
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildEndIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Text(LocaleKeys.front_dataEnd.tr()),
      ),
    );
  }

  Widget _buildFailedIndicator() {
    return GestureDetector(
      onTap: () {
        _loadModeData();
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Text(LocaleKeys.front_dataLoadingFailed.tr()),
        ),
      ),
    );
  }

  Widget _buildEmptyIndicator() {
    return Center(
      child: Text(LocaleKeys.front_dataEmpty.tr()),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

}
