import 'package:alico_chat/helper/helper_media_querys.dart';
import 'package:alico_chat/pages/ui_share_details.dart';
import 'package:alico_chat/widget/widget_gender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/widget_image.dart';

class UiMyCommentList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiMyCommentList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView.builder(
        padding: EdgeInsets.only(left: 10, right: 10, top: 0),
        itemBuilder: (context, index) {
          return InkWell(
            child: Container(
              margin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: Offset(0, 5), // changes position of shadow
                ),
              ]),
              child: Container(
                child: Row(
                  children: [
                    ClipRRect(
                      child: Image.asset(
                        "assets/images/202309210906616240.png",
                        height: 50,
                        width: 50,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Text("data"),
                            SizedBox(
                              height: 5,
                            ),
                            WidgetGender(1,0,0),
                            Expanded(child: SizedBox()),
                            Text("2012-09-08 12:34:23")
                          ],
                        ),
                        Text("评论内容评论内容评论内容评论内容评论内容评论内容评论内容"),
                        Container(
                          child: Row(
                            children: [
                              WidgetImage(
                                "assets/images/202309210906616240.png",
                                width: 120,
                                height: 120,
                                isCenterCrop: true,
                              ),
                              Flexible(child: Text("动态内容动态内容动态内容动态内容动态内容动态内容动态内容动态内容动态内容"))
                            ],
                          ),
                        )
                      ],
                    ))
                  ],
                ),
                margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return UiShareDetails(id: '',);
              }));
            },
          );
        },
        itemCount: 100,
      ),
    );
  }
}

class _ImageItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(bottom: 5, right: 5),
      width: (HelperMediaQuerys.getScreenWidth(context) - 50) / 3,
      height: (HelperMediaQuerys.getScreenWidth(context) - 50) / 3,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(
          "assets/images/202309210906616240.png",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
