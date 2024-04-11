import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiDialogCenter extends StatelessWidget {
  Widget child;

  UiDialogCenter(this.child);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.zero, backgroundColor: Colors.transparent, shadowColor: Colors.transparent, surfaceTintColor: Colors.transparent, elevation: 0, child: child);
  }

  static void show(
    BuildContext context,
    Widget child,
    bool barrierDismissible,
  ) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: Colors.transparent,
        builder: (context) {
          return UiDialogCenter(child);
        });
  }
}
