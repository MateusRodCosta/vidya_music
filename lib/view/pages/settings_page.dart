import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidya_music/controller/providers/settings_provider.dart';
import 'package:vidya_music/utils/build_context_l10n_ext.dart';
import 'package:vidya_music/utils/theme_mode_tile_ext.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const List<ThemeMode> _availableThemeModes = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsPageTitle)),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16,
                  top: 16,
                  right: 16,
                  bottom: 8,
                ),
                child: Text(
                  context.l10n.settingsAppearanceHeader,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Consumer<SettingsProvider>(
                builder:
                    (context, value, child) => ListTile(
                      leading: const Icon(Icons.brush_outlined),
                      title: Text(context.l10n.themeModeHeader),
                      subtitle: Text(value.themeMode.l10n(context)),
                      onTap:
                          () => showDialog<void>(
                            context: context,
                            builder:
                                (context) => SimpleDialog(
                                  title: Text(context.l10n.themeModeHeader),
                                  children: [
                                    ..._availableThemeModes.map(
                                      (theme) => _buildThemeDialogTile(
                                        context,
                                        themeMode: theme,
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeDialogTile(
    BuildContext context, {
    required ThemeMode themeMode,
  }) {
    return ListTile(
      leading: Icon(themeMode.icon),
      title: Text(themeMode.l10n(context)),
      onTap: () async {
        await context.read<SettingsProvider>().setThemeMode(themeMode);

        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}
