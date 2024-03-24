import 'package:flutter/material.dart';
import 'package:wan_android_flutter/ui/widgets/network_error_widget.dart';

class CustomFutureBuilder extends FutureBuilder {
  final Function? onRefresh;
  CustomFutureBuilder({
    this.onRefresh,
    required Future future,
    required Widget Function(BuildContext context, AsyncSnapshot snapshot) builder,
  }) : super(
    future: future,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (snapshot.hasError || snapshot.data == null) {
        // 检查是否有错误或数据为空
        return NetWorkErrorWidget(
          onRefresh: () => onRefresh != null ? onRefresh() : null,
        );
      } else {
        return builder(context, snapshot);
      }
    },
  );
}
