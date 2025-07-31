class OcrProcessResponseModel {
  int? statusCode;
  String? message;
  DataOcrProcess? data;

  OcrProcessResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory OcrProcessResponseModel.fromJson(Map<String, dynamic> json) => OcrProcessResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : DataOcrProcess.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataOcrProcess {
  String? requestId;

  DataOcrProcess({
    this.requestId,
  });

  factory DataOcrProcess.fromJson(Map<String, dynamic> json) => DataOcrProcess(
        requestId: json["requestId"],
      );

  Map<String, dynamic> toJson() => {
        "requestId": requestId,
      };
}
