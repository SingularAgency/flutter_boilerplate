/// Environment configuration class
class Environment {
  /// API base URL
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.backend.com',
  );

  /// API key
  static const String apiKey = String.fromEnvironment(
    'API_KEY',
    defaultValue: '',
  );

  /// Environment name
  static const String environment = String.fromEnvironment(
    'ENVIRONMENT',
    defaultValue: 'development',
  );

  /// Whether the app is in debug mode
  static const bool isDebug = bool.fromEnvironment(
    'DEBUG',
    defaultValue: true,
  );
} 