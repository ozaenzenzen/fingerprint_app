class VerifyFingerprintResponseModel {
  int? statusCode;
  String? message;
  DataVerifyFingerprint? data;

  VerifyFingerprintResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory VerifyFingerprintResponseModel.fromJson(Map<String, dynamic> json) => VerifyFingerprintResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : DataVerifyFingerprint.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataVerifyFingerprint {
  bool? isValid;

  DataVerifyFingerprint({
    this.isValid,
  });

  factory DataVerifyFingerprint.fromJson(Map<String, dynamic> json) => DataVerifyFingerprint(
        isValid: json["isValid"],
      );

  Map<String, dynamic> toJson() => {
        "isValid": isValid,
      };
}
