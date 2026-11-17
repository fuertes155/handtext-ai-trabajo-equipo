// Pantalla de bienvenida (tareas T126 y T143; spec 002, CU-H1-E1).
//
// Logo animado, título de marca, los tres pasos de la app en una tarjeta y los botones
// «Crear cuenta» y «Ya tengo cuenta». Si hay un aviso (sesión cerrada, vencida o cuenta
// eliminada), lo muestra arriba de los botones.
// Spec 005 (tarea T408): «Privacidad y acerca de» se puede leer antes de crear la
// cuenta [AV-H2-E1].
// Spec 008 (tarea T706): botón de idioma arriba, para elegirlo antes de crear la cuenta
// [IE-H1-E2].

import 'package:flutter/material.dart';

import '../../../models/operation_status.dart';
import '../../../state/auth_controller.dart';
import '../../../theme/aurora.dart';
import '../../strings.dart';
import '../../widgets/aurora_scaffold.dart';
import '../../widgets/brand_title.dart';
import '../../widgets/language_sheet.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/scanner_logo.dart';
import '../../widgets/status_banner.dart';
import '../../widgets/surface_card.dart';
import '../about_screen.dart';

/// Primera pantalla sin sesión: presenta la app y ofrece crear una cuenta o
/// ingresar.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.auth,
    required this.onCreateAccount,
    required this.onSignIn,
  });

  /// Sesión: de ella sale el aviso que se muestra (sesión cerrada, vencida o cuenta
  /// eliminada).
  final AuthController auth;

  /// Abre el registro.
  final VoidCallback onCreateAccount;

  /// Abre el ingreso.
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return AuroraScaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 480),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.centerRight,
                  child: LanguageButton(),
                ),
                const Center(child: ScannerLogo()),
                const SizedBox(height: 24),
                const BrandTitle(style: TextStyle(fontSize: 32)),
                const SizedBox(height: 16),
                Text(
                  strings.welcomeTagline,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Aurora.textSecondary,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 24),
                SurfaceCard(
                  child: Column(
                    children: [
                      _Step(
                        icon: Icons.add_a_photo_outlined,
                        text: strings.welcomeStep1,
                      ),
                      const SizedBox(height: 16),
                      _Step(icon: Icons.edit_note, text: strings.welcomeStep2),
                      const SizedBox(height: 16),
                      _Step(
                        icon: Icons.description_outlined,
                        text: strings.welcomeStep3,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (auth.failure != null) ...[
                  StatusBanner(
                    status: OperationStatus.failure(auth.failure!),
                    onAurora: true,
                  ),
                  const SizedBox(height: 16),
                ],
                if (auth.notice != null) ...[
                  StatusBanner(
                    status: OperationStatus.info(auth.notice!),
                    onAurora: true,
                  ),
                  const SizedBox(height: 16),
                ],
                PrimaryButton(
                  label: strings.createAccount,
                  onPressed: onCreateAccount,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: onSignIn,
                  child: Text(strings.haveAccount),
                ),
                const SizedBox(height: 20),
                Text(
                  strings.welcomePrivacyNote,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Aurora.textMuted),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const AboutScreen(),
                    ),
                  ),
                  child: Text(strings.privacyAndAbout),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Un paso de «cómo funciona»: ícono en una insignia azul y su texto.
class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ExcludeSemantics(child: Icon(icon, color: Aurora.blueLight)),
        const SizedBox(width: 12),
        Expanded(child: Text(text)),
      ],
    );
  }
}
