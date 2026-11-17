// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Pantalla de ingreso (tarea T126; spec 002, CU-H1-E6 a CU-H1-E8).
//
// Correo y contraseña en una tarjeta. Antes de enviar se revisa que ambos
// campos estén llenos; los errores del servidor (datos incorrectos o cuenta bloqueada)
// se muestran en el aviso rojo, con el mismo mensaje para correo y contraseña [SC-203].

import 'package:flutter/material.dart';

import '../../../models/app_failure.dart';
import '../../../models/operation_status.dart';
import '../../../services/account_rules.dart';
import '../../../state/auth_controller.dart';
import '../../../theme/aurora.dart';
import '../../strings.dart';
import '../../widgets/aurora_scaffold.dart';
import '../../widgets/password_field.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/status_banner.dart';
import '../../widgets/surface_card.dart';

/// Pantalla de ingreso con correo y contraseña.
class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.auth,
    required this.onBack,
    required this.onCreateAccount,
  });

  /// Sesión: envía el ingreso a la API.
  final AuthController auth;

  /// Vuelve a la bienvenida.
  final VoidCallback onBack;

  /// Abre el registro, para quien todavía no tiene cuenta.
  final VoidCallback onCreateAccount;

  @override
  State<LoginScreen> createState() {
    throw UnimplementedError("T126 pendiente de LUISDACA");
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  AppFailure? _formFailure;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    throw UnimplementedError("T126 pendiente de LUISDACA");
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T126 pendiente de LUISDACA");
  }
}
