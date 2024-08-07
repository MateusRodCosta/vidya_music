import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:vidya_music/controller/cubit/theme_cubit.dart';
import 'package:vidya_music/generated/locale_keys.g.dart';
import 'package:vidya_music/utils/theme_mode_tile_ext.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(LocaleKeys.settingsPageTitle).tr()),
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
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) => ListTile(
                  leading: const Icon(Icons.brush_outlined),
                  title: Text(LocaleKeys.settingsAppearanceHeader).tr(),
                  subtitle: Text(state.themeMode.tileLabelKey).tr(),
                  onTap: () => showAdaptiveDialog<void>(
                    context: context,
                    builder: (context) => SimpleDialog(
                      title: Text(LocaleKeys.themeModeHeader).tr(),
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
        await context.read<ThemeCubit>().setThemeMode(themeMode);

        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }
}
