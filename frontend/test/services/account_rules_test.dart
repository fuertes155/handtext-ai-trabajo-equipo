import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/models/app_failure.dart';
import 'package:handtext_ai/services/account_rules.dart';

AppFailure? registration({
  String name = 'Persona sintética',
  String email = 'test@example.invalid',
  String password = '12345678',
  String? confirmation,
  bool consent = true,
}) => validateRegistrationForm(
  displayName: name,
  email: email,
  password: password,
  confirmation: confirmation ?? password,
  acceptsDataPolicy: consent,
);

void main() {
  test('registro válido y caracteres Unicode según el backend', () {
    expect(registration(), isNull);
    expect(registration(password: '🙂' * 8), isNull);
    expect(registration(password: 'a' * 128), isNull);
    expect(registration(name: 'a' * 60), isNull);
    expect(registration(password: '   abcde'), isNull);
  });
  test('cada rechazo mantiene su motivo', () {
    expect(registration(name: ' ')?.kind, FailureKind.invalidDisplayName);
    expect(registration(name: 'a' * 61)?.kind, FailureKind.invalidDisplayName);
    expect(registration(email: 'bad')?.kind, FailureKind.invalidEmail);
    expect(registration(password: 'a' * 7)?.kind, FailureKind.weakPassword);
    expect(registration(password: ' ' * 8)?.kind, FailureKind.weakPassword);
    expect(registration(password: 'a' * 129)?.kind, FailureKind.weakPassword);
    expect(
      registration(confirmation: 'different')?.kind,
      FailureKind.passwordMismatch,
    );
    expect(
      registration(consent: false)?.kind,
      FailureKind.dataPolicyNotAccepted,
    );
  });
  test('correo e ingreso distinguen falta de datos y formato inválido', () {
    for (final email in ['a@b.co', '  USER@example.invalid ']) {
      expect(isValidEmail(email), isTrue);
    }
    for (final email in [
      'a',
      '@b.co',
      'a@@b.co',
      'a@b',
      'a b@c.co',
      '${'a' * 250}@b.co',
    ]) {
      expect(isValidEmail(email), isFalse);
    }
    expect(
      validateLoginForm(email: '', password: 'x')?.kind,
      FailureKind.missingCredentials,
    );
    expect(
      validateLoginForm(email: 'a@b.co', password: '')?.kind,
      FailureKind.missingCredentials,
    );
    expect(
      validateLoginForm(email: 'bad', password: 'x')?.kind,
      FailureKind.invalidEmail,
    );
    expect(validateLoginForm(email: 'a@b.co', password: 'short'), isNull);
    expect(passwordStrength('short'), 0);
    expect(passwordStrength('12345678'), 1);
    expect(passwordStrength('123456789012'), 2);
  });
}
