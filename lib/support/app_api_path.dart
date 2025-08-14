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
  static const String fingerprintProcess = "/api/v1.0/registrations/fingerprint";
  static const String verifyFace = "/api/v1.0/registrations"; // /40e3eae2-f555-49ab-b8e1-4a2249ffe923/verify-face
  static const String verifyFingeprint = "/api/v1.0/registrations"; // /40e3eae2-f555-49ab-b8e1-4a2249ffe923/verify-fingerprint

  static const String ocrApiKtp = "/api/v1.0/ocr-ktp";
  static const String ocrApiBpkb = "/api/v1.0/ocr-bpkb";
}
