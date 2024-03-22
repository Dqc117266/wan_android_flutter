import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';

// typedef Future<List<T>> LoadMoreCallback<T>(int page);

class RefreshableListView<T> extends StatefulWidget {
  final List<T> initialItems;
  final Future<List<T>?> Function(int page) loadMoreCallback;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final int maxPage; // 添加最大页数参数
  final int startPage;

  const RefreshableListView({
    required this.initialItems,
    required this.loadMoreCallback,
    required this.itemBuilder,
    required this.maxPage, // 初始化最大页数
    required this.startPage,
  });

  @override
  _RefreshableListViewState<T> createState() => _RefreshableListViewState<T>();
}

class _RefreshableListViewState<T> extends State<RefreshableListView<T>> {
  late List<T> items;
  late bool isLoading;
  late ScrollController _scrollController;
  int currentPage = 0; // 添加当前页数
  late LoadState _loadState;

  @override
  void initState() {
    super.initState();
    items = widget.initialItems;
    isLoading = false;
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);

    _loadState = LoadState.success; // 初始化为加载成功状态
    currentPage = widget.startPage + 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          controller: _scrollController,
          itemCount: items.length + 1,
          itemBuilder: (context, index) {
            print("builder list item");
            if (index < items.length) {
              return widget.itemBuilder(context, items[index]);
            } else {
              return _buildLoadStateIndicator();
            }
          },
        ),
      ),
    );
  }

  Future<void> _refresh() async {
    final List<T>? refreshedItems = await widget.loadMoreCallback(1); // 刷新时重置当前页数
    setState(() {
      if (refreshedItems != null) {
        items = refreshedItems;
        currentPage = widget.startPage + 1; // 重置当前页数
        _loadState = LoadState.success;
      } else {
        _loadState = LoadState.empty;
      }
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
      } else if (newItems != null && currentPage == widget.maxPage) { //到达最后一页
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
