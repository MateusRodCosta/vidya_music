import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;
import 'package:vidya_music/config/branding.dart';
import 'package:vidya_music/features/playlist/domain/entities/config.dart';
import 'package:vidya_music/features/playlist/domain/repositories/config_repository.dart';

class ConfigRepositoryImpl extends ConfigRepository {
  ConfigRepositoryImpl();

  @override
  Future<Config?> getConfig() async {
    final js = await rootBundle.loadString(playlistConfigPath);
    final decoded = json.decode(js) as Map<String, dynamic>;
    return Config.fromJson(decoded);
  }
}
