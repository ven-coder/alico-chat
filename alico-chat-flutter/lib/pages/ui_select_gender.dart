import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:alico_chat/pages/ui_dialog_loading.dart';
import 'package:alico_chat/ui_main.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiSelectGender extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiSelectGender> {
  String _selectValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [],
      ),
      body: Column(
        children: [
          Text("选择性别"),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                  child: RadioListTile(
                      title: Text("男"),
                      value: "1",
                      groupValue: _selectValue,
                      onChanged: (value) {
                        setState(() {
                          _selectValue = value ?? "";
                        });
                      })),
              Flexible(
                  child: RadioListTile(
                      title: Text("女"),
                      value: "2",
                      groupValue: _selectValue,
                      onChanged: (value) {
                        setState(() {
                          _selectValue = value ?? "";
                        });
                      }))
            ],
          ),
          TextButton(
              onPressed: () {
                _setGender();
              },
              child: Text("确定"))
        ],
      ),
    );
  }

  Future<void> _setGender() async {
    if (_selectValue.isEmpty) return;

    UiDialogLoading.show(context, true);

    try {
      var response = await HttpClient.dio.put(HttpUrl.PUT_GENDER, data: {"sex": _selectValue}, options: Options(contentType: HttpClient.FORM)).checkResponse();
      Navigator.pop(context);
      HelperNavigator.push(context, UiMain());
    } catch (e) {
      Navigator.pop(context);
    }
  }
}
