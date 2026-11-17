import 'package:flutter_test/flutter_test.dart';
import 'package:handtext_ai/config/app_config.dart';

void main() {
  test('URL explícita y límites del contrato del backend', () {
    const supplied = String.fromEnvironment('API_BASE_URL');
    if (!AppConfig.usesLocalAccounts &&
        (supplied.isEmpty || !supplied.startsWith('https://'))) {
      expect(() => AppConfig.apiBaseUrl, throwsStateError);
    } else {
      final expected = supplied.isEmpty ? 'http://10.0.2.2:8001/' : supplied;
      expect(
        AppConfig.apiBaseUrl.toString(),
        expected.endsWith('/') ? expected : '$expected/',
      );
    }
    expect(AppConfig.maxImageBytes, 10 * 1024 * 1024);
    expect(AppConfig.minImageSidePx, 600);
    expect(AppConfig.maxImageSidePx, 10000);
    expect(AppConfig.recognitionTimeout, const Duration(seconds: 60));
    expect(AppConfig.apiConnectionTimeout, const Duration(seconds: 5));
    if (!AppConfig.usesLocalAccounts) {
      expect(AppConfig.localDevApiToken, isEmpty);
    }
  });
}
