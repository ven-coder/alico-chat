import 'package:alico_chat/widget/widget_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetGender extends StatelessWidget {
  int gender;
  int vip;
  int personAuth;

  WidgetGender(this.gender, this.vip, this.personAuth);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Visibility(
          child: Container(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: gender == 1 ? Colors.blue : Colors.purpleAccent),
            child: Padding(
              padding: EdgeInsets.only(left: 5, right: 5, top: 0, bottom: 0),
              child: Icon(gender == 1 ? Icons.male_rounded : Icons.female_rounded, color: Colors.white, size: 15),
            ),
          ),
          visible: gender != 1 || gender != 2,
        ),
        Visibility(
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Icon(
              Icons.card_membership_rounded,
              size: 17,
              color: Colors.orangeAccent,
            ),
          ),
          visible: vip == 1,
        ),
        Visibility(
          child: Container(
            margin: EdgeInsets.only(left: 5),
            child: Icon(
              Icons.verified,
              size: 17,
              color: Colors.green,
            ),
          ),
          visible: personAuth == 1,
        ),
      ],
    );
  }
}
