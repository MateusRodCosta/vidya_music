import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoSingleton {
  PackageInfoSingleton._internal();

  static Future<PackageInfo>? _packageInfoFuture;

  static Future<PackageInfo> get instance {
    _packageInfoFuture ??= PackageInfo.fromPlatform();
    return _packageInfoFuture!;
  }
}
