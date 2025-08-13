class GetRegistrationByIdResponseModel {
  int? statusCode;
  String? message;
  DataGetRegistrationById? data;

  GetRegistrationByIdResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetRegistrationByIdResponseModel.fromJson(Map<String, dynamic> json) => GetRegistrationByIdResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : DataGetRegistrationById.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataGetRegistrationById {
  String? id;
  String? ktpImageUrl;
  String? faceRecognitionImageUrl;
  double? faceRecognitionScore;
  bool? isDoneVerifyNik;
  bool? isDoneFingerprint;
  bool? isDoneFacialRecognition;
  DateTime? registeredAt;
  SurveyorGetRegistrationById? surveyor;
  UserGetRegistrationById? user;
  List<RegistrationTimelineGetRegistrationById>? registrationTimelines;

  DataGetRegistrationById({
    this.id,
    this.ktpImageUrl,
    this.faceRecognitionImageUrl,
    this.faceRecognitionScore,
    this.isDoneVerifyNik,
    this.isDoneFingerprint,
    this.isDoneFacialRecognition,
    this.registeredAt,
    this.surveyor,
    this.user,
    this.registrationTimelines,
  });

  factory DataGetRegistrationById.fromJson(Map<String, dynamic> json) => DataGetRegistrationById(
        id: json["id"],
        ktpImageUrl: json["ktpImageUrl"],
        faceRecognitionImageUrl: json["faceRecognitionImageUrl"],
        faceRecognitionScore: json["faceRecognitionScore"]?.toDouble(),
        isDoneVerifyNik: json["isDoneVerifyNik"],
        isDoneFingerprint: json["isDoneFingerprint"],
        isDoneFacialRecognition: json["isDoneFacialRecognition"],
        registeredAt: json["registeredAt"] == null ? null : DateTime.parse(json["registeredAt"]),
        surveyor: json["surveyor"] == null ? null : SurveyorGetRegistrationById.fromJson(json["surveyor"]),
        user: json["user"] == null ? null : UserGetRegistrationById.fromJson(json["user"]),
        registrationTimelines: json["registrationTimelines"] == null
            ? []
            : List<RegistrationTimelineGetRegistrationById>.from(json["registrationTimelines"]!.map((x) => RegistrationTimelineGetRegistrationById.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "ktpImageUrl": ktpImageUrl,
        "faceRecognitionImageUrl": faceRecognitionImageUrl,
        "faceRecognitionScore": faceRecognitionScore,
        "isDoneVerifyNik": isDoneVerifyNik,
        "isDoneFingerprint": isDoneFingerprint,
        "isDoneFacialRecognition": isDoneFacialRecognition,
        "registeredAt": registeredAt?.toIso8601String(),
        "surveyor": surveyor?.toJson(),
        "user": user?.toJson(),
        "registrationTimelines": registrationTimelines == null ? [] : List<dynamic>.from(registrationTimelines!.map((x) => x.toJson())),
      };
}

class RegistrationTimelineGetRegistrationById {
  String? id;
  String? registrationId;
  String? step;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;

  RegistrationTimelineGetRegistrationById({
    this.id,
    this.registrationId,
    this.step,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory RegistrationTimelineGetRegistrationById.fromJson(Map<String, dynamic> json) => RegistrationTimelineGetRegistrationById(
        id: json["id"],
        registrationId: json["registrationId"],
        step: json["step"],
        status: json["status"],
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registrationId": registrationId,
        "step": step,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}

class SurveyorGetRegistrationById {
  String? fullName;

  SurveyorGetRegistrationById({
    this.fullName,
  });

  factory SurveyorGetRegistrationById.fromJson(Map<String, dynamic> json) => SurveyorGetRegistrationById(
        fullName: json["fullName"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
      };
}

class UserGetRegistrationById {
  String? id;
  String? nik;
  String? fullName;
  String? placeOfBirth;
  DateTime? dateOfBirth;
  String? gender;
  String? bloodType;
  String? address;
  String? rt;
  String? rw;
  String? kelurahan;
  String? kecamatan;
  String? city;
  String? province;
  String? religion;
  String? maritalStatus;
  String? occupation;
  String? nationality;
  String? validUntil;
  DateTime? createdAt;
  DateTime? updatedAt;

  UserGetRegistrationById({
    this.id,
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
    this.createdAt,
    this.updatedAt,
  });

  factory UserGetRegistrationById.fromJson(Map<String, dynamic> json) => UserGetRegistrationById(
        id: json["id"],
        nik: json["nik"],
        fullName: json["fullName"],
        placeOfBirth: json["placeOfBirth"],
        dateOfBirth: json["dateOfBirth"] == null ? null : DateTime.parse(json["dateOfBirth"]),
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
        createdAt: json["createdAt"] == null ? null : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null ? null : DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };
}
