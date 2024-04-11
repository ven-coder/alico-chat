// To parse this JSON data, do
//
//     final entityShareList = entityShareListFromJson(jsonString);

import 'dart:convert';

import 'package:alico_chat/entity/entity_user.dart';

EntityShareList entityShareListFromJson(String str) => EntityShareList.fromJson(json.decode(str));

String entityShareListToJson(EntityShareList data) => json.encode(data.toJson());

class EntityShareList {
  List<ListElement>? list;
  int? page;
  int? limit;

  EntityShareList({
    this.list,
    this.page,
    this.limit,
  });

  factory EntityShareList.fromJson(Map<String, dynamic> json) => EntityShareList(
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
  int? activityId;
  int? activityClassifyId;
  String? activityClassifyName;
  int? userId;
  int? labelId;
  LabelCode? labelCode;
  String? labelName;
  String? objectClassifyId;
  Name? objectClassifyName;
  int? locationId;
  String? locationName;
  String? positionCity;
  String? activityTime;
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
  bool? liked;
  bool? signed;
  int? isFinish;
  List<Like>? likes;
  List<Comment>? comments;
  int? commentCount;
  List<Name>? hopeBeauNames;

  ListElement({
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
    this.liked,
    this.signed,
    this.isFinish,
    this.likes,
    this.comments,
    this.commentCount,
    this.hopeBeauNames,
  });

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        activityId: json["activityId"],
        activityClassifyId: json["activityClassifyId"],
        activityClassifyName: json["activityClassifyName"],
        userId: json["userId"],
        labelId: json["labelId"],
        labelCode: labelCodeValues.map[json["labelCode"]],
        labelName: json["labelName"],
        objectClassifyId: json["objectClassifyId"],
        objectClassifyName: nameValues.map[json["objectClassifyName"]],
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
        liked: json["liked"],
        signed: json["signed"],
        isFinish: json["isFinish"],
        likes: json["likes"] == null ? [] : List<Like>.from(json["likes"]!.map((x) => Like.fromJson(x))),
        comments: json["comments"] == null ? [] : List<Comment>.from(json["comments"]!.map((x) => Comment.fromJson(x))),
        commentCount: json["commentCount"],
        hopeBeauNames: json["hopeBeauNames"] == null ? [] : List<Name>.from(json["hopeBeauNames"]!.map((x) => nameValues.map[x]!)),
      );

  Map<String, dynamic> toJson() => {
        "activityId": activityId,
        "activityClassifyId": activityClassifyId,
        "activityClassifyName": activityClassifyName,
        "userId": userId,
        "labelId": labelId,
        "labelCode": labelCodeValues.reverse[labelCode],
        "labelName": labelName,
        "objectClassifyId": objectClassifyId,
        "objectClassifyName": nameValues.reverse[objectClassifyName],
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
        "liked": liked,
        "signed": signed,
        "isFinish": isFinish,
        "likes": likes == null ? [] : List<dynamic>.from(likes!.map((x) => x.toJson())),
        "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x.toJson())),
        "commentCount": commentCount,
        "hopeBeauNames": hopeBeauNames == null ? [] : List<dynamic>.from(hopeBeauNames!.map((x) => nameValues.reverse[x])),
      };
}

class Comment {
  int? id;
  int? userId;
  int? toUserId;
  int? activityId;
  int? activityType;
  int? commentType;
  int? commentUserId;
  int? createdAt;
  String? comment;
  String? username;
  EntityUser? commentUserInfo;

  Comment({
    this.id,
    this.userId,
    this.toUserId,
    this.activityId,
    this.activityType,
    this.commentType,
    this.commentUserId,
    this.comment,
    this.username,
    this.commentUserInfo,
    this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        userId: json["userId"],
        toUserId: json["toUserId"],
        activityId: json["activityId"],
        activityType: json["activityType"],
        commentType: json["commentType"],
        commentUserId: json["commentUserId"],
        comment: json["comment"],
        username: json["username"],
        createdAt: json["createdAt"],
        commentUserInfo: json["commentUserInfo"] == null ? null : EntityUser.fromJson(json["commentUserInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userId": userId,
        "toUserId": toUserId,
        "activityId": activityId,
        "activityType": activityType,
        "commentType": commentType,
        "commentUserId": commentUserId,
        "comment": comment,
        "username": username,
        "createdAt": createdAt,
        "commentUserInfo": commentUserInfo == null ? null : commentUserInfo!.toJson(),
      };
}

enum Name { EMPTY, NAME }

final nameValues = EnumValues({"幽默": Name.EMPTY, "": Name.NAME});

enum LabelCode { DEFAULT, FOLLOW }

final labelCodeValues = EnumValues({"DEFAULT": LabelCode.DEFAULT, "FOLLOW": LabelCode.FOLLOW});

class Like {
  int? id;
  int? activityId;
  int? userId;

  Like({
    this.id,
    this.activityId,
    this.userId,
  });

  factory Like.fromJson(Map<String, dynamic> json) => Like(
        id: json["id"],
        activityId: json["activityId"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "activityId": activityId,
        "userId": userId,
      };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
