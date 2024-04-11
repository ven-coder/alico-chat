import 'package:alico_chat/entity/entity_share_details.dart';
import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/helper/snack_bar.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:alico_chat/pages/ui_dialog_loading.dart';
import 'package:alico_chat/pages/ui_image_preview.dart';
import 'package:alico_chat/pages/ui_user_details.dart';
import 'package:alico_chat/widget/widget_gender.dart';
import 'package:alico_chat/widget/widget_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../helper/helper_media_querys.dart';

class UiShareDetails extends StatefulWidget {
  String id;

  UiShareDetails({Key? key, required this.id}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiShareDetails> {
  EntityShareDetails? _data;
  String _comment = "";
  TextEditingController _commentController = TextEditingController();
  bool _showComment = false;
  FocusNode _commentFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("动态详情"),
      ),
      body: InkWell(
        child: Stack(
          children: [
            Positioned.fill(
                child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.only(bottom: 10, top: 10, left: 10, right: 10),
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
                                        _data?.avatar ?? "",
                                        isCenterCrop: true,
                                        borderRadius: 30,
                                        width: 50,
                                        height: 50,
                                      ),
                                      onTap: () {
                                        HelperNavigator.push(context, UiUserDetails(userId: _data?.userId.toString() ?? ""));
                                      }),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_data?.nickname ?? ""),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      WidgetGender(_data?.sex ?? 0, _data?.vip ?? 0, _data?.real ?? 0)
                                    ],
                                  ),
                                ],
                              ),
                              margin: EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 10),
                            ),
                            Align(
                              child: Visibility(
                                child: Container(
                                  child: Text(_data?.content ?? ""),
                                  margin: EdgeInsets.only(left: 10, bottom: 10),
                                ),
                                visible: _data?.content?.isNotEmpty ?? false,
                              ),
                              alignment: AlignmentDirectional.centerStart,
                            ),
                            Visibility(
                              child: Padding(
                                padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                                child: Wrap(
                                  spacing: 5,
                                  runSpacing: 5,
                                  children: [for (var value in _data?.images ?? []) _ImageItem(image: value)],
                                ),
                              ),
                              visible: _data?.images?.isNotEmpty ?? false,
                            ),
                            Container(
                              margin: EdgeInsets.only(left: 8, bottom: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          "assets/images/share/comment.png",
                                          width: 25,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(_data?.comments?.length.toString() ?? "")
                                      ],
                                    ),
                                    onTap: () {
                                      setState(() {
                                        _showComment = true;
                                      });
                                      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                                        FocusScope.of(context).requestFocus(_commentFocusNode);
                                      });
                                    },
                                  ),
                                  InkWell(
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          _data?.liked == true ? "assets/images/share/liked.png" : "assets/images/share/like.png",
                                          width: 25,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          _data?.likes?.length.toString() ?? "",
                                          style: TextStyle(color: _data?.liked == true ? Colors.red : Colors.black),
                                        )
                                      ],
                                    ),
                                    onTap: () {
                                      _like();
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
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 10),
                        child: Text(
                          "评论",
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                        ),
                      )
                    ],
                  ),
                ),
                _data?.comments?.isEmpty == true
                    ? SliverToBoxAdapter(
                        child: Container(
                          alignment: AlignmentDirectional.center,
                          width: HelperMediaQuerys.getScreenWidth(context),
                          height: HelperMediaQuerys.getScreenWidth(context),
                          child: Text(
                            "还没有人评论",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      )
                    : SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                        return Container(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              WidgetImage(
                                _data?.comments?[index].commentUserInfo?.avatar ?? "",
                                width: 40,
                                height: 40,
                                isCenterCrop: true,
                                borderRadius: 30,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        _data?.comments?[index].commentUserInfo?.nickname ?? "",
                                        style: TextStyle(fontWeight: FontWeight.w900),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      WidgetGender(_data?.comments?[index].commentUserInfo?.sex ?? 0,
                                          _data?.comments?[index].commentUserInfo?.vip ?? 0, _data?.comments?[index].commentUserInfo?.real ?? 0)
                                    ],
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(_data?.comments?[index].comment ?? ""),
                                  Visibility(
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        _getCommentTime(index),
                                        style: TextStyle(color: Colors.grey, fontSize: 12),
                                      ),
                                    ),
                                    visible: _getCommentTime(index).isNotEmpty,
                                  ),
                                ],
                              ))
                            ],
                          ),
                        );
                      }, childCount: _data?.comments?.length ?? 0)),
              ],
            )),
            Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Visibility(
                  child: Container(
                    height: 60,
                    padding: EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 0, blurRadius: 10, offset: Offset(0, -5))]),
                    child: Row(
                      children: [
                        Flexible(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: '评论内容', // 添加提示文本
                            ),
                            controller: _commentController,
                            focusNode: _commentFocusNode,
                            autofocus: true,
                            onChanged: (value) {
                              setState(() {
                                _comment = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        InkWell(
                          child: Container(
                            height: 30,
                            padding: EdgeInsets.only(left: 10, right: 10),
                            alignment: AlignmentDirectional.center,
                            child: Text(
                              "发布",
                              style: TextStyle(color: Colors.white),
                            ),
                            decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(5)),
                          ),
                          onTap: () {
                            _postComment();
                          },
                        )
                      ],
                    ),
                  ),
                  visible: _showComment,
                ))
          ],
        ),
        onTap: () {
          setState(() {
            _showComment = false;
          });
        },
      ),
    );
  }

  Future<void> _getData() async {
    try {
      var data = await HttpClient.dio.get("${HttpUrl.GET_SHARE_DETAIL}/${widget.id}").checkResponse();
      var details = EntityShareDetails.fromJson(data);
      setState(() {
        _data = details;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _postComment() async {
    if (_comment.isEmpty) {
      SnackBarUtil.showSnackBar(context, "请先输入评论内容");
      return;
    }

    try {
      FocusScope.of(context).unfocus();
      UiDialogLoading.show(context, false);
      var data = await HttpClient.dio
          .post(HttpUrl.POST_SHARE_COMMENT,
              data: {
                "activity_id": widget.id,
                "comment": _comment,
                "commentType": "0",
              },
              options: Options(contentType: HttpClient.FORM))
          .checkResponse();
      Navigator.pop(context);
      _commentController.clear();
      setState(() {
        _comment = "";
        _showComment = false;
      });
      _getData();
    } catch (e) {
      SnackBarUtil.showSnackBar(context, "评论失败：$e");
      Navigator.pop(context);
    }
  }

  String _getCommentTime(int index) {
    var createdAt = _data?.comments?[index].createdAt ?? 0;
    if (createdAt == 0) return "";
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(createdAt * 1000); // 转换为 DateTime 对象
    return _formatDate(dateTime);
  }

  String _formatDate(DateTime dateTime) {
    String year = dateTime.year.toString();
    String month = dateTime.month.toString().padLeft(2, '0');
    String day = dateTime.day.toString().padLeft(2, '0');
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    String second = dateTime.second.toString().padLeft(2, '0');

    return '$year-$month-$day $hour:$minute:$second';
  }

  Future<void> _like() async {
    try {
      FocusScope.of(context).unfocus();
      UiDialogLoading.show(context, false);
      await HttpClient.dio
          .post(HttpUrl.POST_SHARE_LIKE, data: {"activity_id": widget.id}, options: Options(contentType: HttpClient.FORM))
          .checkResponse();
      Navigator.pop(context);
      _getData();
    } catch (e) {
      SnackBarUtil.showSnackBar(context, "点赞失败:$e");
      Navigator.pop(context);
    }
  }
}

class _ImageItem extends StatelessWidget {
  String image;

  _ImageItem({required this.image});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        child: Container(
          // margin: EdgeInsets.only(bottom: 5, right: 5),
          width: (HelperMediaQuerys.getScreenWidth(context) - 50) / 3,
          height: (HelperMediaQuerys.getScreenWidth(context) - 50) / 3,
          child: WidgetImage(
            image,
            isCenterCrop: true,
            borderRadius: 10,
          ),
        ),
        onTap: () {
          HelperNavigator.push(context, UiImagePreview(image));
        });
  }
}
