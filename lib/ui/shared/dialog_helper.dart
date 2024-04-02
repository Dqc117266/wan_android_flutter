import 'package:flutter/material.dart';

class DialogHelper {
  static void showAlertDialog({
    required BuildContext context,
    Widget? title,
    Widget? content,
    String? dismissText,
    String? actionText,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: title != null ? title : null,
        content: content != null ? content : null,
        actions: <Widget>[
          if (dismissText != null)
            TextButton(
              child: Text(dismissText),
              onPressed: () {
                Navigator.of(context).pop();
                if (onDismiss != null) {
                  onDismiss();
                }
              },
            ),
          if (actionText != null)
            FilledButton(
              child: Text(actionText),
              onPressed: () {
                Navigator.of(context).pop();
                if (onAction != null) {
                  onAction();
                }
              },
            ),
        ],
      ),
    );
  }

  static void showLoadingDialog(BuildContext context, String content) {
    showDialog(
      context: context,
      barrierDismissible: false, // 设置点击外部无法关闭对话框
      builder: (BuildContext context) {
        return AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(), // 加载转圈动画
              SizedBox(width: 20),
              Text(content), // 提示文本
            ],
          ),
        );
      },
    );
  }

}
