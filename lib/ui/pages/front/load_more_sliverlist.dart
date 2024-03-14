import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';

import 'banner/create_carousel.dart';

class LoadModeSliverList extends StatefulWidget {
  final FrontBannerModel? bannerData;
  final FrontArtclesModel? frontListData;

  const LoadModeSliverList(this.bannerData, this.frontListData, {super.key});

  @override
  State<LoadModeSliverList> createState() => _LoadModeSliverListState();
}

class _LoadModeSliverListState extends State<LoadModeSliverList> {
  late int maxPage;
  ScrollController _scrollController = ScrollController();
  late List<Datas>? _datas = [];

  bool _isLoading = false;
  int _page = 1;
  LoadState _loadState = LoadState.success;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _datas = widget.frontListData!.data!.datas;
    maxPage = widget.frontListData!.data!.pageCount!;

    print("maxPage: ${maxPage}");
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        !_isLoading) {
      _loadModeData();
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
        controller: _scrollController,
        slivers: [
          //加载轮播图
          SliverToBoxAdapter(
            child: CreateCarousel(
              frontBannerModel: widget.bannerData!,
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: ListTile(
                    title: Text(_datas![index].title!),
                  ),
                );
              },
              childCount: _datas!.length,
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

}
