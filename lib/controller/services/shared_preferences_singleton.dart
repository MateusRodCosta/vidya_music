import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSingleton {
  static SharedPreferences? _sharedPreferences;

  static Future<SharedPreferences> get instance async {
    if (_sharedPreferences != null) {
      return _sharedPreferences!;
    } else {
      _sharedPreferences = await SharedPreferences.getInstance();
      return _sharedPreferences!;
    }
  }
}
