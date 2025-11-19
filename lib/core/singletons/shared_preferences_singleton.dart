import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesSingleton {
  SharedPreferencesSingleton._internal();

  static Future<SharedPreferences>? _sharedPreferencesFuture;

  static Future<SharedPreferences> get instance {
    _sharedPreferencesFuture ??= SharedPreferences.getInstance();
    return _sharedPreferencesFuture!;
  }
}
