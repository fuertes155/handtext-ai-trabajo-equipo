// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Pantalla de registro (tarea T126; spec 002, CU-H1-E2 a CU-H1-E5).
//
// Nombre, correo, contraseña (con barra de seguridad), confirmación y la autorización
// del tratamiento de datos. Antes de enviar se aplican las mismas reglas que el
// servidor (account_rules.dart); el servidor las vuelve a aplicar.

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

/// Pantalla para crear una cuenta: nombre, correo, contraseña, confirmación y
/// autorización del tratamiento de los datos.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({
    super.key,
    required this.auth,
    required this.onBack,
    required this.onSignIn,
  });

  /// Sesión: envía el registro a la API.
  final AuthController auth;

  /// Vuelve a la bienvenida.
  final VoidCallback onBack;

  /// Abre el ingreso, para quien ya tiene cuenta.
  final VoidCallback onSignIn;

  @override
  State<RegisterScreen> createState() {
    throw UnimplementedError("T126 pendiente de LUISDACA");
  }
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmation = TextEditingController();
  bool _acceptsDataPolicy = false;
  AppFailure? _formFailure;

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmation.dispose();
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
