
class ApiLogin {
  String? message;
  Data? data;
  String? token;

  ApiLogin({this.message, this.data, this.token});

  ApiLogin.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["data"] is Map) {
      data = json["data"] == null ? null : Data.fromJson(json["data"]);
    }
    if(json["token"] is String) {
      token = json["token"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    if(data != null) {
      _data["data"] = data?.toJson();
    }
    _data["token"] = token;
    return _data;
  }
}

class Data {
  int? id;
  int? idPetugas;
  String? name;
  String? email;
  dynamic telp;
  dynamic image;
  String? level;

  Data({this.id, this.idPetugas, this.name, this.email, this.telp, this.image, this.level});

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
    telp = json["telp"];
    image = json["image"];
    if(json["level"] is String) {
      level = json["level"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["id_petugas"] = idPetugas;
    _data["name"] = name;
    _data["email"] = email;
    _data["telp"] = telp;
    _data["image"] = image;
    _data["level"] = level;
    return _data;
  }
}