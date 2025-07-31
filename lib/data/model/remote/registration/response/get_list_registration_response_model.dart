class GetListRegistrationResponseModel {
  int? statusCode;
  String? message;
  GetListRegistration? data;

  GetListRegistrationResponseModel({
    this.statusCode,
    this.message,
    this.data,
  });

  factory GetListRegistrationResponseModel.fromJson(Map<String, dynamic> json) => GetListRegistrationResponseModel(
        statusCode: json["statusCode"],
        message: json["message"],
        data: json["data"] == null ? null : GetListRegistration.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "statusCode": statusCode,
        "message": message,
        "data": data?.toJson(),
      };
}

class GetListRegistration {
  Pagination? pagination;
  List<dynamic>? items;

  GetListRegistration({
    this.pagination,
    this.items,
  });

  factory GetListRegistration.fromJson(Map<String, dynamic> json) => GetListRegistration(
        pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
        items: json["items"] == null ? [] : List<dynamic>.from(json["items"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "pagination": pagination?.toJson(),
        "items": items == null ? [] : List<dynamic>.from(items!.map((x) => x)),
      };
}

class Pagination {
  int? page;
  dynamic next;
  dynamic prev;
  bool? hasMore;

  Pagination({
    this.page,
    this.next,
    this.prev,
    this.hasMore,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
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
