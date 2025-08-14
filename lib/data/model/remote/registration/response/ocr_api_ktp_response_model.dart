import 'package:saas_mlkit/saas_mlkit.dart';

class OcrApiKtpResponseModel {
  int? statusCode;
  String? message;
  DataOcrApiKtp? data;

  OcrApiKtpResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  KTPData toKtpData() {
    return KTPData(
      nik: data?.nik,
      name: data?.fullName,
      birthPlace: data?.placeOfBirth,
      birthDate: data?.dateOfBirth?.toIso8601String(),
      gender: data?.gender,
      bloodType: data?.bloodType,
      address: data?.address,
      rt: data?.rt,
      rw: data?.rw,
      subDistrict: data?.kelurahan,
      district: data?.kecamatan,
      city: data?.city,
      province: data?.province,
      religion: data?.religion,
      maritalStatus: data?.maritalStatus,
      profession: data?.occupation,
      nationality: data?.nationality,
      expired: data?.validUntil,
    );
  }

  factory OcrApiKtpResponseModel.fromJson(Map<String, dynamic> json) => OcrApiKtpResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : DataOcrApiKtp.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataOcrApiKtp {
  String? nik;
  String? fullName;
  String? placeOfBirth;
  DateTime? dateOfBirth;
  String? gender;
  dynamic bloodType;
  String? address;
  String? rt;
  String? rw;
  String? kelurahan;
  String? kecamatan;
  dynamic city;
  dynamic province;
  String? religion;
  String? maritalStatus;
  String? occupation;
  String? nationality;
  String? validUntil;

  DataOcrApiKtp({
    this.nik,
    this.fullName,
    this.placeOfBirth,
    this.dateOfBirth,
    this.gender,
    this.bloodType,
    this.address,
    this.rt,
    this.rw,
    this.kelurahan,
    this.kecamatan,
    this.city,
    this.province,
    this.religion,
    this.maritalStatus,
    this.occupation,
    this.nationality,
    this.validUntil,
  });

  factory DataOcrApiKtp.fromJson(Map<String, dynamic> json) => DataOcrApiKtp(
        nik: json["nik"],
        fullName: json["fullName"],
        placeOfBirth: json["placeOfBirth"],
        dateOfBirth: (json["dateOfBirth"] == null) ? null : DateTime.parse(json["dateOfBirth"]),
        gender: json["gender"],
        bloodType: json["bloodType"],
        address: json["address"],
        rt: json["rt"],
        rw: json["rw"],
        kelurahan: json["kelurahan"],
        kecamatan: json["kecamatan"],
        city: json["city"],
        province: json["province"],
        religion: json["religion"],
        maritalStatus: json["maritalStatus"],
        occupation: json["occupation"],
        nationality: json["nationality"],
        validUntil: json["validUntil"],
      );

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "fullName": fullName,
        "placeOfBirth": placeOfBirth,
        "dateOfBirth": dateOfBirth?.toIso8601String(),
        "gender": gender,
        "bloodType": bloodType,
        "address": address,
        "rt": rt,
        "rw": rw,
        "kelurahan": kelurahan,
        "kecamatan": kecamatan,
        "city": city,
        "province": province,
        "religion": religion,
        "maritalStatus": maritalStatus,
        "occupation": occupation,
        "nationality": nationality,
        "validUntil": validUntil,
      };
}
