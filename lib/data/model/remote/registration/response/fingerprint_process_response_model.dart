class FingerprintProcessResponseModel {
  int? statusCode;
  String? message;

  FingerprintProcessResponseModel({
    this.statusCode,
    this.message,
  });

  factory FingerprintProcessResponseModel.fromJson(Map<String, dynamic> json) => FingerprintProcessResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
      };
}
