import 'package:flutter/widgets.dart';
import 'package:vidya_music/utils/l10n_ext.dart';

enum CubitL10nKeys {
  genericError,
  playlistConfigDecodingError,
  rosterErrorCouldntFetch;

  String l10n(BuildContext context) {
    switch (this) {
      case CubitL10nKeys.genericError:
        return context.l10n.genericError;
      case CubitL10nKeys.playlistConfigDecodingError:
        return context.l10n.playlistConfigDecodingError;
      case CubitL10nKeys.rosterErrorCouldntFetch:
        return context.l10n.rosterErrorCouldntFetch;
    }
  }
}
