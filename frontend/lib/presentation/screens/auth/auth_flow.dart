// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Navegación entre bienvenida, ingreso y registro (tarea T126; spec 002, Historia 1).
//
// Las tres pantallas cambian con un desvanecimiento suave. El botón «atrás» de Android
// vuelve a la bienvenida. Si la sesión venció, se abre directamente el ingreso
// [CU-H2-E5].

import 'package:flutter/material.dart';

import '../../../models/operation_status.dart';
import '../../../state/auth_controller.dart';
import '../../widgets/motion.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'welcome_screen.dart';

enum _AuthPage { welcome, login, register }

/// Bienvenida, ingreso y registro: muestra una de las tres pantallas y pasa de una a
/// otra con un desvanecimiento. Si la sesión venció, empieza en el ingreso.
class AuthFlow extends StatefulWidget {
  const AuthFlow({super.key, required this.auth});

  /// Sesión: ingresar, registrarse y saber si la sesión venció.
  final AuthController auth;

  @override
  State<AuthFlow> createState() {
    throw UnimplementedError("T126 pendiente de LUISDACA");
  }
}

class _AuthFlowState extends State<AuthFlow> {
  late _AuthPage _page = widget.auth.notice == StatusEvent.sessionExpired
      ? _AuthPage.login
      : _AuthPage.welcome;

  void _go(_AuthPage page) {
    throw UnimplementedError("T126 pendiente de LUISDACA");
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T126 pendiente de LUISDACA");
  }
}
