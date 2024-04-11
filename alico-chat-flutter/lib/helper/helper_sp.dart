import 'package:shared_preferences/shared_preferences.dart';

class HelperSp {

  static SharedPreferences? _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get() {
    return _sharedPreferences!;
  }
}

class SPKey{
  static String KEY_ACCOUNT_USER_ID = "KEY_ACCOUNT_USER_ID";
  static String KEY_ACCOUNT_TOKEN = "KEY_ACCOUNT_TOKEN";

}
