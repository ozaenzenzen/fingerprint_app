class GetProfileResponseModel {
  int? statusCode;
  String? message;
  DataGetProfile? data;

  GetProfileResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) => GetProfileResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : DataGetProfile.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataGetProfile {
  String? id;
  String? fullName;
  String? email;
  bool? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;

  DataGetProfile({
    this.id,
    this.fullName,
    this.email,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory DataGetProfile.fromJson(Map<String, dynamic> json) => DataGetProfile(
        id: json["id"],
        fullName: json["fullName"],
        email: json["email"],
        isActive: json["isActive"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fullName": fullName,
        "email": email,
        "isActive": isActive,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
