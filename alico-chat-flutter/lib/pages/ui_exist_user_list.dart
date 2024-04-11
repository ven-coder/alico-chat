import 'package:alico_chat/entity/entity_user.dart';
import 'package:alico_chat/entity/entity_user_list.dart';
import 'package:alico_chat/helper/helper_media_querys.dart';
import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/helper/snack_bar.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:alico_chat/pages/ui_dialog_loading.dart';
import 'package:alico_chat/pages/ui_select_gender.dart';
import 'package:alico_chat/pages/ui_user_details.dart';
import 'package:alico_chat/ui_main.dart';
import 'package:alico_chat/widget/widget_gender.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/widget_image.dart';

class UiExistUserList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiExistUserList> {
  final int GET_DATA_REFRESH = 1;
  final int GET_DATA_LOAD = 2;
  EntityUserList? _userList;
  final ScrollController _scrollController = ScrollController();
  int _page = 1;
  int _getData = 0;
  bool _isLoadEnd = false;
  final GlobalKey<RefreshIndicatorState> _indicatorKey = GlobalKey<RefreshIndicatorState>();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("选择已有账号"),
      ),
      body: RefreshIndicator(
          key: _indicatorKey,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                  padding: EdgeInsets.only(top: 10, left: 10, right: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return InkWell(
                        child: Opacity(
                          opacity: _userList?.list?[index].rcOnline == "1"
                              ? 0.5
                              : _userList?.list?[index].rcOnline.isEmpty == true
                                  ? 0.5
                                  : _userList?.list?[index].rcOnline == "0"
                                      ? 1
                                      : 0.5,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: Offset(0, -5), // changes position of shadow
                              )
                            ]),
                            child: Row(
                              children: [
                                WidgetImage(
                                  _userList?.list?[index].avatar ?? "",
                                  isCenterCrop: true,
                                  borderRadius: 100,
                                  width: 50,
                                  height: 50,
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _userList?.list?[index]?.nickname ?? "",
                                        style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        child: WidgetGender(
                                            _userList?.list?[index].sex ?? 2, _userList?.list?[index].vip ?? 0, _userList?.list?[index].real ?? 0),
                                        alignment: AlignmentDirectional.centerStart,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(child: SizedBox()),
                                Text(_userList?.list?[index].rcOnline == "1"
                                    ? "占用中..."
                                    : _userList?.list?[index].rcOnline.isEmpty == true
                                        ? "状态查询中..."
                                        : _userList?.list?[index].rcOnline == "0"
                                            ? "可用"
                                            : "状态未知")
                              ],
                            ),
                            margin: EdgeInsets.only(bottom: 10),
                          ),
                        ),
                        onTap: () {
                          if (_userList?.list?[index].rcOnline != "0") return;
                          _login(index);
                        },
                      );
                    }, childCount: _userList?.list?.length ?? 0),
                  )),
              Visibility(
                child: SliverToBoxAdapter(
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
                ),
                visible: true,
              )
            ],
          ),
          onRefresh: () async {
            getData(GET_DATA_REFRESH);
          }),
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
            "${HttpUrl.GET_EXITS_USER_LIST}?page=$_page",
          )
          .checkResponse();
      var userList = EntityUserList.fromJson(response);

      if (newGetData == GET_DATA_REFRESH) {
        setState(() {
          _userList = userList;
        });
      }
      if (newGetData == GET_DATA_LOAD) {
        userList.list?.forEach((element) {});
        _userList?.list?.addAll(userList.list ?? []);

        setState(() {
          _userList;
        });
      }

      for (var value in _userList?.list ?? <ListElement>[]) {
        var data = await HttpClient.dio.get(HttpUrl.GET_RC_USER_ONLINE, queryParameters: {"userId": value.userId}).checkResponse();
        setState(() {
          value.rcOnline = data["rcOnline"];
        });
      }

      if ((userList.list?.length ?? 0) < 20) {
        _isLoadEnd = true;
      }
      _scrollListener();
    } catch (e) {
      print(e);
      SnackBarUtil.showSnackBar(context, "数据加载失败：$e");
    } finally {
      setState(() {
        _getData = 0;
      });
    }
  }

  void _scrollListener() {
    if (_scrollController.offset == _scrollController.position.maxScrollExtent && !_isLoadEnd) {
      getData(GET_DATA_LOAD);
    }
  }

  Future<void> _login(int index) async {
    try {
      UiDialogLoading.show(context, false);
      var userId = _userList?.list?[index].userId;
      var data = await HttpClient.dio
          .post(HttpUrl.POST_LOGIN_BY_USER_ID, data: {"userId": userId}, options: Options(contentType: HttpClient.FORM))
          .checkResponse();
      Navigator.pop(context);
      await EntityUser.saveAccount(data);
      var sex = data["sex"];
      if (sex == 1 || sex == 2) {
        HelperNavigator.push(context, UiMain());
      } else {
        HelperNavigator.push(context, UiSelectGender());
      }
    } catch (e) {
      print(e);
      SnackBarUtil.showSnackBar(context, "登录失败：$e");
      Navigator.pop(context);
    }
  }
}
