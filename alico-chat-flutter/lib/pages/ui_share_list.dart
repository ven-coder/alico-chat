import 'package:alico_chat/entity/entity_share_list.dart';
import 'package:alico_chat/helper/helper_media_querys.dart';
import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/helper/snack_bar.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:alico_chat/pages/ui_dialog_loading.dart';
import 'package:alico_chat/pages/ui_image_preview.dart';
import 'package:alico_chat/pages/ui_post_share.dart';
import 'package:alico_chat/pages/ui_share_details.dart';
import 'package:alico_chat/pages/ui_user_details.dart';
import 'package:alico_chat/widget/widget_gender.dart';
import 'package:alico_chat/widget/widget_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../http/http_client.dart';

class UiShareList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiShareList> {
  final GlobalKey<RefreshIndicatorState> _indicatorKey = GlobalKey<RefreshIndicatorState>();
  final ScrollController _scrollController = ScrollController();
  final int GET_DATA_REFRESH = 1;
  final int GET_DATA_LOAD = 2;
  int _getData = 0;
  bool _isLoadEnd = false;
  int _page = 1;
  int _limit = 15;
  EntityShareList? _list;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    getData(GET_DATA_REFRESH);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.offset == _scrollController.position.maxScrollExtent && !_isLoadEnd) {
      getData(GET_DATA_LOAD);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
              child: RefreshIndicator(
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.only(top: HelperMediaQuerys.getStatusHeight(context) + 10, left: 10, right: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
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
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    InkWell(
                                      child: WidgetImage(
                                        _list?.list?[index].avatar ?? "",
                                        height: 50,
                                        width: 50,
                                        isCenterCrop: true,
                                        borderRadius: 30,
                                      ),
                                      onTap: () {
                                        HelperNavigator.push(context, UiUserDetails(userId: _list?.list?[index].userId.toString() ?? ""));
                                      },
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(_list?.list?[index].nickname ?? ""),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        WidgetGender(_list?.list?[index].sex ?? 1, 0, 0),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Container(
                                          child: Text(
                                            _list?.list?[index].createAt ?? "",
                                            style: TextStyle(color: Colors.grey, fontSize: 12),
                                          ),
                                          margin: EdgeInsets.only(),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                margin: EdgeInsets.only(left: 10, top: 10, right: 10, bottom: 10),
                              ),
                              Align(
                                child: Visibility(
                                  child: Container(
                                    child: Text(_list?.list?[index].content ?? ""),
                                    margin: EdgeInsets.only(bottom: 10, left: 10),
                                  ),
                                  visible: _list?.list?[index].content?.isNotEmpty == true,
                                ),
                                alignment: AlignmentDirectional.centerStart,
                              ),
                              Visibility(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 15),
                                  child: Wrap(
                                    spacing: 5,
                                    runSpacing: 5,
                                    children: [
                                      for (var value in _list?.list?[index].images ?? [])
                                        InkWell(
                                          child: WidgetImage(
                                            value,
                                            isCenterCrop: true,
                                            width: (HelperMediaQuerys.getScreenWidth(context) - 50) / 3,
                                            height: (HelperMediaQuerys.getScreenWidth(context) - 50) / 3,
                                            borderRadius: 10,
                                          ),
                                          onTap: () {
                                            HelperNavigator.push(context, UiImagePreview(value));
                                          },
                                        )
                                    ],
                                  ),
                                ),
                                visible: _list?.list?[index].images?.isNotEmpty == true,
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 8, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/share/comment.png",
                                          width: 25,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(_list?.list?[index].comments?.length.toString() ?? "0")
                                      ],
                                    ),
                                    InkWell(
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            _list?.list?[index].liked == true ? "assets/images/share/liked.png" : "assets/images/share/like.png",
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            _list?.list?[index].likes?.length.toString() ?? "0",
                                            style: TextStyle(color: _list?.list?[index].liked == true ? Colors.red : Colors.black),
                                          )
                                        ],
                                      ),
                                      onTap: () {
                                        _like(index);
                                      },
                                    ),
                                    SizedBox(),
                                    SizedBox(),
                                    SizedBox(),
                                    SizedBox(),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return UiShareDetails(id: _list?.list?[index].activityId.toString() ?? "");
                          }));
                        },
                      );
                    }, childCount: _list?.list?.length ?? 0),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          width: 40,
                          height: 40,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        visible: !_isLoadEnd,
                      ),
                      Visibility(
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          child: Text(
                            "END",
                            style: TextStyle(color: Colors.grey),
                          ),
                          height: 50,
                        ),
                        visible: _isLoadEnd,
                      )
                    ],
                  ),
                )
              ],
            ),
            onRefresh: () async {
              await getData(GET_DATA_REFRESH);
            },
          )),
          Positioned(
              bottom: 0,
              right: 0,
              child: InkWell(
                child: Container(
                  margin: EdgeInsets.only(right: 20, bottom: 20),
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(30), boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 5), // changes position of shadow
                    )
                  ]),
                  child: Icon(
                    Icons.send,
                    size: 35,
                    color: Colors.white,
                  ),
                ),
                onTap: () async {
                  var result = await HelperNavigator.push(context, UiPostShare());
                  getData(GET_DATA_REFRESH);
                },
              ))
        ],
      ),
    );
  }

  Future<void> getData(int newGetData) async {
    if (_getData != 0) return;
    _getData = newGetData;
    if (newGetData == GET_DATA_REFRESH) {
      setState(() {
        _page = 1;
        _isLoadEnd = false;
      });
    }
    if (newGetData == GET_DATA_LOAD) {
      setState(() {
        _page++;
      });
    }
    try {
      var response = await HttpClient.dio
          .get(
            "${HttpUrl.GET_SHARE_LIST}?sort=0&sex=0&page=$_page&limit=$_limit&city=0&online=0&label=DEFAULT",
          )
          .checkResponse();
      var list = EntityShareList.fromJson(response);

      if (newGetData == GET_DATA_REFRESH) {
        setState(() {
          _list = list;
          if ((list.list?.length ?? 0) < _limit) {
            _isLoadEnd = true;
          }
        });
      }
      if (newGetData == GET_DATA_LOAD) {
        setState(() {
          list.list?.forEach((element) {});
          _list?.list?.addAll(list.list ?? []);
          if ((list.list?.length ?? 0) < _limit) {
            _isLoadEnd = true;
          }
        });
      }
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        _getData = 0;
      });
    }
  }

  Future<void> _like(int index) async {
    try {
      FocusScope.of(context).unfocus();
      UiDialogLoading.show(context, false);
      await HttpClient.dio
          .post(HttpUrl.POST_SHARE_LIKE, data: {"activity_id": _list?.list?[index].activityId}, options: Options(contentType: HttpClient.FORM))
          .checkResponse();
      Navigator.pop(context);
      var newValue = !(_list?.list?[index].liked == true);
      setState(() {
        _list?.list?[index].liked = newValue;
        if (newValue) {
          _list?.list?[index].likes?.add(Like());
        } else {
          _list?.list?[index].likes?.removeLast();
        }
      });
    } catch (e) {
      SnackBarUtil.showSnackBar(context, "点赞失败:$e");
      Navigator.pop(context);
    }
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
