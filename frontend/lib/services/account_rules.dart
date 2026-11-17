// Reinicio 2026-11-17: las regiones marcadas están pendientes de LUISDACA.
// Los comentarios anteriores describen requisitos; no son verificación del código actual.
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
  throw UnimplementedError("T124 pendiente de LUISDACA");
}

/// Revisa el formulario de registro; devuelve el primer problema o null si está bien.
AppFailure? validateRegistrationForm({
  required String displayName,
  required String email,
  required String password,
  required String confirmation,
  required bool acceptsDataPolicy,
}) {
  throw UnimplementedError("T124 pendiente de LUISDACA");
}

/// Revisa el formulario de ingreso: ambos campos son obligatorios.
AppFailure? validateLoginForm({
  required String email,
  required String password,
}) {
  throw UnimplementedError("T124 pendiente de LUISDACA");
}

/// Nivel de seguridad de la contraseña (solo es una guía visual): 0 débil, 1
/// aceptable, 2 fuerte. La regla obligatoria es la longitud mínima de 8.
int passwordStrength(String password) {
  throw UnimplementedError("T124 pendiente de LUISDACA");
}
