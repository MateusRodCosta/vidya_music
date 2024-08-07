import 'dart:io';

import 'package:vidya_music/utils/utils.dart';

typedef IsEdgeToEdge = bool;

/// [SystemUiMode.edgeToEdge] is only compatible for SDK 29 (Android 10) and up.
/// This method is a helper to determine whether it's supported for the current
/// device.
Future<IsEdgeToEdge> supportsEdgeToEdge() async {
  if (!Platform.isAndroid) return false;

  final sdk = await getAndroidSdk();
  if (sdk == null) return false;

  if (sdk >= 29) return true;

  return false;
}
