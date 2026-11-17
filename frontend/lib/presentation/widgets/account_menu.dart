// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
// Menú de la cuenta: avatar con la inicial y opciones «Cerrar sesión» y «Eliminar
// cuenta» (tarea T130; spec 002, Historia 2).
//
// - [CU-H2-E2] Si hay texto sin exportar, cerrar sesión pide confirmación porque el
//   texto se descartará.
// - [CU-H2-E3] Eliminar la cuenta pide la contraseña; si es correcta se borran la
//   cuenta, sus sesiones y su borrador local.
// - Spec 005 (tarea T405): también abre «Ajustes» y «Acerca de» [AV-H1-E1].
// - Spec 006 (tareas T507 y T511): el avatar mide 48 dp y TalkBack lo lee «Cuenta»,
//   sin la inicial [PA-H2-E1] [PA-H3-E3]; el diálogo de eliminar la cuenta se desplaza
//   con la letra grande [PA-H3-E1].

import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/app_failure.dart';
import '../../state/auth_controller.dart';
import '../../state/document_flow_controller.dart';
import '../../theme/aurora.dart';
import '../screens/about_screen.dart';
import '../screens/settings_screen.dart';
import '../strings.dart';
import 'confirm_dialog.dart';

enum _AccountAction { settings, about, signOut, deleteAccount }

/// Avatar con la inicial de la persona. Abre el menú de la cuenta: Ajustes, Acerca
/// de, Cerrar sesión y Eliminar cuenta.
class AccountButton extends StatelessWidget {
  const AccountButton({super.key, required this.auth, required this.documents});

  /// Sesión: el nombre, cerrar sesión y eliminar la cuenta.
  final AuthController auth;

  /// El documento en curso: para avisar si hay texto sin exportar antes de cerrar
  /// sesión.
  final DocumentFlowController documents;

  Future<void> _signOut(BuildContext context) async {
    throw UnimplementedError("T130,T507,T511 pendiente de LUISDACA");
  }

  Future<void> _deleteAccount(BuildContext context) async {
    throw UnimplementedError("T130,T507,T511 pendiente de LUISDACA");
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T130,T507,T511 pendiente de LUISDACA");
  }
}

/// Círculo azul corporativo con la inicial y un borde fino. Mide 48 dp, el mínimo
/// para tocar que recomienda Android [SC-603].
class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T130,T507,T511 pendiente de LUISDACA");
  }
}

/// Pide la contraseña para eliminar la cuenta. Devuelve null si se cancela.
Future<String?> showDeleteAccountDialog(BuildContext context) {
  throw UnimplementedError("T130,T507,T511 pendiente de LUISDACA");
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() {
    throw UnimplementedError("T130,T507,T511 pendiente de LUISDACA");
  }
}

class _DeleteAccountDialogState extends State<_DeleteAccountDialog> {
  final _password = TextEditingController();

  @override
  void dispose() {
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError("T130,T507,T511 pendiente de LUISDACA");
  }
}
