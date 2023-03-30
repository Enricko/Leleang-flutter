
class ApiLelang {
  int? count;
  String? message;
  String? imageBarangPath;
  String? status;
  List<Data>? data;
  int? page;

  ApiLelang({this.count, this.message, this.imageBarangPath, this.status, this.data, this.page});

  ApiLelang.fromJson(Map<String, dynamic> json) {
    if(json["count"] is int) {
      count = json["count"];
    }
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["image_barang_path"] is String) {
      imageBarangPath = json["image_barang_path"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["data"] is List) {
      data = json["data"] == null ? null : (json["data"] as List).map((e) => Data.fromJson(e)).toList();
    }
    if(json["page"] is int) {
      page = json["page"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["count"] = count;
    _data["message"] = message;
    _data["image_barang_path"] = imageBarangPath;
    _data["status"] = status;
    if(data != null) {
      _data["data"] = data?.map((e) => e.toJson()).toList();
    }
    _data["page"] = page;
    return _data;
  }
}

class Data {
  String? idLelang;
  String? idPetugas;
  String? tglDibuka;
  String? tglDitutup;
  String? status;
  Barang? barang;
  User? user;

  Data({this.idLelang, this.idPetugas, this.tglDibuka, this.tglDitutup, this.status, this.barang, this.user});

  Data.fromJson(Map<String, dynamic> json) {
    if(json["id_lelang"] is String) {
      idLelang = json["id_lelang"];
    }
    if(json["id_petugas"] is String) {
      idPetugas = json["id_petugas"];
    }
    if(json["tgl_dibuka"] is String) {
      tglDibuka = json["tgl_dibuka"];
    }
    if(json["tgl_ditutup"] is String) {
      tglDitutup = json["tgl_ditutup"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
    if(json["barang"] is Map) {
      barang = json["barang"] == null ? null : Barang.fromJson(json["barang"]);
    }
    if(json["user"] is Map) {
      user = json["user"] == null ? null : User.fromJson(json["user"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id_lelang"] = idLelang;
    _data["id_petugas"] = idPetugas;
    _data["tgl_dibuka"] = tglDibuka;
    _data["tgl_ditutup"] = tglDitutup;
    _data["status"] = status;
    if(barang != null) {
      _data["barang"] = barang?.toJson();
    }
    if(user != null) {
      _data["user"] = user?.toJson();
    }
    return _data;
  }
}

class User {
  String? id;
  String? name;
  dynamic image;
  String? penawaran;

  User({this.id, this.name, this.image, this.penawaran});

  User.fromJson(Map<String, dynamic> json) {
    if(json["id"] is String) {
      id = json["id"];
    }
    if(json["name"] is String) {
      name = json["name"];
    }
    image = json["image"];
    if(json["penawaran"] is String) {
      penawaran = json["penawaran"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id"] = id;
    _data["name"] = name;
    _data["image"] = image;
    _data["penawaran"] = penawaran;
    return _data;
  }
}

class Barang {
  String? idBarang;
  String? namaBarang;
  String? deskripsi;
  String? imageBarang;
  String? hargaAwal;
  String? hargaAkhir;

  Barang({this.idBarang, this.namaBarang, this.deskripsi, this.imageBarang, this.hargaAwal, this.hargaAkhir});

  Barang.fromJson(Map<String, dynamic> json) {
    if(json["id_barang"] is String) {
      idBarang = json["id_barang"];
    }
    if(json["nama_barang"] is String) {
      namaBarang = json["nama_barang"];
    }
    if(json["deskripsi"] is String) {
      deskripsi = json["deskripsi"];
    }
    if(json["image_barang"] is String) {
      imageBarang = json["image_barang"];
    }
    if(json["harga_awal"] is String) {
      hargaAwal = json["harga_awal"];
    }
    if(json["harga_akhir"] is String) {
      hargaAkhir = json["harga_akhir"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["id_barang"] = idBarang;
    _data["nama_barang"] = namaBarang;
    _data["deskripsi"] = deskripsi;
    _data["image_barang"] = imageBarang;
    _data["harga_awal"] = hargaAwal;
    _data["harga_akhir"] = hargaAkhir;
    return _data;
  }
}