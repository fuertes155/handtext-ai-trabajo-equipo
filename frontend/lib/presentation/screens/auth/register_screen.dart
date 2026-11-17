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
    return _RegisterScreenState();
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
    if (widget.auth.isBusy) return;
    final failure = validateRegistrationForm(
      displayName: _name.text,
      email: _email.text,
      password: _password.text,
      confirmation: _confirmation.text,
      acceptsDataPolicy: _acceptsDataPolicy,
    );
    setState(() => _formFailure = failure);
    if (failure != null) return;
    FocusScope.of(context).unfocus();
    await widget.auth.register(
      displayName: _name.text,
      email: _email.text,
      password: _password.text,
      acceptsDataPolicy: _acceptsDataPolicy,
    );
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
                              strings.registerTitle,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      strings.registerSubtitle,
                      style: const TextStyle(color: Aurora.textSecondary),
                    ),
                    const SizedBox(height: 24),
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
                                controller: _name,
                                textCapitalization: TextCapitalization.words,
                                autofillHints: const [AutofillHints.name],
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  labelText: strings.nameLabel,
                                  prefixIcon: const Icon(Icons.person_outline),
                                ),
                              ),
                              const SizedBox(height: 20),
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
                                showStrength: true,
                                autofillHints: const [
                                  AutofillHints.newPassword,
                                ],
                                textInputAction: TextInputAction.next,
                              ),
                              const SizedBox(height: 20),
                              PasswordField(
                                controller: _confirmation,
                                label: strings.confirmPasswordLabel,
                                autofillHints: const [
                                  AutofillHints.newPassword,
                                ],
                                textInputAction: TextInputAction.done,
                                onSubmitted: (_) => _submit(),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                strings.passwordHint,
                                style: const TextStyle(color: Aurora.textMuted),
                              ),
                              const SizedBox(height: 12),
                              CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                value: _acceptsDataPolicy,
                                onChanged: (value) => setState(
                                  () => _acceptsDataPolicy = value ?? false,
                                ),
                                title: Text(strings.dataPolicyConsent),
                              ),
                              const SizedBox(height: 20),
                              PrimaryButton(
                                label: strings.createAccount,
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
                      strings.haveAccountQuestion,
                      textAlign: TextAlign.center,
                    ),
                    TextButton(
                      onPressed: widget.auth.isBusy ? null : widget.onSignIn,
                      child: Text(strings.signIn),
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
