class VerifyFaceResponseModel {
  int? statusCode;
  String? message;
  DataVerifyFace? data;

  VerifyFaceResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory VerifyFaceResponseModel.fromJson(Map<String, dynamic> json) => VerifyFaceResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : DataVerifyFace.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataVerifyFace {
  bool? isValid;

  DataVerifyFace({
    this.isValid,
  });

  factory DataVerifyFace.fromJson(Map<String, dynamic> json) => DataVerifyFace(
        isValid: json["isValid"],
      );

  Map<String, dynamic> toJson() => {
        "isValid": isValid,
      };
}
