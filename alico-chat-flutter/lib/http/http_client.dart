import 'package:alico_chat/entity/entity_user.dart';
import 'package:alico_chat/helper/helper_sp.dart';
import 'package:dio/dio.dart';

class HttpClient {
  static const String FORM = "application/x-www-form-urlencoded";
  static const String FORM_MULTIPART = "multipart/form-data";

  static Dio dio = Dio();

  static void init() {
    dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
      Map<String, dynamic> header = await getHeader();
      for (String key in header.keys) {
        options.headers[key] = header[key];
      }
      handler.next(options);
    }));
  }

  static Future<Map<String, dynamic>> getHeader() async {
    var token = HelperSp.get().getString(SPKey.KEY_ACCOUNT_TOKEN);
    return {"Authorization": "Bearer $token"};
  }
}

extension StringExtension on Future<Response> {
  Future<dynamic> checkResponse() async {
    var response = await this;
    var code = response.data["code"];
    var message = response.data["message"];
    if (code == 0) {
      return response.data["data"];
    } else {
      return Future.error("code=$code, message=$message");
    }
  }
}
