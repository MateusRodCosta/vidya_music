import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? _prefs;

  static Future<SharedPreferences> get instance async {
    if (_prefs != null) {
      return _prefs!;
    } else {
      _prefs = await SharedPreferences.getInstance();
      return _prefs!;
    }
  }
}
