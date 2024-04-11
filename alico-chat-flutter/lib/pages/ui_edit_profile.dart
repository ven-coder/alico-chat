import 'dart:io';
import 'dart:math';

import 'package:alico_chat/common/oss_file.dart';
import 'package:alico_chat/entity/entity_user.dart';
import 'package:alico_chat/helper/helper_image_picker.dart';
import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/helper/snack_bar.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:alico_chat/pages/ui_dialog_loading.dart';
import 'package:alico_chat/pages/ui_image_preview.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import '../widget/widget_image.dart';

class UiEditProfile extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiEditProfile> with WidgetsBindingObserver {
  EntityUser? _user;
  List<Album> _images = [Album()];
  EUserInfo? _userInfo;
  TextEditingController _desController = TextEditingController();
  bool _isKeyboardOpen = false;
  List<int> _removeAlbums = [];

  @override
  void initState() {
    super.initState();
    _getData();
    _getAlbums();
    _getUserInfo();

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 10;
    setState(() {
      _isKeyboardOpen = isKeyboardOpen;
    });
  }

  Future<void> _getData() async {
    try {
      var user = await EntityUser.getAccountUser();
      setState(() {
        _user = user;
      });
    } catch (e) {}
  }

  @override
  void dispose() {
    _desController.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("编辑资料"),
      ),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Stack(
                      children: [
                        Container(
                          child: InkWell(
                            child: WidgetImage(
                              _user?.avatar ?? "",
                              width: 100,
                              height: 100,
                              isCenterCrop: true,
                              borderRadius: 60,
                            ),
                            onTap: () async {
                              var xFile = await HelperImagePicker.selectImage();
                              setState(() {
                                _user?.avatar = xFile?.path ?? "";
                              });
                            },
                          ),
                          margin: EdgeInsets.only(bottom: 10),
                        ),
                        Positioned(
                          child: Icon(Icons.camera_alt),
                          bottom: 0,
                          left: 0,
                          right: 0,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    InkWell(
                      child: Text(
                        _user?.nickname ?? "-",
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onTap: () {
                        _showTextInputDialog(context, _user?.nickname ?? "");
                      },
                    ),
                    Container(
                      width: double.infinity,
                      child: Text(
                        "相册",
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      margin: EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 20),
                    ),
                  ],
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.only(left: 10, right: 10),
                sliver: SliverGrid.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5, mainAxisSpacing: 5),
                    itemCount: _images.length,
                    itemBuilder: (context, index) {
                      return AspectRatio(
                        aspectRatio: 1 / 1,
                        child: _getItem(index),
                      );
                    }),
              ),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: Text(
                        "个人信息",
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                      margin: EdgeInsets.only(left: 10, top: 20),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      decoration: BoxDecoration(color: Color(0xffeeecec), borderRadius: BorderRadius.circular(5)),
                      child: Column(
                        children: [
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              height: 60,
                              child: Row(
                                children: [
                                  Expanded(child: Text("生日")),
                                  Text(_userInfo?.birthday ?? ""),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  WidgetImage(
                                    "assets/images/right.png",
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              _showDatePicker(context);
                            },
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              height: 60,
                              child: Row(
                                children: [
                                  Expanded(child: Text("身高")),
                                  Text((_userInfo?.height == null || _userInfo?.height?.isEmpty == true) ? "" : "${_userInfo?.height}cm"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  WidgetImage(
                                    "assets/images/right.png",
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              _showHeightDialog();
                            },
                          ),
                          InkWell(
                            child: Container(
                              margin: EdgeInsets.only(left: 10, right: 10),
                              height: 60,
                              child: Row(
                                children: [
                                  Expanded(child: Text("体重")),
                                  Text((_userInfo?.weight == null || _userInfo?.weight?.isEmpty == true) ? "" : "${_userInfo?.weight}kg"),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  WidgetImage(
                                    "assets/images/right.png",
                                    width: 12,
                                    height: 12,
                                  ),
                                ],
                              ),
                            ),
                            onTap: () {
                              _showWeightDialog();
                            },
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, top: 20),
                      child: Text(
                        "个人介绍",
                        style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
                      padding: EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      width: double.infinity,
                      constraints: BoxConstraints(minHeight: 100),
                      decoration: BoxDecoration(color: Color(0xffeeecec), borderRadius: BorderRadius.circular(5)),
                      child: TextField(
                        controller: _desController,
                        maxLines: null,
                        onChanged: (value) {
                          setState(() {
                            _userInfo?.describe = value;
                          });
                        },
                        decoration: InputDecoration(border: InputBorder.none),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                  ],
                ),
              )
            ],
          ),
          Visibility(
            child: Positioned(
              child: InkWell(
                child: Container(
                  alignment: AlignmentDirectional.center,
                  margin: EdgeInsets.all(15),
                  height: 50,
                  decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(30), boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 5,
                      offset: Offset(0, 5), // changes position of shadow
                    )
                  ]),
                  child: Text(
                    "保存",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () {
                  _submit();
                },
              ),
              bottom: 0,
              left: 0,
              right: 0,
            ),
            visible: !_isKeyboardOpen,
          )
        ],
      ),
    );
  }

  Widget _getItem(int index) {
    var image = _images[index];
    if (image?.image == null || image.image?.isEmpty == true) {
      return InkWell(
        child: Container(
          decoration: BoxDecoration(color: Color(0xffececec), borderRadius: BorderRadius.circular(10)),
          child: Icon(Icons.add),
        ),
        onTap: () async {
          var xFile = await HelperImagePicker.selectImage();
          if (xFile != null) {
            setState(() {
              if (_images.length > 8) {
                _images.removeLast();
                _images.add(Album(image: xFile.path));
              } else {
                _images.insert(_images.length - 1, Album(image: xFile.path));
              }
            });
          }
        },
      );
    } else {
      return Stack(
        children: [
          Positioned.fill(
              child: InkWell(
            child: WidgetImage(
              image.image ?? "",
              borderRadius: 10,
              isCenterCrop: true,
            ),
            onTap: () {
              HelperNavigator.push(context, UiImagePreview(image.image ?? ""));
            },
          )),
          Positioned(
            right: 0,
            child: InkWell(
              child: Container(
                decoration: const BoxDecoration(color: Colors.red),
                child: const Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                setState(() {
                  var album = _images[index];
                  if (album.pictureId != null) {
                    _removeAlbums.add(album.pictureId ?? -1);
                  }
                  _images.removeAt(index);
                  if (_images.length < 9 && _images[_images.length - 1].image != null && _images[_images.length - 1].image?.isNotEmpty == true) {
                    _images.add(Album());
                  }
                });
              },
            ),
          )
        ],
      );
    }
  }

  Future<void> _showTextInputDialog(BuildContext context, String nickname) async {
    String userInput = ''; // 用于存储用户输入的文本
    TextEditingController controller = TextEditingController();
    controller.text = nickname;

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('修改昵称'),
          content: TextField(
            maxLength: 20,
            controller: controller,
            onChanged: (value) {
              userInput = value; // 更新用户输入的文本
            },
            decoration: InputDecoration(hintText: ""),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // 关闭对话框
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _user?.nickname = userInput;
                });
                Navigator.pop(context);
              },
              child: Text('确定'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDatePicker(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // 初始日期
      firstDate: DateTime(1970), // 可选的起始日期
      lastDate: DateTime(2099), // 可选的结束日期
    );
    if (picked != null) {
      setState(() {
        _userInfo?.birthday = _formatDate(picked);
      });
    }
  }

  String _formatDate(DateTime dateTime) {
    String year = dateTime.year.toString();
    String month = _addLeadingZero(dateTime.month);
    String day = _addLeadingZero(dateTime.day);
    return '$year-$month-$day';
  }

  String _addLeadingZero(int number) {
    return number < 10 ? '0$number' : number.toString();
  }

  Future<void> _getAlbums() async {
    try {
      var data = await HttpClient.dio.get(HttpUrl.GET_ALBUMS).checkResponse();
      var list = List<Album>.from(data.map((x) => Album.fromJson(x)));
      setState(() {
        _images.clear();
        _images = list;
        if (_images.length < 9) {
          _images.add(Album());
        }
      });
    } catch (e) {}
  }

  Future<void> _getUserInfo() async {
    try {
      var user = await EntityUser.getAccountUser();

      var data = await HttpClient.dio.get("${HttpUrl.GET_USER_INFO}?userId=${user?.userId}").checkResponse();
      var userInfo = EUserInfo.fromJson(data);
      setState(() {
        _userInfo = userInfo;
      });
      _desController.text = userInfo.describe ?? "";
    } catch (e) {}
  }

  void _showHeightDialog() {
    List<String> _list = [
      "140cm",
      "150cm",
      "160cm",
      "170cm",
      "180cm",
      "190cm",
      "200cm",
    ];
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                '选择身高',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_list[index]),
                            SizedBox(
                              width: 20,
                            ),
                            WidgetImage(
                              "assets/images/right.png",
                              width: 12,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _userInfo?.height = _list[index].replaceAll("cm", "");
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showWeightDialog() {
    List<String> _list = [
      "30kg",
      "40kg",
      "50kg",
      "60kg",
      "70kg",
      "80kg",
      "90kg",
      "100kg",
    ];
    showModalBottomSheet(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 300,
          decoration: BoxDecoration(borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text(
                '选择体重',
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _list.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      child: Container(
                        margin: EdgeInsets.only(left: 10, right: 10),
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(_list[index]),
                            SizedBox(
                              width: 20,
                            ),
                            WidgetImage(
                              "assets/images/right.png",
                              width: 12,
                              height: 12,
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        setState(() {
                          _userInfo?.weight = _list[index].replaceAll("kg", "");
                        });
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _submit() async {
    try {
      FocusScope.of(context).unfocus();
      UiDialogLoading.show(context, false);

      //检查上传头像
      if (!(_user?.avatar?.startsWith("http") == true)) {
        var avatarUrl = await OssFile.upload(File(_user?.avatar ?? ""), "image/avatar/${_user?.userId}/${path.basename(_user?.avatar ?? "")}");
        await HttpClient.dio.put(HttpUrl.PUT_AVATAR, data: {"sex": 0, "avatar": avatarUrl}, options: Options(contentType: HttpClient.FORM)).checkResponse();
      }

      //请求被删除的图片
      for (var element in _removeAlbums) {
        await HttpClient.dio
            .delete(HttpUrl.DELETE_ALBUM, data: {"picture_id": element}, options: Options(contentType: HttpClient.FORM))
            .checkResponse();
      }

      //上传添加的图片
      for (var element in _images) {
        if (!(element.image?.startsWith("http") == true) && element.image != null && element.image?.isNotEmpty == true) {
          var file = File(element.image ?? "");
          var data = await OssFile.upload(file, "image/album/${_user?.userId}/${path.basename(file.path)}");
          setState(() {
            element.image = data;
          });

          var formData = FormData.fromMap({
            "attachment[]": [data],
            "match_score[]": [0.0],
            "burn[]": [0],
          });

          await HttpClient.dio.post(HttpUrl.POST_ALBUM, data: formData, options: Options(contentType: HttpClient.FORM)).checkResponse();
        }
      }

      //提交信息
      var formData = FormData.fromMap({
        "nickname": _user?.nickname,
        "birthday": _userInfo?.birthday,
        "height": _userInfo?.height,
        "weight": _userInfo?.weight,
        "describe": _userInfo?.describe,
        "wechat": "",
        "qq": "",
        "profession": "0",
        "hide_contact": "0",
        "city[]": [],
      });

      var data = await HttpClient.dio.put(HttpUrl.PUT_EDIT_PROFILE, data: formData, options: Options(contentType: HttpClient.FORM)).checkResponse();
      await EntityUser.save(_user!);
      Navigator.pop(context);
      Navigator.pop(context);
      SnackBarUtil.showSnackBar(context, "已保存");
    } catch (e) {
      Navigator.pop(context);
      SnackBarUtil.showSnackBar(context, "保存失败：$e");
    }
  }
}
