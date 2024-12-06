import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vidya_music/controller/providers/settings_provider.dart';
import 'package:vidya_music/generated/locale_keys.g.dart';
import 'package:vidya_music/utils/theme_mode_tile_ext.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(LocaleKeys.settingsPageTitle).tr()),
      body: Expanded(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 56),
                child: Text(
                  LocaleKeys.settingsAppearanceHeader,
                  style: Theme.of(context).textTheme.titleMedium,
                ).tr(),
              ),
              Consumer<SettingsProvider>(
                builder: (context, value, child) => ListTile(
                  leading: const Icon(Icons.brush_outlined),
                  title: const Text(LocaleKeys.settingsAppearanceHeader).tr(),
                  subtitle: Text(value.themeMode.tileLabelKey).tr(),
                  onTap: () => showAdaptiveDialog<void>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: const Text(LocaleKeys.themeModeHeader).tr(),
                      children: [
                        ...[ThemeMode.system, ThemeMode.light, ThemeMode.dark]
                            .map(
                          (theme) =>
                              _buildThemeDialogTile(context, themeMode: theme),
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
      leading: Icon(themeMode.tileIcon),
      title: Text(themeMode.tileLabelKey).tr(),
      onTap: () async {
        await context.read<SettingsProvider>().setThemeMode(themeMode);

        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}
