import 'dart:io';

import 'package:alico_chat/common/oss_file.dart';
import 'package:alico_chat/entity/entity_user.dart';
import 'package:alico_chat/helper/helper_image_picker.dart';
import 'package:alico_chat/helper/helper_navigator.dart';
import 'package:alico_chat/helper/snack_bar.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:alico_chat/pages/ui_dialog_loading.dart';
import 'package:alico_chat/widget/widget_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;

class UiPostShare extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }
}

class _Widget extends State<UiPostShare> {
  TextEditingController _contentController = TextEditingController();
  String _content = "";
  List<String> _images = [""];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("发布动态"),
      ),
      body: InkWell(
        highlightColor: Colors.transparent,
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      child: Column(
                        children: [
                          Expanded(
                              child: TextField(
                            maxLength: 100,
                            controller: _contentController,
                            maxLines: null,
                            onChanged: (value) {
                              setState(() {
                                _content = value;
                              });
                            },
                            decoration: InputDecoration(
                                counterText: "", border: InputBorder.none, hintText: "", hintStyle: TextStyle(color: Color(0xff80ffffff))),
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          )),
                          Align(
                            child: Text(
                              "${_content.length}/100",
                              style: TextStyle(color: Color(0xff000000), fontSize: 14),
                            ),
                            alignment: AlignmentDirectional.centerEnd,
                          )
                        ],
                      ),
                      padding: EdgeInsets.only(left: 10, right: 20, bottom: 10),
                    ),
                    height: 150,
                    decoration: BoxDecoration(color: Color(0xffeaeaea), borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  sliver: SliverGrid.builder(
                      itemCount: _images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 5, crossAxisSpacing: 5),
                      itemBuilder: (context, index) {
                        return _getItem(index);
                      }),
                )
              ],
            ),
            Positioned(
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
                    "发布",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                onTap: () {
                  _post();
                },
              ),
              bottom: 0,
              left: 0,
              right: 0,
            )
          ],
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _getItem(int index) {
    var image = _images[index];
    if (image.isEmpty) {
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
                _images.add(xFile.path);
              } else {
                _images.insert(_images.length - 1, xFile.path);
              }
            });
          }
        },
      );
    } else {
      return Stack(
        children: [
          WidgetImage(
            image,
            borderRadius: 10,
            isCenterCrop: true,
          ),
          Positioned(
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(color: Colors.red),
                child: Icon(
                  Icons.close,
                  color: Colors.white,
                ),
              ),
              onTap: () {
                setState(() {
                  _images.removeAt(index);
                  if (_images.length < 9 && _images[_images.length - 1].isNotEmpty) _images.add("");
                });
              },
            ),
            right: 0,
          )
        ],
      );
    }
  }

  Future<void> _post() async {
    if (_images.length < 2 && _content.isEmpty) {
      SnackBarUtil.showSnackBar(context, "请先输入发表内容或者添加照片");
      return;
    }
    FocusScope.of(context).unfocus();
    try {
      UiDialogLoading.show(context, false);
      var user = await EntityUser.getAccountUser();

      for (var i = 0; i < _images.length; i++) {
        var image = _images[i];
        if (image.isEmpty) break;
        if (!image.startsWith("http")) {
          var file = File(image);
          var url = await OssFile.upload(file, "image/share/${user?.userId}/${path.basename(file.path)}");
          _images[i] = url;
          setState(() {
            _images;
          });
        }
      }

      var formData = FormData.fromMap({
        "images[]": _images,
        "content": _content,
        "disableComment": "0",
        "enableHide": "0",
        "positionCity": "unknown",
      });

      var response = await HttpClient.dio.post(HttpUrl.POST_SHARE, data: formData, options: Options(contentType: HttpClient.FORM)).checkResponse();
      Navigator.pop(context);
      Navigator.pop(context);
      SnackBarUtil.showSnackBar(context, "发布成功");
    } catch (e) {
      Navigator.pop(context);
      SnackBarUtil.showSnackBar(context, "发布失败：$e");
    }
  }
}
