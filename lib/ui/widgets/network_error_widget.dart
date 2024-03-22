import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/core/lang/locale_keys.g.dart';

class NetWorkErrorWidget extends StatefulWidget {
  final VoidCallback onRefresh;

  const NetWorkErrorWidget({Key? key, required this.onRefresh}) : super(key: key);

  @override
  State<NetWorkErrorWidget> createState() => _NetWorkErrorWidgetState();
}

class _NetWorkErrorWidgetState extends State<NetWorkErrorWidget> {
  @override
  Widget build(BuildContext context) {
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
              // 调用传递过来的刷新回调函数
              widget.onRefresh();
            },
            child: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
