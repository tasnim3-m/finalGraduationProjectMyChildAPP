import "package:flutter/material.dart";

extension ContextExtention on BuildContext {
  void sendToNextScreen(String routs, {Object? arg}) {
    if (arg == null) {
      Navigator.of(this).pushNamed(routs);
    } else {
      Navigator.of(this).pushNamed(routs, arguments: arg);
    }
  }

  void popScreen() {
    if (Navigator.of(this).canPop()) Navigator.of(this).pop();
  }

  void pushRemoveUntil(String routs) {
    Navigator.of(this).pushReplacementNamed(routs);
  }

  void showAppSnackBar({required String message}) {
    ScaffoldMessenger.of(this).clearSnackBars();
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(
        message,
      ),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: "Dismiss",
        onPressed: () {
          if (mounted) ScaffoldMessenger.of(this).clearSnackBars();
        },
      ),
    ));
  }
}
