import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/widget_image.dart';

class UiGoldRecord extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiGoldRecord> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  return Container(
                    child: Row(
                      children: [
                        WidgetImage(
                          "assets/images/202309210906616240.png",
                          width: 50,
                          height: 50,
                          isCenterCrop: true,
                          borderRadius: 30,
                        ),
                        Column(
                          children: [
                            Row(
                              children: [Text("充值"), Text("+10")],
                            ),
                            Text("2032-09-08 12:34:43")
                          ],
                        )
                      ],
                    ),
                  );
                }, childCount: 10),
              )
            ],
          ),
        ],
      ),
    );
  }
}
