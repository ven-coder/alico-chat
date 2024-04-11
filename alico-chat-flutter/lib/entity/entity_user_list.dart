// To parse this JSON data, do
//
//     final entityUserList = entityUserListFromJson(jsonString);

import 'dart:convert';

EntityUserList entityUserListFromJson(String str) => EntityUserList.fromJson(json.decode(str));

String entityUserListToJson(EntityUserList data) => json.encode(data.toJson());

class EntityUserList {
  List<ListElement>? list;
  int? page;
  int? limit;

  EntityUserList({
    this.list,
    this.page,
    this.limit,
  });

  factory EntityUserList.fromJson(Map<String, dynamic> json) => EntityUserList(
        list: json["list"] == null ? [] : List<ListElement>.from(json["list"]!.map((x) => ListElement.fromJson(x))),
        page: json["page"],
        limit: json["limit"],
      );

  Map<String, dynamic> toJson() => {
        "list": list == null ? [] : List<dynamic>.from(list!.map((x) => x.toJson())),
        "page": page,
        "limit": limit,
      };
}

class ListElement {
  int? userId;
  String? deviceId;
  String? mobile;
  String? email;
  String? avatar;
  String? nickname;
  int? sex;
  int? albumCount;
  int? online;
  int? lastOnline;
  int? vip;
  int? vipExpireTime;
  int? listHide;
  int? real;
  int? goddess;
  int? status;
  int? createAt;
  int? updateAt;
  String? ryKey;
  String? ryToken;
  String? ryUserId;
  String? refreshToken;
  String? token;
  bool? likeTarget;
  int? age;
  String rcOnline = "";

  ListElement({
    this.userId,
    this.deviceId,
    this.mobile,
    this.email,
    this.avatar,
    this.nickname,
    this.sex,
    this.albumCount,
    this.online,
    this.lastOnline,
    this.vip,
    this.vipExpireTime,
    this.listHide,
    this.real,
    this.goddess,
    this.status,
    this.createAt,
    this.updateAt,
    this.ryKey,
    this.ryToken,
    this.ryUserId,
    this.refreshToken,
    this.token,
    this.likeTarget,
    this.age,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        userId: json["userId"],
        deviceId: json["deviceId"],
        mobile: json["mobile"],
        email: json["email"],
        avatar: json["avatar"],
        nickname: json["nickname"],
        sex: json["sex"],
        albumCount: json["albumCount"],
        online: json["online"],
        lastOnline: json["lastOnline"],
        vip: json["vip"],
        vipExpireTime: json["vipExpireTime"],
        listHide: json["listHide"],
        real: json["real"],
        goddess: json["goddess"],
        status: json["status"],
        createAt: json["createAt"],
        updateAt: json["updateAt"],
        ryKey: json["ryKey"],
        ryToken: json["ryToken"],
        ryUserId: json["ryUserId"],
        refreshToken: json["refreshToken"],
        token: json["token"],
        likeTarget: json["likeTarget"],
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "deviceId": deviceIdValues.reverse[deviceId],
        "mobile": mobile,
        "email": email,
        "avatar": avatar,
        "nickname": nickname,
        "sex": sex,
        "albumCount": albumCount,
        "online": online,
        "lastOnline": lastOnline,
        "vip": vip,
        "vipExpireTime": vipExpireTime,
        "listHide": listHide,
        "real": real,
        "goddess": goddess,
        "status": status,
        "createAt": createAt,
        "updateAt": updateAt,
        "ryKey": ryKey,
        "ryToken": ryToken,
        "ryUserId": ryUserId,
        "refreshToken": refreshToken,
        "token": token,
        "likeTarget": likeTarget,
        "age": age,
      };
}

enum DeviceId { EMPTY, THE_7_CBAA26_E8523_F063 }

final deviceIdValues = EnumValues({"": DeviceId.EMPTY, "7cbaa26e8523f063": DeviceId.THE_7_CBAA26_E8523_F063});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
