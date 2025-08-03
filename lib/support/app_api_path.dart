class AppApiPath {
  // ACCESS
  static const String login = "/api/v1.0/auth/login";
  static const String getProfile = "/api/v1.0/auth/me";
  // REGISTRATION
  static const String getListRegistration = "/api/v1.0/registrations";
  // static const String getRegistrationById = "/api/v1.0/registrations/44f02b5b-56e4-4055-87a7-eb57943caf12";
  static const String getRegistrationById = "/api/v1.0/registrations";
  static const String ocrProcess = "/api/v1.0/registrations/ocr";
  static const String faceCompareProcess = "/api/v1.0/registrations/face-compare";
  static const String verifyFace = "/api/v1.0/registrations";
}
