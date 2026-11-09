abstract final class AppConfig {
  static const appVersion = String.fromEnvironment(
    'APP_VERSION',
    defaultValue: '1.0.0',
  );
  static const appBuild = String.fromEnvironment(
    'APP_BUILD',
    defaultValue: '1',
  );
}
