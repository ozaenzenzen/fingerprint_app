enum Flavor { development, staging, production }

class EnvironmentConfig {
  static Flavor flavor = Flavor.staging;

  static String _baseUrl = "";

  static String get customBaseUrl {
    if (_baseUrl.isEmpty || _baseUrl == "") {
      switch (flavor) {
        case Flavor.development:
          return 'http://localhost:8080';
        case Flavor.staging:
          return 'http://localhost:8080';
        default:
          return 'http://localhost:8080';
      }
    }
    return _baseUrl;
  }

  static set customBaseUrl(String val) {
    _baseUrl = val;
  }

  static String baseUrl() {
    return customBaseUrl;
  }
}
