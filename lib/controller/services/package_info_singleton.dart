import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoSingleton {
  static PackageInfo? _packageInfo;

  static Future<PackageInfo> get instance async {
    if (_packageInfo != null) {
      return _packageInfo!;
    } else {
      _packageInfo = await PackageInfo.fromPlatform();
      return _packageInfo!;
    }
  }
}
