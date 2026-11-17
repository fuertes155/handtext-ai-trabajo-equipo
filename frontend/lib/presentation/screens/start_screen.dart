// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Pantalla de inicio (tareas T043 y T132; spec 001, módulo 1; spec 002, módulo 5).
//
// Sobre el fondo Aurora:
// - Saludo con el nombre de la persona y su menú de cuenta (avatar) [CU-H1-E6].
// - Tarjeta principal con el logo-escáner animado.
// - Tarjetas de acción: «Tomar fotografía» (Historia 2) y «Elegir imagen guardada»
//   (Historia 1), más «Escanear hoja» (spec 009, abajo).
// - Requisitos de la imagen y avisos (permiso de cámara denegado, imagen rechazada…).
// - Si se llegó desde «Procesar otra imagen», ofrece volver al texto actual, que se
//   conserva [H1-E13].
// - Spec 006: enlace a los consejos para una buena foto [PA-H1-E5].
// - Spec 007: acceso a «Mis documentos», con cuántos hay guardados [HD-H1-E4].
// - Spec 009: «Escanear hoja» es la primera opción [ED-H1-E1]; si el escáner no está
//   disponible, el aviso ofrece «Tomar fotografía» [ED-H2-E1].

import 'package:flutter/material.dart';

import '../../models/operation_status.dart';
import '../../state/auth_controller.dart';
import '../../state/document_flow_controller.dart';
import '../../theme/aurora.dart';
import '../strings.dart';
import '../widgets/account_menu.dart';
import '../widgets/action_tile.dart';
import '../widgets/aurora_scaffold.dart';
import '../widgets/scanner_logo.dart';
import '../widgets/status_banner.dart';
import '../widgets/surface_card.dart';
import 'history_screen.dart';
import 'tips_screen.dart';

/// Pantalla de inicio: escanear, tomar una foto o elegir una imagen, y acceso a Mis
/// documentos.
class StartScreen extends StatelessWidget {
  const StartScreen({super.key, required this.controller, required this.auth});

  /// El documento en curso: recibe la imagen elegida y da los avisos.
  final DocumentFlowController controller;

  /// Sesión: el nombre del saludo y el menú de la cuenta.
  final AuthController auth;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T043 pendiente de LUISDACA");
  }
}
