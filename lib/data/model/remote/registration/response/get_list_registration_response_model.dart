class GetListRegistrationResponseModel {
  int? statusCode;
  String? message;
  DataGetListRegistration? data;

  GetListRegistrationResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetListRegistrationResponseModel.fromJson(Map<String, dynamic> json) => GetListRegistrationResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : DataGetListRegistration.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class DataGetListRegistration {
  PaginationGetListRegistration? pagination;
  List<ItemGetListRegistration>? items;

  DataGetListRegistration({
    this.pagination,
    this.items,
  });

  factory DataGetListRegistration.fromJson(Map<String, dynamic> json) => DataGetListRegistration(
        pagination: json["pagination"] == null ? null : PaginationGetListRegistration.fromJson(json["pagination"]),
        items: json["items"] == null ? [] : List<ItemGetListRegistration>.from(json["items"]!.map((x) => ItemGetListRegistration.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x.toJson())),
      };
}

class ItemGetListRegistration {
  String? id;
  DateTime? registeredAt;
  SurveyorGetListRegistration? surveyor;
  UserGetListRegistration? user;
  LatestRegistrationTimelineGetListRegistration? latestRegistrationTimeline;

  ItemGetListRegistration({
    this.id,
    this.registeredAt,
    this.surveyor,
    this.user,
    this.latestRegistrationTimeline,
  });

  factory ItemGetListRegistration.fromJson(Map<String, dynamic> json) => ItemGetListRegistration(
        id: json["id"],
        registeredAt: json["registeredAt"] == null ? null : DateTime.parse(json["registeredAt"]),
        surveyor: json["surveyor"] == null ? null : SurveyorGetListRegistration.fromJson(json["surveyor"]),
        user: json["user"] == null ? null : UserGetListRegistration.fromJson(json["user"]),
        latestRegistrationTimeline: json["latestRegistrationTimeline"] == null ? null : LatestRegistrationTimelineGetListRegistration.fromJson(json["latestRegistrationTimeline"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "registeredAt": registeredAt?.toIso8601String(),
        "surveyor": surveyor?.toJson(),
        "user": user?.toJson(),
        "latestRegistrationTimeline": latestRegistrationTimeline?.toJson(),
      };
}

class LatestRegistrationTimelineGetListRegistration {
  String? step;
  String? status;

  LatestRegistrationTimelineGetListRegistration({
    this.step,
    this.status,
  });

  factory LatestRegistrationTimelineGetListRegistration.fromJson(Map<String, dynamic> json) => LatestRegistrationTimelineGetListRegistration(
        step: json["step"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "step": step,
        "status": status,
      };
}

class SurveyorGetListRegistration {
  String? fullName;

  SurveyorGetListRegistration({
    this.fullName,
  });

  factory SurveyorGetListRegistration.fromJson(Map<String, dynamic> json) => SurveyorGetListRegistration(
        fullName: json["fullName"],
      );

  Map<String, dynamic> toJson() => {
        "fullName": fullName,
      };
}

class UserGetListRegistration {
  String? nik;
  String? fullName;

  UserGetListRegistration({
    this.nik,
    this.fullName,
  });

  factory UserGetListRegistration.fromJson(Map<String, dynamic> json) => UserGetListRegistration(
        nik: json["nik"],
        fullName: json["fullName"],
      );

  Map<String, dynamic> toJson() => {
        "nik": nik,
        "fullName": fullName,
      };
}

class PaginationGetListRegistration {
  int? page;
  dynamic next;
  dynamic prev;
  bool? hasMore;

  PaginationGetListRegistration({
    this.page,
    this.next,
    this.prev,
    this.hasMore,
  });

  factory PaginationGetListRegistration.fromJson(Map<String, dynamic> json) => PaginationGetListRegistration(
        page: json["page"],
        next: json["next"],
        prev: json["prev"],
        hasMore: json["hasMore"],
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "next": next,
        "prev": prev,
        "hasMore": hasMore,
      };
}
