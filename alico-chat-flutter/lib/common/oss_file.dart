import 'dart:io';

import 'package:alico_chat/entity/oss_policy_entity.dart';
import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:dio/dio.dart';

class OssFile {
  static OssPolicyEntity? _policyEntity;
  static int _policyEntityUpdateTime = 0;

  static Future<OssPolicyEntity> _getPolicy() async {
    var millisecondsSinceEpoch = DateTime.now().millisecondsSinceEpoch;
    if (_policyEntity != null && millisecondsSinceEpoch - _policyEntityUpdateTime < 1000 * 60 * 3) {
      return _policyEntity!;
    }
    var data = await HttpClient.dio.get(HttpUrl.GET_OSS_POLICY).checkResponse();
    var ossPolicyEntity = OssPolicyEntity.fromJson(data);
    _policyEntityUpdateTime = millisecondsSinceEpoch;
    return ossPolicyEntity;
  }

  static Future<String> upload(File file, String ossPath) async {
    var policyEntity = _policyEntity;
    try {
      policyEntity = await _getPolicy();
    } catch (e) {
      return Future.error("getPolicy error:$e");
    }
    if (policyEntity == null) Future.error("policy null");
    if (policyEntity!.host == null || policyEntity.host?.isEmpty == true) Future.error("host empty");
    var data = FormData.fromMap({
      "ossaccessKeyId": policyEntity.accessKeyId,
      "policy": policyEntity.policy,
      "signature": policyEntity.signature,
      "key": ossPath,
      // "callback": policyEntity.callback,
      "file": await MultipartFile.fromFile(file.path)
    });
    var response = await HttpClient.dio.post(policyEntity.host ?? "", data: data);
    if (response.statusCode != 204) {
      return Future.error("upload failed：statusCode！=204");
    }
    return "${policyEntity.host}/$ossPath";
  }
}
