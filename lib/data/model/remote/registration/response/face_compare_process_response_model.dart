class FaceCompareProcessResponseModel {
  int? statusCode;
  String? message;
  DataFaceCompareProcess? data;

  FaceCompareProcessResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory FaceCompareProcessResponseModel.fromJson(Map<String, dynamic> json) => FaceCompareProcessResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : DataFaceCompareProcess.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataFaceCompareProcess {
  bool? isValid;
  String? requestId;

  DataFaceCompareProcess({
    this.isValid,
    this.requestId,
  });

  factory DataFaceCompareProcess.fromJson(Map<String, dynamic> json) => DataFaceCompareProcess(
        isValid: json["isValid"],
        requestId: json["requestId"],
      );

  Map<String, dynamic> toJson() => {
        "isValid": isValid,
        "requestId": requestId,
      };
}
