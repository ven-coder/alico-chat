// To parse this JSON data, do
//
//     final entityUser = entityUserFromJson(jsonString);

import 'dart:convert';

import 'package:alico_chat/helper/helper_rongclond.dart';
import 'package:alico_chat/http/http_url.dart';

import '../helper/helper_sp.dart';
import '../http/http_client.dart';

EntityUser entityUserFromJson(String str) => EntityUser.fromJson(json.decode(str));

String entityUserToJson(EntityUser data) => json.encode(data.toJson());

class EntityUser {
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
  List<Album>? albums;
  EUserInfo? userInfo;
  int? millisecondsSinceEpoch = 0;

  EntityUser({
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
    this.albums,
    this.userInfo,
    this.millisecondsSinceEpoch,
  });

  factory EntityUser.fromJson(Map<String, dynamic> json) => EntityUser(
        millisecondsSinceEpoch: json["millisecondsSinceEpoch"],
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
        albums: json["albums"] == null ? [] : List<Album>.from(json["albums"]!.map((x) => Album.fromJson(x))),
        userInfo: EUserInfo.fromJson(json["info"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "millisecondsSinceEpoch": millisecondsSinceEpoch,
        "userId": userId,
        "deviceId": deviceId,
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
        "info": userInfo?.toJson(),
        "albums": albums == null ? [] : List<dynamic>.from(albums!.map((x) => x.toJson())),
      };

  static Future<void> saveAccount(Map<String, dynamic> value) async {
    var userId = value["userId"];
    var token = value["token"];
    await HelperSp.get().setString(SPKey.KEY_ACCOUNT_USER_ID, userId.toString());
    await HelperSp.get().setString(SPKey.KEY_ACCOUNT_TOKEN, token.toString());
    await save(EntityUser.fromJson(value));
  }

  static Future<EntityUser?> getAccountUser() async {
    var userId = HelperSp.get().getString(
      SPKey.KEY_ACCOUNT_USER_ID,
    );
    if (userId == null || userId.isEmpty) return null;
    try {
      return await get(userId);
    } catch (e) {
      return null;
    }
  }

  static void removeAccountUser() {
    HelperSp.get().setString(SPKey.KEY_ACCOUNT_USER_ID, "");
    HelperSp.get().setString(SPKey.KEY_ACCOUNT_TOKEN, "");
    HelperRongclond.logout();
  }

  static Future<EntityUser> get(String userId) async {
    try {
      if (userId.isEmpty) return Future.error("userId empty");
      var microsecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
      var value = HelperSp.get().getString("USER_$userId");
      if (value?.isNotEmpty == true) {
        var user = EntityUser.fromJson(jsonDecode(value!));
        var time = microsecondsSinceEpoch - (user.millisecondsSinceEpoch ?? 0);
        var expireValue = 1000 * 60 * 60;
        if (time < expireValue) {
          return user;
        }
      }
      var data = await HttpClient.dio.get("${HttpUrl.GET_USER}/$userId").checkResponse();
      var user = EntityUser.fromJson(data);
      save(user);
      return user;
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }

  static Future<void> save(EntityUser user) async {
    user.millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    await HelperSp.get().setString("USER_${user.userId}", jsonEncode(user));
  }
}

class Album {
  int? pictureId;
  int? userId;
  String? image;
  int? mediaType;
  int? weight;
  int? label;
  int? audit;
  String? note;
  double? matchSocre;
  int? createAt;

  Album({
    this.pictureId,
    this.userId,
    this.image,
    this.mediaType,
    this.weight,
    this.label,
    this.audit,
    this.note,
    this.matchSocre,
    this.createAt,
  });

  factory Album.fromJson(Map<String, dynamic> json) => Album(
        pictureId: json["pictureId"],
        userId: json["userId"],
        image: json["image"],
        mediaType: json["mediaType"],
        weight: json["weight"],
        label: json["label"],
        audit: json["audit"],
        note: json["note"],
        matchSocre: json["matchSocre"],
        createAt: json["createAt"],
      );

  Map<String, dynamic> toJson() => {
        "pictureId": pictureId,
        "userId": userId,
        "image": image,
        "mediaType": mediaType,
        "weight": weight,
        "label": label,
        "audit": audit,
        "note": note,
        "matchSocre": matchSocre,
        "createAt": createAt,
      };
}

EUserInfo eUserInfoFromJson(String str) => EUserInfo.fromJson(json.decode(str));

String eUserInfoToJson(EUserInfo data) => json.encode(data.toJson());

class EUserInfo {
  int? userId;
  String? birthday;
  String? wechat;
  String? qq;
  String? height;
  String? weight;
  String? describe;
  int? professionId;
  String? profession;
  String? liveCity;
  String? liveCityId;
  String? actClasName;
  String? actClasId;
  int? pass;
  String? objectName;
  String? objectId;
  int? hideContact;
  int? activeContact;
  String? inviteCode;
  int? device;
  int? label;

  EUserInfo({
    this.userId,
    this.birthday,
    this.wechat,
    this.qq,
    this.height,
    this.weight,
    this.describe,
    this.professionId,
    this.profession,
    this.liveCity,
    this.liveCityId,
    this.actClasName,
    this.actClasId,
    this.pass,
    this.objectName,
    this.objectId,
    this.hideContact,
    this.activeContact,
    this.inviteCode,
    this.device,
    this.label,
  });

  factory EUserInfo.fromJson(Map<String, dynamic> json) => EUserInfo(
        userId: json["userId"],
        birthday: json["birthday"],
        wechat: json["wechat"],
        qq: json["qq"],
        height: json["height"],
        weight: json["weight"],
        describe: json["describe"],
        professionId: json["professionId"],
        profession: json["profession"],
        liveCity: json["liveCity"],
        liveCityId: json["liveCityId"],
        actClasName: json["actClasName"],
        actClasId: json["actClasId"],
        pass: json["pass"],
        objectName: json["objectName"],
        objectId: json["objectId"],
        hideContact: json["hideContact"],
        activeContact: json["activeContact"],
        inviteCode: json["inviteCode"],
        device: json["device"],
        label: json["label"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "birthday": birthday,
        "wechat": wechat,
        "qq": qq,
        "height": height,
        "weight": weight,
        "describe": describe,
        "professionId": professionId,
        "profession": profession,
        "liveCity": liveCity,
        "liveCityId": liveCityId,
        "actClasName": actClasName,
        "actClasId": actClasId,
        "pass": pass,
        "objectName": objectName,
        "objectId": objectId,
        "hideContact": hideContact,
        "activeContact": activeContact,
        "inviteCode": inviteCode,
        "device": device,
        "label": label,
      };
}
