import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../pages/ui_dialog_loading.dart';

class UiEmailLogin extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiEmailLogin> {
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
              Container(
                margin: EdgeInsets.only(left: 50, right: 50),
                child: TextField(
                  decoration: InputDecoration(labelText: "邮箱"),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                margin: EdgeInsets.only(left: 50, right: 50),
                child: Row(
                  children: [
                    Flexible(
                      child: TextField(
                        decoration: InputDecoration(labelText: "验证码"),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          _sendCode();
                        },
                        child: Text("发送验证码"))
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Align(
                alignment: AlignmentDirectional.centerEnd,
                child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: 50),
                    height: 50,
                    width: 100,
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
      await HttpClient.dio.post(HttpUrl.LOGIN, data: {}, options: Options(contentType: HttpClient.FORM));
    } catch (e) {
      print(e);
    } finally {
      Navigator.pop(context);
    }
  }

  void _sendCode() {}
}
