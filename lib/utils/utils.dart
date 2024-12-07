import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vidya_music/utils/branding.dart';

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
