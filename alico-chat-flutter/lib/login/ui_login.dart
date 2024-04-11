import 'dart:io';

import 'package:alico_chat/helper/helper_info.dart';
import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/helper/snack_bar.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:alico_chat/pages/ui_exist_user_list.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../entity/entity_user.dart';
import '../pages/ui_dialog_loading.dart';
import '../ui_main.dart';
import '../pages/ui_select_gender.dart';

class UiLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiLogin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(20)),
            child: Center(
              child: Text(
                "AlicoChat",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Column(
            children: [
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: 50, left: 50),
                  height: 50,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "选择已有用户",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () {
                  HelperNavigator.push(context, UiExistUserList());
                },
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: 50, left: 50),
                  height: 50,
                  alignment: AlignmentDirectional.center,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "快捷登录",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () {
                  _login();
                },
              ),
              Visibility(
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: 50, left: 50),
                    height: 50,
                    alignment: AlignmentDirectional.center,
                    decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      "登录",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  onTap: () {
                    _login();
                  },
                ),
                visible: false,
              ),
            ],
          ),
          SizedBox(),
          SizedBox(),
        ],
      ),
    );
  }

  Future<void> _login() async {
    UiDialogLoading.show(context, true);
    try {
      String deviceId = await HelperInfo.getDeviceUnique();
      var data =
          await HttpClient.dio.post(HttpUrl.LOGIN, data: {"deviceId": deviceId}, options: Options(contentType: HttpClient.FORM)).checkResponse();
      Navigator.pop(context);
      await EntityUser.saveAccount(data);
      var sex = data["sex"];
      if (sex == 1 || sex == 2) {
        HelperNavigator.push(context, UiMain());
      } else {
        HelperNavigator.push(context, UiSelectGender());
      }
    } catch (e) {
      SnackBarUtil.showSnackBar(context, "登录失败：$e");
      Navigator.pop(context);
    }
  }

  void _sendCode() {}
}
