// To parse this JSON data, do
//
//     final ossPolicyEntity = ossPolicyEntityFromJson(jsonString);

import 'dart:convert';

OssPolicyEntity ossPolicyEntityFromJson(String str) => OssPolicyEntity.fromJson(json.decode(str));

String ossPolicyEntityToJson(OssPolicyEntity data) => json.encode(data.toJson());

class OssPolicyEntity {
  String? accessKeyId;
  String? policy;
  String? signature;
  String? expire;
  String? dir;
  String? host;
  String? callback;

  OssPolicyEntity({
    this.accessKeyId,
    this.policy,
    this.signature,
    this.expire,
    this.dir,
    this.host,
    this.callback,
  });

  factory OssPolicyEntity.fromJson(Map<String, dynamic> json) => OssPolicyEntity(
    accessKeyId: json["accessKeyId"],
    policy: json["policy"],
    signature: json["signature"],
    expire: json["expire"],
    dir: json["dir"],
    host: json["host"],
    callback: json["callback"],
  );

  Map<String, dynamic> toJson() => {
    "accessKeyId": accessKeyId,
    "policy": policy,
    "signature": signature,
    "expire": expire,
    "dir": dir,
    "host": host,
    "callback": callback,
  };
}
