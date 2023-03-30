
class ApiInsertLelang {
  String? message;
  String? status;

  ApiInsertLelang({this.message, this.status});

  ApiInsertLelang.fromJson(Map<String, dynamic> json) {
    if(json["message"] is String) {
      message = json["message"];
    }
    if(json["status"] is String) {
      status = json["status"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    _data["message"] = message;
    _data["status"] = status;
    return _data;
  }
}