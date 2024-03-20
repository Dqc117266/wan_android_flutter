import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';
import 'package:wan_android_flutter/core/model/front_top_artcles_model.dart';
import 'package:wan_android_flutter/ui/pages/front/load_more_sliverlist.dart';

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
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.3),
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
