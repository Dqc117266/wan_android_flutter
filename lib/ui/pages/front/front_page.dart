import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/lang/locale_keys.g.dart';
import '../../../network/http_creator.dart';

class FrontScreen extends StatelessWidget {
  static const routeName = "/front";

  const FrontScreen({super.key});

  @override
  Widget build(BuildContext context) {

    // var collectChapter = HttpCreator.collectChapter(1165);
    // collectChapter.then((value) => {
    //   print(value.toString())
    // });

    return Scaffold(
      body: Center(
        child: Text("首页"),
      ),
    );
  }
}
