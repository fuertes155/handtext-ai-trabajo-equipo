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
import 'password_field.dart';

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
    if (auth.isBusy || documents.isBusy) return;
    final strings = context.strings;
    if (documents.hasUnexportedChanges &&
        !await showConfirmDialog(
          context,
          title: strings.signOutTitle,
          message: strings.signOutUnexportedMessage,
          confirmLabel: strings.signOut,
          destructive: true,
        )) {
      return;
    }
    await auth.signOut(beforeSignOut: documents.clearLocalData);
    final failure = auth.failure;
    if (failure != null && context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(strings.failureText(failure))));
    }
  }

  Future<void> _deleteAccount(BuildContext context) async {
    if (auth.isBusy || documents.isBusy) return;
    final password = await showDeleteAccountDialog(context);
    if (password == null) return;
    final ok = await auth.deleteAccount(
      password,
      beforeSignOut: () => documents.clearLocalData(deleteHistory: true),
    );
    if (!ok && context.mounted) {
      final failure = auth.failure ?? const AppFailure(FailureKind.unexpected);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(context.strings.failureText(failure))),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final strings = context.strings;
    return PopupMenuButton<_AccountAction>(
      tooltip: strings.accountTooltip,
      enabled: !auth.isBusy && !documents.isBusy,
      padding: EdgeInsets.zero,
      onSelected: (action) {
        switch (action) {
          case _AccountAction.settings:
            unawaited(
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SettingsScreen()),
              ),
            );
          case _AccountAction.about:
            unawaited(
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const AboutScreen()),
              ),
            );
          case _AccountAction.signOut:
            unawaited(_signOut(context));
          case _AccountAction.deleteAccount:
            unawaited(_deleteAccount(context));
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(
          value: _AccountAction.settings,
          child: Text(strings.settingsTitle),
        ),
        PopupMenuItem(
          value: _AccountAction.about,
          child: Text(strings.aboutTitle),
        ),
        const PopupMenuDivider(),
        PopupMenuItem(
          value: _AccountAction.signOut,
          child: Text(strings.signOut),
        ),
        PopupMenuItem(
          value: _AccountAction.deleteAccount,
          child: Text(strings.deleteAccount),
        ),
      ],
      child: Semantics(
        button: true,
        child: _Avatar(initial: auth.user?.initial ?? '?'),
      ),
    );
  }
}

/// Círculo azul corporativo con la inicial y un borde fino. Mide 48 dp, el mínimo
/// para tocar que recomienda Android [SC-603].
class _Avatar extends StatelessWidget {
  const _Avatar({required this.initial});

  final String initial;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: 48,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Aurora.blue,
            border: Border.all(color: Aurora.blueLight),
          ),
          child: Center(
            child: Text(
              initial,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Pide la contraseña para eliminar la cuenta. Devuelve null si se cancela.
Future<String?> showDeleteAccountDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (_) => const _DeleteAccountDialog(),
  );
}

class _DeleteAccountDialog extends StatefulWidget {
  const _DeleteAccountDialog();

  @override
  State<_DeleteAccountDialog> createState() {
    return _DeleteAccountDialogState();
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
    final strings = context.strings;
    return AlertDialog(
      scrollable: true,
      title: Text(strings.deleteAccountTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(strings.deleteAccountMessage),
          const SizedBox(height: 20),
          PasswordField(
            controller: _password,
            label: strings.passwordLabel,
            textInputAction: TextInputAction.done,
            onSubmitted: (password) {
              if (password.isNotEmpty) Navigator.of(context).pop(password);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(strings.cancel),
        ),
        ValueListenableBuilder<TextEditingValue>(
          valueListenable: _password,
          builder: (context, value, _) => FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: value.text.isEmpty
                ? null
                : () => Navigator.of(context).pop(value.text),
            child: Text(strings.deleteAccountConfirm),
          ),
        ),
      ],
    );
  }
}
