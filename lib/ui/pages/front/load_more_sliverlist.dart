import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';
import 'package:wan_android_flutter/network/http_creator.dart';

import 'banner/create_carousel.dart';

class LoadModeSliverList extends StatefulWidget {
  final FrontBannerModel bannerData;
  final FrontArtclesModel frontListData;

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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _datas = widget.frontListData.data!.datas;
    maxPage = widget.frontListData.data!.pageCount!;

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
      _isLoading = true;
    });

    final getFrontList = await HttpCreator.getFrontList(_page);

    setState(() {
      _datas!.addAll(getFrontList.data!.datas!);
      _isLoading = false;
      _page++;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          //加载轮播图
          SliverToBoxAdapter(
            child: CreateCarousel(
              frontBannerModel: widget.bannerData,
            ),
          ),

          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return Card(
              margin: EdgeInsets.all(16),
              child: ListTile(
                title: Text(_datas![index].title!),
              ),
            );
          }, childCount: _datas!.length)),
        ],
      ),
    );
  }

}
