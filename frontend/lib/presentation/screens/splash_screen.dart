// Pantalla de presentación (tarea T126): se ve un instante al abrir la app, mientras se
// comprueba si hay una sesión guardada [CU-H1-E9].

import 'package:flutter/material.dart';

import '../widgets/aurora_scaffold.dart';
import '../widgets/brand_title.dart';
import '../widgets/scanner_logo.dart';

/// Presentación con el logo mientras se comprueba si hay una sesión guardada.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AuroraScaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScannerLogo(),
              SizedBox(height: 24),
              BrandTitle(),
              SizedBox(height: 24),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
