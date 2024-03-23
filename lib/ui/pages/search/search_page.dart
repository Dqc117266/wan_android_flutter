import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/utils/toast_utils.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/front/sliver_list_item.dart';
import 'package:wan_android_flutter/ui/shared/refreshable_listView.dart';
import 'package:wan_android_flutter/ui/widgets/network_error_widget.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search";

  final GlobalKey? key;
  final String? query;

  const SearchScreen({this.key, this.query}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  int page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("search screen query: ${widget.query}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.query!),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        child: FutureBuilder(
          future: HttpCreator.query(page, widget.query!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError || snapshot.data == null) {
              // 检查是否有错误或数据为空
              return NetWorkErrorWidget(onRefresh: () => setState(() {}));
            } else {
              final FrontArtclesModel frontListData =
                  snapshot.data as FrontArtclesModel;

              return RefreshableListView<Datas>(
                initialItems: frontListData.data!.datas!,
                loadMoreCallback: (page) async {
                  try {
                    final list = await HttpCreator.query(page, widget.query!);
                    return list.data!.datas;
                  } catch (e) {
                    ToastUtils.showNetWorkErrorToast();
                    return null;
                  }
                },

                itemBuilder: (context, data, index, length) {
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
                },
                maxPage: frontListData.data!.pageCount!,
                startPage: 0,
              );
            }
          },
        ),
      ),
    );
  }
}
