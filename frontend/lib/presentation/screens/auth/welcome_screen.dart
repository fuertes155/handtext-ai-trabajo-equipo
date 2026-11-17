// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
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
    throw UnimplementedError("T126 pendiente de LUISDACA");
  }
}

/// Un paso de «cómo funciona»: ícono en una insignia azul y su texto.
class _Step extends StatelessWidget {
  const _Step({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T126 pendiente de LUISDACA");
  }
}
