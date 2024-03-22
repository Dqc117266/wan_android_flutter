import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';
import 'package:wan_android_flutter/core/model/front_top_artcles_model.dart';
import 'package:wan_android_flutter/ui/pages/front/load_more_sliverlist.dart';
import 'package:wan_android_flutter/ui/pages/search/custom_search_delegate.dart';
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

            return RefreshIndicator(
                onRefresh: () {
                  return Future(() => setState(() {}));
                },
                child: LoadModeSliverList(
                    bannerData: bannerData!,
                    frontTopListData: frontTopListData,
                    frontListData: frontListData!));
          }
        },
      ),
    );
  }
}
