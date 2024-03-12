import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/model/front_articles_model.dart';
import 'package:wan_android_flutter/core/model/front_banner_model.dart';
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
    return FutureBuilder(
      future: Future.wait([
        HttpCreator.getBanner(),
        HttpCreator.getFrontList(0),
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final bannerData = (snapshot.data as List)[0] as FrontBannerModel;
          final frontListData = (snapshot.data as List)[1] as FrontArtclesModel;

          return LoadModeSliverList(bannerData, frontListData);
        }
      },
    );
  }
}
