import 'package:flutter/material.dart';

import '../../config/app_config.dart';
import '../strings.dart';
import 'privacy_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(AppStrings.about)),
    body: ListView(
      children: [
        const ListTile(
          title: Text(AppStrings.title),
          subtitle: Text(
            'Versión ${AppConfig.appVersion} (${AppConfig.appBuild})',
          ),
        ),
        ListTile(
          title: const Text(AppStrings.privacy),
          onTap: () => Navigator.push<void>(
            context,
            MaterialPageRoute<void>(builder: (_) => const PrivacyScreen()),
          ),
        ),
        ListTile(
          title: const Text('Licencias'),
          onTap: () => showLicensePage(
            context: context,
            applicationName: AppStrings.title,
          ),
        ),
      ],
    ),
  );
}
