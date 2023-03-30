
class ApiGetUser {
  String? message;
  List<Data>? data;
  int? count;

  ApiGetUser({this.message, this.data,this.count});

  ApiGetUser.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is List) {
      data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }
    if(json["count"] is int) {
      count = json["count"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    _data["count"] = count;
    return _data;
  }
}

class Data {
  int? id;
  int? idPetugas;
  String? name;
  String? email;
  dynamic emailVerifiedAt;
  dynamic telp;
  dynamic image;
  String? level;
  dynamic createdAt;
  dynamic updatedAt;

  Data({this.id, this.idPetugas, this.name, this.email, this.emailVerifiedAt, this.telp, this.image, this.level, this.createdAt, this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is int) {
      id = json["id"];
    }
    if(json["id_petugas"] is int) {
      idPetugas = json["id_petugas"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
    emailVerifiedAt = json["email_verified_at"];
    telp = json["telp"];
    image = json["image"];
    if(json["level"] is String) {
      level = json["level"];
    }
    createdAt = json["created_at"];
    updatedAt = json["updated_at"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["id_petugas"] = idPetugas;
    _data["name"] = name;
    _data["email"] = email;
    _data["email_verified_at"] = emailVerifiedAt;
    _data["telp"] = telp;
    _data["image"] = image;
    _data["level"] = level;
    _data["created_at"] = createdAt;
    _data["updated_at"] = updatedAt;
    return _data;
  }
}