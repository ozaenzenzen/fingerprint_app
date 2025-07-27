enum Flavor { development, staging, production }

class EnvironmentConfig {
  static Flavor flavor = Flavor.staging;

  static String _baseUrl = "";

  static String get customBaseUrl {
    if (_baseUrl.isEmpty || _baseUrl == "") {
      switch (flavor) {
        case Flavor.development:
          return 'https://finger-app.wahidfeb.my.id';
        case Flavor.staging:
          return 'https://finger-app.wahidfeb.my.id';
        default:
          return 'https://finger-app.wahidfeb.my.id';
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
