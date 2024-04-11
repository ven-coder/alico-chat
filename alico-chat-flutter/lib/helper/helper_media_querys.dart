import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HelperMediaQuerys {
  static double getStatusAndAppBarHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top + AppBar().preferredSize.height;
  }

  static double getStatusHeight(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }
}
