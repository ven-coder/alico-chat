import 'package:flutter/material.dart';

class SnackBarUtil {
  static void showSnackBar(BuildContext? context, String? message) {
    if (context != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
              message ?? "",
              style: TextStyle(),
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.fixed),
      );
    }
  }
}
