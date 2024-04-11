import 'package:alico_chat/entity/entity_share_list.dart';
import 'package:alico_chat/entity/entity_user.dart';
import 'package:alico_chat/helper/helper_media_querys.dart';
import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:alico_chat/pages/ui_conversation.dart';
import 'package:alico_chat/pages/ui_dialog_loading.dart';
import 'package:alico_chat/pages/ui_image_preview.dart';
import 'package:alico_chat/pages/ui_my_share_list.dart';
import 'package:alico_chat/widget/widget_gender.dart';
import 'package:alico_chat/widget/widget_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UiUserDetails extends StatefulWidget {
  String userId;

  UiUserDetails({required this.userId});

  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiUserDetails> {
  EntityUser? _user;
  List<ListElement> _listShare = [];
  PageController _pageController = PageController();
  int _albumsPosition = 0;
  bool _isFollow = false;
  EUserInfo? _userInfo;
  bool _isVisibleBottomButton = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageListener);
    _getData();
    _getUserInfo();
    _getFollow();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          Positioned.fill(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1 / 1,
                  child: Stack(
                    children: [
                      PageView(
                        controller: _pageController,
                        children: [
                          for (Album item in _user?.albums ?? [])
                            InkWell(
                              child: WidgetImage(
                                item.image ?? "",
                                isCenterCrop: true,
                              ),
                              onTap: () {
                                HelperNavigator.push(context, UiImagePreview(item.image ?? ""));
                              },
                            ),
                        ],
                      ),
                      Positioned(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(color: Color(0xff80000000), borderRadius: BorderRadius.circular(50)),
                          child: Text(
                            "$_albumsPosition/${_user?.albums?.length ?? 0}",
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        bottom: 0,
                        right: 0,
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        child: WidgetImage(
                          _user?.avatar ?? "",
                          height: 50,
                          isCenterCrop: true,
                          borderRadius: 30,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user?.nickname ?? "",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          WidgetGender(_user?.sex ?? 0, _user?.vip ?? 0, _user?.real ?? 0)
                        ],
                      )
                    ],
                  ),
                  margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                ),
                Container(
                  child: Text(
                    "相册",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  margin: EdgeInsets.only(left: 10, top: 15),
                ),
                Container(
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 5,
                    children: [
                      for (Album value in _user?.albums ?? [])
                        InkWell(
                          child: WidgetImage(
                            value.image ?? "",
                            width: (HelperMediaQuerys.getScreenWidth(context) - 30) / 3,
                            height: (HelperMediaQuerys.getScreenWidth(context) - 30) / 3,
                            borderRadius: 10,
                            isCenterCrop: true,
                          ),
                          onTap: () {
                            HelperNavigator.push(context, UiImagePreview(value.image ?? ""));
                          },
                        ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                ),
                Container(
                  child: Text(
                    "动态",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  margin: EdgeInsets.only(left: 10, top: 15),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 10),
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          child: AspectRatio(
                            aspectRatio: 1 / 1.25,
                            child: _getShareContent(index),
                          ),
                          margin: EdgeInsets.only(right: 5),
                        ),
                        onTap: () {
                          HelperNavigator.push(
                              context,
                              UiMyShareList(
                                userId: widget.userId,
                                nickname: _user?.nickname ?? "",
                              ));
                        },
                      );
                    },
                    itemCount: _listShare.length,
                  ),
                ),
                Container(
                  child: Text(
                    "个人信息",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  margin: EdgeInsets.only(left: 10, top: 15),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Color(0xffeeecec), borderRadius: BorderRadius.circular(5)),
                  child: Wrap(
                    spacing: 5,
                    runSpacing: 10,
                    children: [
                      Container(
                        width: (HelperMediaQuerys.getScreenWidth(context) - 45) / 2,
                        child: Text("生日：${_userInfo?.birthday ?? "-"}"),
                      ),
                      Container(
                        width: (HelperMediaQuerys.getScreenWidth(context) - 45) / 2,
                        child: Text("身高：${_userInfo?.height ?? "- "}cm"),
                      ),
                      Container(
                        width: (HelperMediaQuerys.getScreenWidth(context) - 45) / 2,
                        child: Text("体重：${_userInfo?.weight ?? "- "}kg"),
                      ),
                    ],
                  ),
                  margin: EdgeInsets.only(left: 10, top: 10, right: 10),
                ),
                Container(
                  child: Text(
                    "个人介绍",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                  ),
                  margin: EdgeInsets.only(left: 10, top: 15),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: 100),
                  decoration: BoxDecoration(color: Color(0xffeeecec), borderRadius: BorderRadius.circular(5)),
                  child: Text(_userInfo?.describe == null || _userInfo?.describe?.isEmpty == true ? "-" : _userInfo?.describe ?? ""),
                ),
                SizedBox(
                  height: 100,
                )
              ],
            ),
          )),
          Positioned(
            left: 0,
            right: 0,
            child: Container(
              height: HelperMediaQuerys.getStatusAndAppBarHeight(context) * 1.5,
              decoration: BoxDecoration(
                  gradient:
                      LinearGradient(colors: [Color(0xff00000000), Color(0xbe000000)], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            child: Visibility(
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Color(0xff00ffffff), Color(0xffffffff)], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        flex: 3,
                        child: InkWell(
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            height: 50,
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(50), boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(0, 5), // changes position of shadow
                              )
                            ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.email_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "发消息",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            HelperNavigator.push(context, UiConversation(widget.userId));
                          },
                        )),
                    SizedBox(
                      width: 20,
                    ),
                    Expanded(
                        flex: 2,
                        child: InkWell(
                          child: Container(
                            alignment: AlignmentDirectional.center,
                            height: 50,
                            decoration:
                                BoxDecoration(color: _isFollow ? Colors.red : Colors.blue, borderRadius: BorderRadius.circular(50), boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 0,
                                blurRadius: 5,
                                offset: Offset(0, 5), // changes position of shadow
                              )
                            ]),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.follow_the_signs_rounded,
                                  color: Colors.white,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  _isFollow ? "已关注" : "关注",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ),
                          onTap: () {
                            _follow();
                          },
                        )),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
              ),
              visible: _isVisibleBottomButton,
            ),
            bottom: 0,
          )
        ],
      ),
    );
  }

  Future<void> _getData() async {
    try {
      var user = await EntityUser.get(widget.userId);

      if (user.albums?.isEmpty == true) {
        user.albums?.add(Album(image: user.avatar));
      }

      setState(() {
        _user = user;
      });

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {
          _albumsPosition = (_pageController.page?.round() ?? 0) + 1;
        });
      });

      _getUserShare();

      var account = await EntityUser.getAccountUser();
      if (account?.userId.toString() != widget.userId) {
        setState(() {
          _isVisibleBottomButton = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getUserShare() async {
    try {
      var data = await HttpClient.dio.get("${HttpUrl.GET_USER_SHARE}/${widget.userId}?limit=5&page=1&type=default").checkResponse();
      var shareList = EntityShareList.fromJson(data);
      setState(() {
        _listShare = shareList.list?.isEmpty == true ? [ListElement(content: "暂无动态")] : shareList.list ?? [ListElement(content: "暂无动态")];
      });
    } catch (e) {
      print(e);
    }
  }

  _getShareContent(int index) {
    if (_listShare[index].images == null || _listShare[index].images?.isEmpty == true) {
      return Container(
        alignment: AlignmentDirectional.center,
        padding: EdgeInsets.all(10),
        child: Text(
          _listShare[index].content ?? "",
          style: TextStyle(color: Color(0xff6b6b6b)),
          maxLines: 5,
          overflow: TextOverflow.ellipsis,
        ),
        decoration: BoxDecoration(color: Color(0xffe7e7e7), borderRadius: BorderRadius.circular(10)),
      );
    } else {
      return WidgetImage(_listShare[index].images?[0] ?? "", isCenterCrop: true, borderRadius: 10);
    }
  }

  void _pageListener() {
    setState(() {
      _albumsPosition = (_pageController.page?.round() ?? 0) + 1;
    });
  }

  Future<void> _follow() async {
    try {
      UiDialogLoading.show(context, false);
      var data = await HttpClient.dio.post("${HttpUrl.POST_FOLLOW}?user_id=${widget.userId}").checkResponse();
      _getFollow();
      Navigator.pop(context);
    } catch (e) {
      print(e);
      Navigator.pop(context);
    }
  }

  Future<void> _getFollow() async {
    try {
      var data = await HttpClient.dio.get("${HttpUrl.GET_FOLLOW}?targetId=${widget.userId}").checkResponse();
      setState(() {
        _isFollow = data["value"];
      });
    } catch (e) {}
  }

  Future<void> _getUserInfo() async {
    try {
      var data = await HttpClient.dio.get("${HttpUrl.GET_USER_INFO}?userId=${widget.userId}").checkResponse();
      var userInfo = EUserInfo.fromJson(data);
      setState(() {
        _userInfo = userInfo;
      });
    } catch (e) {}
  }
}
