import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/network/http_creator.dart';
import 'package:wan_android_flutter/ui/pages/front/load_more_sliverlist.dart';

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
      appBar: AppBar(title: Text(widget.query!),),
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
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(LocaleKeys.front_dataLoadingFailed.tr()),
                    SizedBox(
                      height: 4,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {}); // 这里强制刷新，可以根据需要进行实际的重新加载操作
                      },
                      child: Icon(Icons.refresh),
                    ),
                  ],
                ),
              );
            } else {
              final FrontArtclesModel frontListData =
                  snapshot.data as FrontArtclesModel;

              return RefreshIndicator(
                onRefresh: () {
                  return Future(() => setState(() {}));
                },
                child: LoadModeSliverList(
                  frontListData: frontListData,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
