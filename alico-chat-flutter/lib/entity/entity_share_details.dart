// To parse this JSON data, do
//
//     final entityShareDetails = entityShareDetailsFromJson(jsonString);

import 'dart:convert';

import 'package:alico_chat/entity/entity_share_list.dart';

EntityShareDetails entityShareDetailsFromJson(String str) => EntityShareDetails.fromJson(json.decode(str));

String entityShareDetailsToJson(EntityShareDetails data) => json.encode(data.toJson());

class EntityShareDetails {
  int? activityId;
  int? activityClassifyId;
  String? activityClassifyName;
  int? userId;
  int? labelId;
  String? labelCode;
  String? labelName;
  String? objectClassifyId;
  String? objectClassifyName;
  int? locationId;
  String? locationName;
  String? positionCity;
  int? activityTime;
  String? dateRange;
  String? content;
  List<String>? images;
  int? imagesCount;
  int? allowSex;
  int? sex;
  int? finishTime;
  int? likeCount;
  int? applyCount;
  int? activityType;
  int? operatorId;
  int? audit;
  String? note;
  int? status;
  int? weight;
  int? recommendAt;
  int? deleteAt;
  String? createAt;
  String? avatar;
  String? nickname;
  int? vip;
  int? real;
  bool? liked;
  bool? signed;
  List<dynamic>? signs;
  List<dynamic>? likes;
  List<Comment>? comments;
  int? commentCount;

  EntityShareDetails({
    this.activityId,
    this.activityClassifyId,
    this.activityClassifyName,
    this.userId,
    this.labelId,
    this.labelCode,
    this.labelName,
    this.objectClassifyId,
    this.objectClassifyName,
    this.locationId,
    this.locationName,
    this.positionCity,
    this.activityTime,
    this.dateRange,
    this.content,
    this.images,
    this.imagesCount,
    this.allowSex,
    this.sex,
    this.finishTime,
    this.likeCount,
    this.applyCount,
    this.activityType,
    this.operatorId,
    this.audit,
    this.note,
    this.status,
    this.weight,
    this.recommendAt,
    this.deleteAt,
    this.createAt,
    this.avatar,
    this.nickname,
    this.vip,
    this.real,
    this.liked,
    this.signed,
    this.signs,
    this.likes,
    this.comments,
    this.commentCount,
  });

  factory EntityShareDetails.fromJson(Map<String, dynamic> json) => EntityShareDetails(
        activityId: json["activityId"],
        activityClassifyId: json["activityClassifyId"],
        activityClassifyName: json["activityClassifyName"],
        userId: json["userId"],
        labelId: json["labelId"],
        labelCode: json["labelCode"],
        labelName: json["labelName"],
        objectClassifyId: json["objectClassifyId"],
        objectClassifyName: json["objectClassifyName"],
        locationId: json["locationId"],
        locationName: json["locationName"],
        positionCity: json["positionCity"],
        activityTime: json["activityTime"],
        dateRange: json["dateRange"],
        content: json["content"],
        images: json["images"] == null ? [] : List<String>.from(json["images"]!.map((x) => x)),
        imagesCount: json["imagesCount"],
        allowSex: json["allowSex"],
        sex: json["sex"],
        finishTime: json["finishTime"],
        likeCount: json["likeCount"],
        applyCount: json["applyCount"],
        activityType: json["activityType"],
        operatorId: json["operatorId"],
        audit: json["audit"],
        note: json["note"],
        status: json["status"],
        weight: json["weight"],
        recommendAt: json["recommendAt"],
        deleteAt: json["deleteAt"],
        createAt: json["createAt"],
        avatar: json["avatar"],
        nickname: json["nickname"],
        vip: json["vip"],
        real: json["real"],
        liked: json["liked"],
        signed: json["signed"],
        signs: json["signs"] == null ? [] : List<dynamic>.from(json["signs"]!.map((x) => x)),
        likes: json["likes"] == null ? [] : List<dynamic>.from(json["likes"]!.map((x) => x)),
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
        commentCount: json["commentCount"],
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "activityClassifyId": activityClassifyId,
        "activityClassifyName": activityClassifyName,
        "userId": userId,
        "labelId": labelId,
        "labelCode": labelCode,
        "labelName": labelName,
        "objectClassifyId": objectClassifyId,
        "objectClassifyName": objectClassifyName,
        "locationId": locationId,
        "locationName": locationName,
        "positionCity": positionCity,
        "activityTime": activityTime,
        "dateRange": dateRange,
        "content": content,
        "images": images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "imagesCount": imagesCount,
        "allowSex": allowSex,
        "sex": sex,
        "finishTime": finishTime,
        "likeCount": likeCount,
        "applyCount": applyCount,
        "activityType": activityType,
        "operatorId": operatorId,
        "audit": audit,
        "note": note,
        "status": status,
        "weight": weight,
        "recommendAt": recommendAt,
        "deleteAt": deleteAt,
        "createAt": createAt,
        "avatar": avatar,
        "nickname": nickname,
        "vip": vip,
        "real": real,
        "liked": liked,
        "signed": signed,
        "signs": signs == null ? [] : List<dynamic>.from(signs!.map((x) => x)),
        "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x)),
        "comments": comments == null ? [] : List<Comment>.from(comments!.map((x) => x.toJson())),
        "commentCount": commentCount,
      };
}
