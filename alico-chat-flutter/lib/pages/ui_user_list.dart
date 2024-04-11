import 'package:alico_chat/entity/entity_user_list.dart';
import 'package:alico_chat/helper/helper_media_querys.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:alico_chat/pages/ui_user_details.dart';
import 'package:alico_chat/widget/widget_gender.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widget/widget_image.dart';

class UiUserList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiUserList> {
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
      body: RefreshIndicator(
          key: _indicatorKey,
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverPadding(
                padding: EdgeInsets.only(top: HelperMediaQuerys.getStatusHeight(context) + 10, left: 10, right: 10),
                sliver: SliverGrid.builder(
                    itemCount: _userList?.list?.length ?? 0,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisSpacing: 10, mainAxisSpacing: 10, crossAxisCount: 2, childAspectRatio: 1 / 1.25),
                    itemBuilder: (context, index) {
                      return InkWell(
                        child: Container(
                          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(10), boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 5,
                              offset: Offset(0, 5), // changes position of shadow
                            ),
                          ]),
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Positioned.fill(
                                  child: ClipRRect(
                                child: WidgetImage(
                                  _userList?.list?[index].avatar ?? "",
                                  isCenterCrop: true,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              )),
                              Container(
                                height: 60,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(bottomRight: Radius.circular(10), bottomLeft: Radius.circular(10)),
                                    gradient: LinearGradient(colors: [
                                      Colors.transparent,
                                      Color(0xbf000000),
                                    ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                                child: Container(
                                  margin: EdgeInsets.only(left: 10),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        _userList?.list?[index]?.nickname ?? "",
                                        style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        child: WidgetGender(_userList?.list?[index].sex ?? 2, _userList?.list?[index].vip ?? 0, _userList?.list?[index].real ?? 0),
                                        alignment: AlignmentDirectional.centerStart,
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) {
                            return UiUserDetails(userId: _userList?.list?[index].userId?.toString() ?? "");
                          }));
                        },
                      );
                    }),
              ),
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
            "${HttpUrl.GET_USER_LIST}?page=$_page&limit=20",
          )
          .checkResponse();
      var userList = EntityUserList.fromJson(response);

      if (newGetData == GET_DATA_REFRESH) {
        setState(() {
          _userList = userList;
          if ((userList.list?.length ?? 0) < 20) {
            _isLoadEnd = true;
          }
        });
      }
      if (newGetData == GET_DATA_LOAD) {
        setState(() {
          userList.list?.forEach((element) {});
          _userList?.list?.addAll(userList.list ?? []);
          if ((userList.list?.length ?? 0) < 20) {
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

  void _scrollListener() {
    if (_scrollController.offset == _scrollController.position.maxScrollExtent && !_isLoadEnd) {
      getData(GET_DATA_LOAD);
    }
  }
}
