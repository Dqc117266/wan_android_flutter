import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/tree_model.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/ui/widgets/network_error_widget.dart';
import 'package:wan_android_flutter/ui/widgets/tab_content_page.dart';

class TabbedPage extends StatefulWidget {
  final String title;
  final Future<TreeModel?> Function() getTreeModel;
  final Future<FrontArtclesModel> Function(int, int) getDataList;

  const TabbedPage(
      {super.key,
      required this.title,
      required this.getTreeModel,
      required this.getDataList});

  @override
  State<TabbedPage> createState() => _TabbedPageState();
}

class _TabbedPageState extends State<TabbedPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late TabController _tabController;
  late PageController _pageController;
  TreeModel? _treeModel;
  bool _isLoading = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getTreeModel();
  }

  Future<void> getTreeModel() async {
    _treeModel = await HttpUtils.handleRequestData(widget.getTreeModel);

    if (_treeModel != null) {
      _tabController =
          TabController(length: _treeModel!.data!.length, vsync: this);
      _pageController = PageController();
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    TabBar? tabBar;
    Widget bodyWidget;
    if (_isLoading) {
      bodyWidget = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (_treeModel == null) {
      bodyWidget = NetWorkErrorWidget(
        onRefresh: () => getTreeModel(),
      );
    } else {
      tabBar = TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: _treeModel!.data!.map((element) => Text(element.name!)).toList(),
        onTap: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.ease,
          );
        },
      );

      bodyWidget = PageView(
        controller: _pageController,
        children: _treeModel!.data!
            .map((element) => TabContentPage(
                  dataItem: element,
                  getDataList: widget.getDataList,
                ))
            .toList(),
        onPageChanged: (index) {
          _tabController
              .animateTo(index); // Ensure tab changes when page changes
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        bottom: tabBar,
      ),
      backgroundColor:
          Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.45),
      body: bodyWidget,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
