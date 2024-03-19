import 'package:flutter/material.dart';

class DialogHelper {
  static void showAlertDialog({
    required BuildContext context,
    String? title,
    String? content,
    String? dismissText,
    String? actionText,
    VoidCallback? onDismiss,
    VoidCallback? onAction,
  }) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
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
}
