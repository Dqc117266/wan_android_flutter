import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';

// typedef Future<List<T>> LoadMoreCallback<T>(int page);

class RefreshableListView<T> extends StatefulWidget {
  final List<T> initialItems;
  final Future<List<T>?> Function(int page) loadMoreCallback;
  final Future<Widget> Function()? refreshHeadCallback;
  final Widget Function(BuildContext context, T item, int index, int length) itemBuilder;
  final int maxPage; // 添加最大页数参数
  final int firstPage;
  Widget? headWidget;

  RefreshableListView({
    Key? key,
    required this.initialItems,
    required this.loadMoreCallback,
    required this.itemBuilder,
    required this.maxPage, // 初始化最大页数
    required this.firstPage,
    this.refreshHeadCallback,
    this.headWidget
  }): super(key: key);

  @override
  RefreshableListViewState<T> createState() => RefreshableListViewState<T>();
}

class RefreshableListViewState<T> extends State<RefreshableListView<T>> with AutomaticKeepAliveClientMixin {
  late List<T> items;
  late bool isLoading;
  late ScrollController _scrollController;
  int currentPage = 0; // 添加当前页数
  late LoadState _loadState;
  int headlength = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    items = widget.initialItems;
    isLoading = false;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _loadState = LoadState.success; // 初始化为加载成功状态
    currentPage = widget.firstPage + 1;
    headlength = widget.headWidget != null? 1 : 0;

    _updataPageState();
  }

  void refreshItems(List<T> newItems) {
    setState(() {
      items = newItems;
      updateIsEmptyPage();
    });
  }

  void refreshListView() {
    updateIsEmptyPage();
  }

  void updateIsEmptyPage() {
    setState(() {
      if (items.length == 0) {
        _loadState = LoadState.empty;
      } else if (items.length == 1) {
        _loadState = LoadState.end;
      }
    });
  }

  void _updataPageState() {
    //只有一页或者只有0页数据为0的时候 为加载到底状态
    if ((currentPage >= widget.maxPage && items.isNotEmpty) || (widget.maxPage == 0 && items.isNotEmpty)) {
      _loadState = LoadState.end;
    } else {
      _loadState = LoadState.empty;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: RefreshIndicator(
        onRefresh: refresh,
        child: ListView.builder(
          padding: EdgeInsets.only(top: 16),
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: items.length + 1 + headlength,
          itemBuilder: (context, index) {
            if (index == 0 && headlength == 1) {
              // 第一个位置是头部视图
              return widget.headWidget!;
            } else if (index < items.length + headlength) {
              // 如果index小于items列表长度，则构建列表项
              return widget.itemBuilder(
                context,
                items[index - headlength], // 考虑头部视图的偏移
                index - headlength, // 考虑头部视图的偏移
                items.length,
              );
            } else {
              // 否则构建加载状态指示器
              return _buildLoadStateIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<void> refresh() async {
    final List<T>? refreshedItems = await widget.loadMoreCallback(widget.firstPage); // 刷新时重置当前页数
    //刷新headview
    if (widget.refreshHeadCallback != null) {
      widget.headWidget = await widget.refreshHeadCallback!();
    }
    setState(() {
      if (refreshedItems != null) {
        items = refreshedItems;
        currentPage = widget.firstPage + 1; // 重置当前页数
        _loadState = LoadState.success;
      }

      _updataPageState();
    });
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange &&
        currentPage <= widget.maxPage) { // 滚动到达底部并且未到达最大页数时触发加载更多
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (!isLoading && _loadState != LoadState.end) {
      setState(() {
        _loadState = LoadState.loading;
        isLoading = true;
      });

      final List<T>? newItems = await widget.loadMoreCallback(currentPage);
      if (newItems == null) {
        setState(() {
          _loadState = LoadState.failed;
          isLoading = false;
          // errorMessage = "Failed to load data"; // Customize the error message
        });
      } else if (currentPage == widget.maxPage) { //到达最后一页
        setState(() {
          items.addAll(newItems);
          _loadState = LoadState.end;
          isLoading = false;
        });
      } else {
        setState(() {
          items.addAll(newItems);
          _loadState = LoadState.success;
          isLoading = false;
          currentPage++;
        });
      }
    }
  }

  Widget _buildLoadStateIndicator() {
    switch (_loadState) {
      case LoadState.loading:
        return _buildLoadingIndicator();
      case LoadState.failed:
        return _buildFailedIndicator();
      case LoadState.success:
        return SizedBox(height: 32); // 加载成功时不显示加载状态
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
        _loadMore();
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
    _scrollController.dispose();
    super.dispose();
  }
}
