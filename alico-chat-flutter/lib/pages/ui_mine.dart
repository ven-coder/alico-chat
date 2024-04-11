import 'package:alico_chat/entity/entity_user.dart';
import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/helper/snack_bar.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/pages/ui_edit_profile.dart';
import 'package:alico_chat/pages/ui_gold.dart';
import 'package:alico_chat/login/ui_login.dart';
import 'package:alico_chat/pages/ui_image_preview.dart';
import 'package:alico_chat/pages/ui_my_comment_list.dart';
import 'package:alico_chat/pages/ui_my_follow_list.dart';
import 'package:alico_chat/pages/ui_my_share_list.dart';
import 'package:alico_chat/pages/ui_person_auth.dart';
import 'package:alico_chat/pages/ui_vip.dart';
import 'package:alico_chat/widget/widget_gender.dart';
import 'package:alico_chat/widget/widget_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiMine extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiMine> {
  EntityUser? _user;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        leading: SizedBox(),
        actions: [
          InkWell(
            child: Container(
              margin: EdgeInsets.only(right: 15),
              width: 40,
              height: 40,
              child: Image.asset(
                "assets/images/edit_profile.png",
              ),
            ),
            onTap: () async {
              await HelperNavigator.push(context, UiEditProfile());
              _getData();
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              child: InkWell(
                child: WidgetImage(
                  _user?.avatar ?? "",
                  width: 100,
                  height: 100,
                  isCenterCrop: true,
                  borderRadius: 60,
                ),
                onTap: () {
                  HelperNavigator.push(context, UiImagePreview(_user?.avatar ?? ""));
                },
              ),
              alignment: AlignmentDirectional.center,
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              _user?.nickname ?? "",
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(
              height: 15,
            ),
            WidgetGender(_user?.sex ?? 0, _user?.vip ?? 0, _user?.real ?? 0),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Colors.orangeAccent, borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.card_membership,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("VIP"),
                              Text("开通/续费"),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    // HelperNavigator.push(context, UiVip());
                    _showMessage("");
                  },
                )),
                Expanded(
                    child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: 15, left: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.verified, color: Colors.white),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("真人认证"),
                              Text(""),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    // HelperNavigator.push(context, UiPersonAuth());
                    _showMessage("");
                  },
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8, bottom: 8),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Icon(
                            Icons.monetization_on,
                            color: Colors.orange,
                            size: 54,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text("我的金币"),
                              Text(""),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    // HelperNavigator.push(context, UiGold());
                    _showMessage("");
                  },
                )),
                Expanded(
                    child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: 15, left: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Color(0xffe4e7e7), borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.featured_play_list_rounded,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            children: [
                              Text("我的动态"),
                              Text(""),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    // HelperNavigator.push(
                    //     context,
                    //     UiMyShareList(
                    //       userId: "",
                    //       nickname: "",
                    //     ));
                    _showMessage("");
                  },
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Color(0xffe4e7e7), borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.follow_the_signs,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("我的关注"),
                              Text(""),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    // HelperNavigator.push(context, UiMyFollowList());
                    _showMessage("");
                  },
                )),
                Expanded(
                    child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(right: 15, left: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Color(0xffe4e7e7), borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.messenger,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("我的评论"),
                              Text(""),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    // HelperNavigator.push(context, UiMyCommentList());
                    _showMessage("");
                  },
                ))
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Expanded(
                    child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: 15, right: 5),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Color(0xffe4e7e7), borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.thumb_up_alt_rounded,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("我的点赞"),
                              Text(""),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    // HelperNavigator.push(context, UiMyFollowList());
                    _showMessage("");
                  },
                )),
                Expanded(
                    child: InkWell(
                  child: Container(
                    margin: EdgeInsets.only(left: 5, right: 15),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 5), // changes position of shadow
                      ),
                    ]),
                    child: Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(color: Color(0xffe4e7e7), borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.logout,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("退出登录"),
                              Text(""),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
                  },
                )),
              ],
            )
          ],
        ),
      ),
    );
  }


  Future<void> _getData() async {
    try {
      var user = await EntityUser.getAccountUser();
      setState(() {
        _user = user;
      });
    } catch (e) {}
  }

  void _showMessage(String value) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('提示'),
          content: Text('开发中...'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // 关闭对话框
                Navigator.of(context).pop();
              },
              child: Text('关闭'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('确认退出登录'),
          content: Text('您确定要退出登录吗？'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // 关闭对话框
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                // 执行退出登录操作，例如清除用户信息等

                EntityUser.removeAccountUser();
                HelperNavigator.pushRemove(context, UiLogin());
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }
}
