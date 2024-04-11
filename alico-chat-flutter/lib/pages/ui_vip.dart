import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/widget_image.dart';

class UiVip extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiVip> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Row(
                      children: [
                        WidgetImage(
                          "assets/images/202309210906616240.png",
                          width: 60,
                          height: 60,
                          isCenterCrop: true,
                          borderRadius: 60,
                        ),
                        Column(
                          children: [
                            Text("nickname"),
                            Row(
                              children: [
                                WidgetImage(
                                  "assets/images/vip.png",
                                  width: 20,
                                  height: 20,
                                ),
                                Text("到期时间：2014-12-09 20:45:23")
                              ],
                            ),
                            Text("未开通")
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              SliverGrid.builder(
                  itemCount: 3,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                  itemBuilder: (context, index) {
                    return Container(
                      child: Column(
                        children: [
                          Text("3个月"),
                          Text("价格：300"),
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
                onPressed: () {},
                child: Text("开通"),
              ),
            ),
            bottom: 0,
          )
        ],
      ),
    );
  }
}
