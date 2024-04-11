import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiPersonAuth extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiPersonAuth> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Text("1. 选择一张自拍照"),
          Container(
            width: 100,
            height: 100,
            color: Colors.grey,
          ),
          Text("2. 自拍认证"),
          Container(
            width: 100,
            height: 100,
            color: Colors.grey,
          )
        ],
      ),
    );
  }
}
