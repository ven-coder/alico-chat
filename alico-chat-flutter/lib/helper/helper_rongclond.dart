import 'package:alico_chat/http/http_client.dart';
import 'package:alico_chat/http/http_url.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';

class HelperRongclond {
  static RCIMIWEngine? _engine;

  //消息接收监听，添加记得移除❗
  static List<Function(RCIMIWMessage? message, int? left, bool? offline, bool? hasPackage)> onMessageReceivedListeners = [];

  //添加记得移除❗
  static List<Function()> onConnectListeners = [];

  //添加记得移除❗
  static final List<Function()> _onCommonListeners = [];

  static void removeCommonListeners(Function() value) {
    _onCommonListeners.remove(value);
  }

  static void addCommonListeners(Function() value) {
    _onCommonListeners.add(value);
  }

  static void notifyCommonListeners() {
    for (var element in _onCommonListeners) {
      element.call();
    }
  }

  static Future<void> init() async {
    RCIMIWEngineOptions options = RCIMIWEngineOptions.create();
    _engine = await RCIMIWEngine.create("kj7swf8okmra2", options);

    _engine?.onMessageReceived = (RCIMIWMessage? message, int? left, bool? offline, bool? hasPackage) {
      for (var element in onMessageReceivedListeners) {
        element.call(message, left, offline, hasPackage);
      }
    };
  }

  static Future<void> connect() async {
    try {
      if (_engine == null) {
        await init();
      }
      var data = await HttpClient.dio.get(HttpUrl.GET_RONGCLOND_TOKEN).checkResponse();
      _engine!.connect(data, 30, callback: RCIMIWConnectCallback(onConnected: (code, userId) {
        for (var element in onConnectListeners) {
          element.call();
        }
      }));
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future<RCIMIWEngine?> getEngine() async {
    if (_engine == null) {
      await connect();
    }
    return _engine;
  }

  static void logout() {
    if (_engine != null) {
      _engine?.disconnect(false);
      onMessageReceivedListeners.clear();
      onConnectListeners.clear();
      _onCommonListeners.clear();
    }
  }
}
