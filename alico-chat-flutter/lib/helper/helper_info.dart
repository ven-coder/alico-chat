import 'dart:io';

import 'package:device_info/device_info.dart';
import 'package:device_info/device_info.dart' as device_info;
import 'package:package_info_plus/package_info_plus.dart';

class HelperInfo {
  static Future<String> getDeviceUnique() async {
    String identifierForVendor = "";
    if (Platform.isAndroid) {
      device_info.DeviceInfoPlugin deviceInfo = device_info.DeviceInfoPlugin();
      var androidDeviceInfo = await deviceInfo.androidInfo;
      identifierForVendor = androidDeviceInfo.androidId;
    }
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var iosDeviceInfo = await deviceInfo.iosInfo;
      identifierForVendor = iosDeviceInfo.identifierForVendor ?? "";
    }
    return identifierForVendor;
  }

  static Future<PackageInfo> getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  }

  static Future<String> getModel() async {
    String model = "";
    if (Platform.isAndroid) {
      device_info.DeviceInfoPlugin deviceInfo = device_info.DeviceInfoPlugin();
      var androidDeviceInfo = await deviceInfo.androidInfo;
      model = androidDeviceInfo.model;
    }
    if (Platform.isIOS) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      var iosDeviceInfo = await deviceInfo.iosInfo;
      model = iosDeviceInfo.model ?? "";
    }
    return model;
  }
}
