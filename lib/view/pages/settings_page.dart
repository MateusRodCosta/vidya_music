import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidya_music/controller/providers/settings_provider.dart';
import 'package:vidya_music/utils/l10n_ext.dart';
import 'package:vidya_music/utils/theme_mode_tile_ext.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsPageTitle)),
      body: SizedBox(
        height: double.infinity,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 56),
                  child: Text(
                    context.l10n.settingsAppearanceHeader,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Consumer<SettingsProvider>(
                  builder:
                      (context, value, child) => ListTile(
                        leading: const Icon(Icons.brush_outlined),
                        title: Text(context.l10n.settingsAppearanceHeader),
                        subtitle: Text(value.themeMode.tileLabelKey(context)),
                        onTap:
                            () => showAdaptiveDialog<void>(
                              context: context,
                              builder:
                                  (context) => SimpleDialog(
                                    title: Text(context.l10n.themeModeHeader),
                                    children: [
                                      ...[
                                        ThemeMode.system,
                                        ThemeMode.light,
                                        ThemeMode.dark,
                                      ].map(
                                        (theme) => _buildThemeDialogTile(
                                          context,
                                          themeMode: theme,
                                        ),
                                      ),
                                    ],
                                  ),
                              barrierDismissible: true,
                            ),
                      ),
                ),
              ],
            ),
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
      leading: Icon(themeMode.tileIcon),
      title: Text(themeMode.tileLabelKey(context)),
      onTap: () async {
        await context.read<SettingsProvider>().setThemeMode(themeMode);

        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}
