import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiDialogLoading extends StatelessWidget {
  UiDialogLoading();

  @override
  Widget build(BuildContext context) {
    return Dialog(
        insetPadding: EdgeInsets.zero,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ]),
              width: 50,
              height: 50,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: CircularProgressIndicator(
                  color: Colors.blue,
                  strokeWidth: 3,
                ),
              ),
            )
          ],
        ));
  }

  static void show(BuildContext context, bool barrierDismissible) {
    showDialog(
        context: context,
        barrierDismissible: barrierDismissible,
        barrierColor: Colors.transparent,
        builder: (context) {
          return UiDialogLoading();
        });
  }
}
