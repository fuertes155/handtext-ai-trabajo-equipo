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
    return _LoginScreenState();
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
    if (widget.auth.isBusy) return;
    final failure = validateLoginForm(
      email: _email.text,
      password: _password.text,
    );
    setState(() => _formFailure = failure);
    if (failure != null) return;
    FocusScope.of(context).unfocus();
    await widget.auth.signIn(email: _email.text, password: _password.text);
  }

  @override
  Widget build(BuildContext context) {
    return AuroraScaffold(
      body: ListenableBuilder(
        listenable: widget.auth,
        builder: (context, _) {
          final strings = context.strings;
          final failure = _formFailure ?? widget.auth.failure;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          tooltip: strings.back,
                          onPressed: widget.auth.isBusy ? null : widget.onBack,
                          icon: const Icon(Icons.arrow_back),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Semantics(
                            header: true,
                            child: Text(
                              strings.loginTitle,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      strings.loginSubtitle,
                      style: const TextStyle(color: Aurora.textSecondary),
                    ),
                    const SizedBox(height: 24),
                    if (widget.auth.notice == StatusEvent.sessionExpired) ...[
                      StatusBanner(
                        status: const OperationStatus.info(
                          StatusEvent.sessionExpired,
                        ),
                        onAurora: true,
                      ),
                      const SizedBox(height: 16),
                    ],
                    if (failure != null) ...[
                      StatusBanner(
                        status: OperationStatus.failure(failure),
                        onAurora: true,
                      ),
                      const SizedBox(height: 16),
                    ],
                    SurfaceCard(
                      child: AutofillGroup(
                        child: AbsorbPointer(
                          absorbing: widget.auth.isBusy,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              TextField(
                                controller: _email,
                                keyboardType: TextInputType.emailAddress,
                                autofillHints: const [AutofillHints.email],
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: strings.emailLabel,
                                  prefixIcon: const Icon(Icons.email_outlined),
                                ),
                              ),
                              const SizedBox(height: 20),
                              PasswordField(
                                controller: _password,
                                label: strings.passwordLabel,
                                autofillHints: const [AutofillHints.password],
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _submit(),
                              ),
                              const SizedBox(height: 24),
                              PrimaryButton(
                                label: strings.signIn,
                                onPressed: widget.auth.isBusy ? null : _submit,
                                isLoading: widget.auth.isBusy,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      strings.noAccountQuestion,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: widget.auth.isBusy
                          ? null
                          : widget.onCreateAccount,
                      child: Text(strings.createAccountLink),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
