import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'presentation/screens/about_screen.dart';
import 'presentation/screens/tips_screen.dart';
import 'presentation/strings.dart';
import 'theme/app_theme.dart';

void main() {
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString('assets/fonts/OFL-Poppins.txt');
    yield LicenseEntryWithLineBreaks(['Poppins'], license);
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: AppStrings.title,
    theme: AppTheme.light(),
    darkTheme: AppTheme.dark(),
    home: const WelcomeScreen(),
  );
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text(AppStrings.title)),
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(AppStrings.welcome),
          TextButton(
            onPressed: () => Navigator.push<void>(
              context,
              MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
            ),
            child: const Text(AppStrings.aboutLink),
          ),
          TextButton(
            onPressed: () => Navigator.push<bool>(
              context,
              MaterialPageRoute<bool>(builder: (_) => const TipsScreen()),
            ),
            child: const Text(AppStrings.tips),
          ),
        ],
      ),
    ),
  );
}
