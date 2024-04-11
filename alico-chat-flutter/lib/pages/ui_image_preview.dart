import 'dart:io';
import 'package:alico_chat/helper/helper_media_querys.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class UiImagePreview extends StatefulWidget {
  String value;

  UiImagePreview(this.value);

  @override
  State<StatefulWidget> createState() {
    return _Widget();
  }

  static void show(BuildContext context, String value) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return UiImagePreview(value);
    }));
  }
}

class _Widget extends State<UiImagePreview> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
      body: InkWell(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
                child: Container(
              color: Colors.black,
            )),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: 0,
              child: PhotoView(imageProvider: getImageProvider()),
            ),
            Positioned(
              left: 0,
              right: 0,
              child: Container(
                height: HelperMediaQuerys.getStatusAndAppBarHeight(context) * 1.5,
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Color(0xff00000000), Color(0xbe000000)], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
              ),
            )
          ],
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  getImageProvider() {
    if (widget.value.isEmpty) {
      return const SizedBox();
    }

    if (widget.value.startsWith("http")) {
      return NetworkImage(
        widget.value,
      );
    }
    if (widget.value.startsWith("assets")) {
      return AssetImage(
        widget.value,
      );
    }
    return FileImage(
      File(widget.value),
    );
  }
}
