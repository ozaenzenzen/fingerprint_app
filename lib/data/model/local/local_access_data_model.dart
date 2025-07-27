class LocalAccessDataModel {
  LocalAccessDataModel({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.token,
  });

  int? userId;
  String? name;
  String? email;
  String? phone;
  String? token;

  factory LocalAccessDataModel.fromJson(Map<String, dynamic> json) => LocalAccessDataModel(
        userId: json["user_id"],
        name: json["name"],
        email: json["email"],
        phone: json["phone"],
        token: json["accessToken"],
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "name": name,
        "email": email,
        "phone": phone,
        "accessToken": token,
      };
}
