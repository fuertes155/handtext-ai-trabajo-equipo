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
    return _AuthFlowState();
  }
}

class _AuthFlowState extends State<AuthFlow> {
  late _AuthPage _page = widget.auth.notice == StatusEvent.sessionExpired
      ? _AuthPage.login
      : _AuthPage.welcome;

  void _go(_AuthPage page) {
    if (widget.auth.isBusy) return;
    widget.auth.clearFailure();
    setState(() => _page = page);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _page == _AuthPage.welcome,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _go(_AuthPage.welcome);
      },
      child: AnimatedSwitcher(
        duration: motionDuration(context, const Duration(milliseconds: 220)),
        child: switch (_page) {
          _AuthPage.welcome => WelcomeScreen(
            key: const ValueKey('welcome'),
            auth: widget.auth,
            onCreateAccount: () => _go(_AuthPage.register),
            onSignIn: () => _go(_AuthPage.login),
          ),
          _AuthPage.login => LoginScreen(
            key: const ValueKey('login'),
            auth: widget.auth,
            onBack: () => _go(_AuthPage.welcome),
            onCreateAccount: () => _go(_AuthPage.register),
          ),
          _AuthPage.register => RegisterScreen(
            key: const ValueKey('register'),
            auth: widget.auth,
            onBack: () => _go(_AuthPage.welcome),
            onSignIn: () => _go(_AuthPage.login),
          ),
        },
      ),
    );
  }
}
