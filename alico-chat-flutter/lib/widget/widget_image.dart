import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetImage extends StatelessWidget {
  String value;
  bool? isCenterCrop;
  double? borderRadius;
  double? width;
  double? height;

  WidgetImage(this.value, {super.key, this.isCenterCrop, this.width, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: getImage(),
    );
  }

  getImage() {
    if (value.isEmpty) return const SizedBox();

    if (value.startsWith("http")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: CachedNetworkImage(
            placeholder: (context, url) => Container(
                  color: Color(0xffefefef),
                  child: Icon(
                    Icons.photo,
                    color: Color(0xffb6b6b6),
                    size: 30,
                  ),
                  alignment: AlignmentDirectional.center,
                ),
            errorWidget: (context, url, error) => Container(
                  color: Color(0xffefefef),
                  child: Icon(
                    Icons.photo,
                    color: Color(0xffb6b6b6),
                    size: 30,
                  ),
                  alignment: AlignmentDirectional.center,
                ),
            imageUrl: value,
            fit: isCenterCrop == true ? BoxFit.cover : null),
      );
    }
    if (value.startsWith("assets")) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius ?? 0),
        child: Image.asset(value, fit: isCenterCrop == true ? BoxFit.cover : null),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
      child: Image.file(
          File(
            value,
          ),
          fit: isCenterCrop == true ? BoxFit.cover : null),
    );
  }
}
