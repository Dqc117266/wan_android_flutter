import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/utils/article_utils.dart';
import 'package:wan_android_flutter/core/utils/http_utils.dart';
import 'package:wan_android_flutter/core/viewmodel/user_viewmodel.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/shared/constants.dart';
import 'package:wan_android_flutter/ui/widgets/chapter_list_item.dart';
import 'package:wan_android_flutter/ui/widgets/custom_future_builder.dart';
import 'package:wan_android_flutter/ui/widgets/refreshable_listView.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/search";

  final GlobalKey? key;
  final String? query;

  const SearchScreen({this.key, this.query}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  GlobalKey<RefreshableListViewState<Datas>> _refreshableListViewKey =
      GlobalKey();

  int page = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.query!),
      ),
      body: Container(
        color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
        child: CustomFutureBuilder(
          onRefresh: () {
            setState(() {});
          },
          future: HttpCreator.query(page, widget.query!),
          builder: (context, snapshot) {
            final FrontArtclesModel frontListData =
                snapshot.data as FrontArtclesModel;

            return Consumer<UserViewModel>(
                builder: (context, userViewModel, child) {
              ArticleUtils.updateFavoriteItems(
                  userViewModel, _refreshableListViewKey);

              return RefreshableListView<Datas>(
                key: _refreshableListViewKey,
                initialItems: frontListData.data!.datas!,
                loadMoreCallback: (page) async {
                  final list = await HttpUtils.handleRequestData(
                      () => HttpCreator.getFrontList(page));

                  if (list != null) {
                    return list.data!.datas;
                  } else {
                    return null;
                  }
                },
                itemBuilder: (context, data, index, length) {
                  final result = getItemBorderRadius(index, length);
                  final BorderRadius borderRadius = result[0];
                  final bool isBottomLine = result[1];

                  return ChapterListItem(
                    datas: data,
                    borderRadius: borderRadius,
                    isBottomLine: isBottomLine,
                  );
                },
                maxPage: frontListData.data!.pageCount!,
                firstPage: 0,
              );
            });
          },
        ),
      ),
    );
  }
}
