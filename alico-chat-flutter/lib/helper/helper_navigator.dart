import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelperNavigator {
  static Future<dynamic> push(BuildContext context, Widget widget) async {
    return await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return widget;
    }));
  }

  static Future<dynamic> pushRemove(BuildContext context, Widget widget) async {
    return await Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return widget;
    }), (route) {
      return false;
    });
  }
}
