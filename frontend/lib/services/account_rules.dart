// Reglas de los formularios de cuenta (tarea T124; spec 002, módulo 1; CU-H1-E4).
//
// Son las mismas que aplica el backend (backend/app/services/accounts/rules.py). La app
// las comprueba ANTES de enviar, para orientar al usuario sin esperar al servidor; el
// servidor las vuelve a aplicar (constitución §5, Validación).

import '../models/app_failure.dart';

final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

const passwordMinChars = 8;
const passwordMaxChars = 128;
const displayNameMaxChars = 60;

/// Correo con forma válida (algo@dominio.ext, máximo 254 caracteres).
bool isValidEmail(String email) {
  final normalized = email.trim();
  return normalized.runes.length <= 254 && _emailPattern.hasMatch(normalized);
}

/// Revisa el formulario de registro; devuelve el primer problema o null si está bien.
AppFailure? validateRegistrationForm({
  required String displayName,
  required String email,
  required String password,
  required String confirmation,
  required bool acceptsDataPolicy,
}) {
  final name = displayName.trim().split(RegExp(r'\s+')).join(' ');
  if (name.isEmpty || name.runes.length > displayNameMaxChars) {
    return const AppFailure(FailureKind.invalidDisplayName);
  }
  if (!isValidEmail(email)) return const AppFailure(FailureKind.invalidEmail);
  if (password.runes.length < passwordMinChars ||
      password.runes.length > passwordMaxChars ||
      password.trim().isEmpty) {
    return const AppFailure(FailureKind.weakPassword);
  }
  if (password != confirmation) {
    return const AppFailure(FailureKind.passwordMismatch);
  }
  if (!acceptsDataPolicy) {
    return const AppFailure(FailureKind.dataPolicyNotAccepted);
  }
  return null;
}

/// Revisa el formulario de ingreso: ambos campos son obligatorios.
AppFailure? validateLoginForm({
  required String email,
  required String password,
}) {
  if (email.trim().isEmpty || password.isEmpty) {
    return const AppFailure(FailureKind.missingCredentials);
  }
  if (!isValidEmail(email)) return const AppFailure(FailureKind.invalidEmail);
  return null;
}

/// Nivel de seguridad de la contraseña (solo es una guía visual): 0 débil, 1
/// aceptable, 2 fuerte. La regla obligatoria es la longitud mínima de 8.
int passwordStrength(String password) {
  if (password.runes.length < passwordMinChars || password.trim().isEmpty) {
    return 0;
  }
  return password.runes.length >= 12 ? 2 : 1;
}
