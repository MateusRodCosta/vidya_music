import 'dart:developer' as developer;
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:vidya_music/utils/branding.dart';

Future<Uri?> getPlayerArtFromAssets() async {
  try {
    final byteData = await rootBundle.load(appIconPath);
    final assetBytes = byteData.buffer.asUint8List(
      byteData.offsetInBytes,
      byteData.lengthInBytes,
    );

    final documentsDir = await getApplicationDocumentsDirectory();
    final filePath = path.join(documentsDir.path, 'generic_artwork.png');
    final file = File(filePath);

    var shouldWriteFile = true;

    if (file.existsSync()) {
      final existingFileBytes = await file.readAsBytes();
      if (listEquals(assetBytes, existingFileBytes)) {
        shouldWriteFile = false;
      }
    }

    if (shouldWriteFile) {
      await file.writeAsBytes(assetBytes);
    }

    return Uri.file(filePath);
  } catch (e, s) {
    developer.log(
      e.toString(),
      name: 'getPlayerArtFromAssets',
      error: e,
      stackTrace: s,
    );
    return null;
  }
}

Future<int?> getAndroidSdk() async {
  if (!Platform.isAndroid) return null;

  final deviceInfo = DeviceInfoPlugin();
  final androidInfo = await deviceInfo.androidInfo;

  return androidInfo.version.sdkInt;
}

Future<bool> get isAndroidQOrHigher async {
  final sdk = await getAndroidSdk();
  if (sdk == null) return false;

  return sdk >= 29;
}
