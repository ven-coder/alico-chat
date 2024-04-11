import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/pages/ui_gold_record.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiGold extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiGold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {
                HelperNavigator.push(context, UiGoldRecord());
              },
              child: Text("金币流水",style: TextStyle(color: Colors.white),))
        ],
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [Text("金币余额：1000"), Text("充值")],
                ),
              ),
              SliverGrid.builder(
                  itemCount: 5,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          Text("￥30"),
                          Text("300金币"),
                        ],
                      ),
                    );
                  })
            ],
          ),
          Positioned(
            child: Container(
              color: Colors.white,
              child: TextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: Column(
                            children: [
                              Text("￥30"),
                              Text("300金币"),
                              Text("支付方式"),
                              Row(
                                children: [
                                  Text("apple pay"),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("google pay"),
                                ],
                              ),
                              Row(
                                children: [
                                  Text("alipay"),
                                ],
                              ),
                              Row(
                                children: [Text("wechat pay")],
                              ),
                              TextButton(onPressed: () {}, child: Text("确认"))
                            ],
                          ),
                        );
                      });
                },
                child: Text("充值"),
              ),
            ),
            bottom: 0,
          )
        ],
      ),
    );
  }
}
