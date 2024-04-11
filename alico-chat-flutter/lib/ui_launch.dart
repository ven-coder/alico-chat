import 'package:alico_chat/entity/entity_user.dart';
import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/helper/helper_rongclond.dart';
import 'package:alico_chat/helper/helper_sp.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/login/ui_login.dart';
import 'package:alico_chat/pages/ui_exist_user_list.dart';
import 'package:alico_chat/ui_main.dart';
import 'package:flutter/material.dart';

class UiLaunch extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _UiLaunch();
  }
}

class _UiLaunch extends State<UiLaunch> {
  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: AlignmentDirectional.center,
        children: [
          Positioned.fill(
              child: Container(
            child: SizedBox(),
            color: Color(0xff49F4FF),
          )),
          Align(
            child: Text("launch"),
            alignment: AlignmentDirectional.center,
          )
        ],
      ),
    );
  }

  Future<void> init() async {
    await HelperSp.init();
    HttpClient.init();
    await HelperRongclond.init();
    var account = await EntityUser.getAccountUser();
    if (account == null) {
      HelperNavigator.pushRemove(context, UiLogin());
    } else {
      HelperRongclond.connect();
      HelperNavigator.pushRemove(context, UiMain());
    }
  }
}
