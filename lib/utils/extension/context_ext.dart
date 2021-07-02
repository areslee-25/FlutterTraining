import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  void showSnackBar(
    String message, [
    Duration duration = const Duration(seconds: 3),
  ]) {
    final messengerState = ScaffoldMessenger.maybeOf(this);
    if (messengerState == null) {
      return;
    }
    messengerState.hideCurrentSnackBar();
    messengerState.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }

  void showLoading() {
    showDialog<void>(
      context: this,
      barrierDismissible: false,
      useSafeArea: false,
      builder: (context) {
        return const Material(
          type: MaterialType.transparency,
          child: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void showAlertDialog(
    String message,
    VoidCallback action,
  ) {
    showDialog(
      context: this,
      builder: (_) => CupertinoAlertDialog(
        content: Text(message),
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text("OK"),
            isDefaultAction: true,
            onPressed: action,
          )
        ],
      ),
    );
  }
}
