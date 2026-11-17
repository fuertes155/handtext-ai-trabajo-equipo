// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Pantalla de bloqueo (tarea T1005; spec 011, Historia 2; research.md de 011, R4).
//
// AppLockGate envuelve toda la app (encima del Navigator, así también tapa Ajustes, Mis
// documentos y los diálogos). Mientras está bloqueada:
// - la app queda oculta pero viva (Offstage): al desbloquear, todo sigue donde estaba
//   [BL-H2-E2] [SC-1103];
// - se ve LockScreen, que pide la verificación sola una vez y luego con «Desbloquear»
//   [BL-H2-E3].

import 'package:flutter/material.dart';

import '../../state/app_lock_controller.dart';
import '../../theme/aurora.dart';
import '../strings.dart';
import '../widgets/aurora_scaffold.dart';
import '../widgets/brand_title.dart';
import '../widgets/primary_button.dart';
import '../widgets/scanner_logo.dart';

/// Envuelve toda la app: si está bloqueada, la oculta y pone [LockScreen] encima.
///
/// Va en `MaterialApp.builder` (app.dart), por encima de todas las pantallas y
/// diálogos (research.md de 011, R4). [lock] dice si está bloqueada.
class AppLockGate extends StatelessWidget {
  const AppLockGate({super.key, required this.lock, required this.child});

  final AppLockController lock;

  /// La app completa, tal como la arma MaterialApp.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T1005 pendiente de LUISDACA");
  }
}

/// Pantalla de bloqueo: logo y «Desbloquear». Al aparecer pide la verificación una
/// vez sola; si se cancela, el botón la vuelve a pedir.
class LockScreen extends StatefulWidget {
  const LockScreen({super.key, required this.lock});

  final AppLockController lock;

  @override
  State<LockScreen> createState() {
    throw UnimplementedError("T1005 pendiente de LUISDACA");
  }
}

class _LockScreenState extends State<LockScreen> {
  @override
  void initState() {
    throw UnimplementedError("T1005 pendiente de LUISDACA");
  }

  Future<void> _unlock() async {
    throw UnimplementedError("T1005 pendiente de LUISDACA");
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T1005 pendiente de LUISDACA");
  }
}
