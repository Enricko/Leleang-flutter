
class ApiHistoryLelang {
  String? message;
  String? idLelang;
  List<Data>? data;

  ApiHistoryLelang({this.message, this.idLelang, this.data});

  ApiHistoryLelang.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["id_lelang"] is String) {
      idLelang = json["id_lelang"];
    }
    if(json["data"] is List) {
      data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["id_lelang"] = idLelang;
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    return _data;
  }
}

class Data {
  String? id;
  String? idLelang;
  String? penawaranHarga;
  User? user;

  Data({this.id, this.idLelang, this.penawaranHarga, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["id_lelang"] is String) {
      idLelang = json["id_lelang"];
    }
    if(json["penawaran_harga"] is String) {
      penawaranHarga = json["penawaran_harga"];
    }
    if(json["user"] is Map) {
      user = json["user"] == null ? null : User.fromJson(json["user"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["id_lelang"] = idLelang;
    _data["penawaran_harga"] = penawaranHarga;
    if(user != null) {
      _data["user"] = user?.toJson();
    }
    return _data;
  }
}

class User {
  String? name;
  dynamic image;
  String? telp;
  String? email;

  User({this.name, this.image, this.telp, this.email});

  User.fromJson(Map<String, dynamic> json) {
    if(json["name"] is String) {
      name = json["name"];
    }
    image = json["image"];
    if(json["telp"] is String) {
      telp = json["telp"];
    }
    if(json["email"] is String) {
      email = json["email"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["name"] = name;
    _data["image"] = image;
    _data["telp"] = telp;
    _data["email"] = email;
    return _data;
  }
}