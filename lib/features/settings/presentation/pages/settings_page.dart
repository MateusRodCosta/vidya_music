import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vidya_music/core/singletons/package_info_singleton.dart';

import 'package:vidya_music/core/utils/extensions/build_context_l10n_ext.dart';
import 'package:vidya_music/core/utils/extensions/theme_mode_ext.dart';
import 'package:vidya_music/features/settings/presentation/provider/settings_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const List<ThemeMode> _availableThemeModes = [
    ThemeMode.system,
    ThemeMode.light,
    ThemeMode.dark,
  ];

  RoundedRectangleBorder _getListTileShape() {
    return RoundedRectangleBorder(borderRadius: BorderRadius.circular(32));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.settingsPageTitle)),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ..._buildAppearanceSection(context),
              ..._buildAboutSection(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required String l10nKey,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16,
        top: 16,
        right: 16,
        bottom: 8,
      ),
      child: Text(
        l10nKey,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _buildThemeDialogOption(
    BuildContext context, {
    required ThemeMode themeMode,
  }) {
    return ListTile(
      shape: _getListTileShape(),
      leading: Icon(themeMode.icon),
      title: Text(themeMode.l10n(context)),
      onTap: () async {
        await context.read<SettingsProvider>().setThemeMode(themeMode);

        if (context.mounted) Navigator.of(context).pop();
      },
    );
  }

  Widget _buildThemeSelectorTile() {
    return Consumer<SettingsProvider>(
      builder: (context, value, child) => ListTile(
        shape: _getListTileShape(),
        leading: const Icon(Icons.brush_outlined),
        title: Text(context.l10n.themeModeHeader),
        subtitle: Text(value.themeMode.l10n(context)),
        onTap: () => showDialog<void>(
          context: context,
          builder: (context) => SimpleDialog(
            title: Text(context.l10n.themeModeHeader),
            children: [
              ..._availableThemeModes.map(
                (theme) => _buildThemeDialogOption(
                  context,
                  themeMode: theme,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildAppearanceSection(BuildContext context) {
    return [
      _buildHeader(
        context,
        l10nKey: context.l10n.settingsAppearanceHeader,
      ),
      _buildThemeSelectorTile(),
    ];
  }

  Widget _buildAboutTile(BuildContext context) {
    return ListTile(
      shape: _getListTileShape(),
      leading: const Icon(Icons.help_outline),
      title: Text(context.l10n.aboutTile),
      onTap: () async {
        final packageInfo = await PackageInfoSingleton.instance;

        if (!context.mounted) return;

        showAboutDialog(
          context: context,
          applicationName: packageInfo.appName,
          applicationVersion: packageInfo.version,
          applicationLegalese: context.l10n.aboutDialogLicense,
          children: [
            const SizedBox(height: 8),
            Text(context.l10n.aboutDialogAppDescription),
            const SizedBox(height: 8),
            GestureDetector(
              child: Text(
                context.l10n.aboutDialogVipCats777,
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
              onTap: () async {
                await launchUrl(
                  Uri.parse('https://www.vipvgm.net/'),
                  mode: LaunchMode.externalApplication,
                );
              },
            ),
            const SizedBox(height: 8),
            Text(context.l10n.aboutDialogCopyrightNotice),
            const SizedBox(height: 8),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: context.l10n.aboutDialogSourceCode,
                    style: TextStyle(
                      color: Theme.of(context).textTheme.bodyMedium?.color,
                    ),
                  ),
                  TextSpan(
                    text: 'https://github.com/MateusRodCosta/vidya_music',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        await launchUrl(
                          Uri.parse(
                            'https://github.com/MateusRodCosta/vidya_music',
                          ),
                          mode: LaunchMode.externalApplication,
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _buildAboutSection(BuildContext context) {
    return [
      _buildHeader(
        context,
        l10nKey: context.l10n.settingsAboutHeader,
      ),
      _buildAboutTile(context),
    ];
  }
}
