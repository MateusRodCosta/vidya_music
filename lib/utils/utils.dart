import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vidya_music/utils/branding.dart';

Future<int?> getAndroidSdk() async {
  if (!Platform.isAndroid) return null;

  final deviceInfoPlugin = DeviceInfoPlugin();
  final androidInfo = await deviceInfoPlugin.androidInfo;
  return androidInfo.version.sdkInt;
}

Future<Uri> getPlayerArtFileFromAssets() async {
  final byteData = await rootBundle.load(appIconPath);
  final buffer = byteData.buffer;
  final tempDir = await getApplicationDocumentsDirectory();
  final tempPath = tempDir.path;
  final filePath = '$tempPath/player_artwork_generic.png';
  return (await File(filePath).writeAsBytes(
    buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
  ))
      .uri;
}
