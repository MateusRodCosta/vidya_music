// ignore_for_file: one_member_abstracts

import 'package:vidya_music/features/playlist/domain/entities/config.dart';

abstract class ConfigRepository {
  Future<Config?> getConfig();
}
