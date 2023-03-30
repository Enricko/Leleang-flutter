import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiGetUser.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiHistoryLelang.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiInsertLelang.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http_parser/http_parser.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiLelang.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiRegister.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiTawarLelang.dart';

import 'ApiLogin.dart';

const BaseUrl = "http://127.0.0.1:8000/api/";
class Api{
  static Future<ApiLogin> login(Map<String,String>data) async{
    var url = '${BaseUrl}loginuser';

    var response = await http.post(Uri.parse(url),headers: {'Accept': 'application/json'},body: data);
    if(response.statusCode == 200){
      return ApiLogin.fromJson(jsonDecode(response.body));
    }
    throw "Gagal Mengambil Data";
  }
  static Future<ApiInsertLelang> insertLelang(Map data, String? baseImage, Uint8List? webImage,String token) async{
    var url = Uri.parse('${BaseUrl}insert_lelang');
    // if(!kIsWeb){
    //   var response = await http.post(url,headers: {'Accept': 'application/json'},
    //   body: {
    //     'image_barang':baseImage,
    //     'nama_barang': data['nama_barang'],
    //     'harga_awal': data['harga_awal'],
    //     'deskripsi_barang': data['deskripsi_barang'],
    //     'lama_lelang': data['lama_lelang'],
    //   }); 
    //   return ApiInsertLelang.fromJson(jsonDecode(response.body));
    // }else if(kIsWeb){
      var request = http.MultipartRequest("POST",url);
      request.files.add(http.MultipartFile.fromBytes('image_barang', webImage!,contentType: MediaType('application', 'octet-stream'),filename: 'image.png'));
      request.headers.addAll({'Content-Type': 'multipart/form-data','Accept':'application/json','Authorization':"Bearer $token"});
      request.fields['nama_barang'] = data['nama_barang'];
      request.fields['harga_awal'] = data['harga_awal'];
      request.fields['deskripsi_barang'] = data['deskripsi_barang'];
      request.fields['lama_lelang'] = data['lama_lelang'];

      var response = await request.send();
      var responsed = await http.Response.fromStream(response);
      final responseData = json.decode(responsed.body);
      return ApiInsertLelang.fromJson(responseData);
    // }
    throw "Gagal Mengambil Data";
  } 
  static Future<ApiLelang> userLelang(String id,String token,String filter) async{
    var url = Uri.parse('${BaseUrl}lelang?user_id=$id&${filter}');
    var response = await http.get(url,headers: {'Authorization': "Bearer $token"});

    return ApiLelang.fromJson(jsonDecode(response.body));
    // throw "Gagal mengambil data";
  }
  static Future<ApiLelang> LelangTable(String token,String filter) async{
    var url = Uri.parse('${BaseUrl}lelang?${filter}');
    print(url);
    var response = await http.get(url,headers: {'Accept': "application/json",'Authorization': "Bearer $token"});

    return ApiLelang.fromJson(jsonDecode(response.body));
    // throw "Gagal mengambil data";
  }
  static Future<ApiLelang> topLelang() async{
    var url = Uri.parse('${BaseUrl}lelang_page?status=dibuka&top=true&ditawar=true');
    var response = await http.get(url,headers: {'Accept': "application/json"});

    return ApiLelang.fromJson(jsonDecode(response.body));
    // throw "Gagal mengambil data";
  }
  static Future<ApiLelang> newLelang(String pages) async{
    var url = Uri.parse("${BaseUrl}lelang_page?status=dibuka&time=new&page=$pages");
    var response = await http.get(url,headers: {'Accept': "application/json"});

    return ApiLelang.fromJson(jsonDecode(response.body));
    // throw "Gagal mengambil data";
  }
  static Future<ApiLelang> pageLelang(String pages,String filter) async{
    var url = Uri.parse("${BaseUrl}lelang_page?page=$pages&$filter");
    var response = await http.get(url,headers: {'Accept': "application/json"});
    return ApiLelang.fromJson(jsonDecode(response.body));
    // throw "Gagal mengambil data";
  }
  static Future<ApiLelang> historyLelang(String pages) async{
    var url = Uri.parse('${BaseUrl}lelang_page?status=ditutup&page=$pages');
    var response = await http.get(url,headers: {'Accept': "application/json"});

    return ApiLelang.fromJson(jsonDecode(response.body));
    // throw "Gagal mengambil data";
  }
  static Future<ApiLelang> detailLelang(int id_lelang) async{
    var url = Uri.parse('${BaseUrl}lelang_page?id_lelang=$id_lelang');
    var response = await http.get(url,headers: {'Accept': "application/json"});

    return ApiLelang.fromJson(jsonDecode(response.body));
    // throw "Gagal mengambil data";
  }
  static Future<ApiLelang> ikutLelang(String page, String token,String? filter) async{
    var url = Uri.parse('${BaseUrl}lelang_ikut?page=$page$filter');
    var response = await http.get(url,headers: {'Accept': "application/json",'Authorization': "Bearer $token"});

    return ApiLelang.fromJson(jsonDecode(response.body));
    // throw "Gagal mengambil data";
  }
  static Future<ApiHistoryLelang> detailHistoryLelang(int id_lelang) async{
    var url = Uri.parse('${BaseUrl}history_lelang?id_lelang=$id_lelang');

    var response = await http.get(url,headers: {'Accept': "application/json"});

    return ApiHistoryLelang.fromJson(jsonDecode(response.body));
    // throw "Gagal mengambil data";
  }
  static Future<ApiHistoryLelang> detailHistoryUser(int id_lelang,int id ,String? token) async{
    var url = Uri.parse('${BaseUrl}history_lelang?id_lelang=$id_lelang&user=true');
    var response = await http.get(url,headers: {'Accept': "application/json",'Authorization': "Bearer $token"});

    return ApiHistoryLelang.fromJson(jsonDecode(response.body));
    // throw "Gagal mengambil data";
  }
  static Future<ApiRegister> masyarakatRegister(Map<String,String> data)async{
    var url = Uri.parse('${BaseUrl}register_masyarakat');
    var response = await http.post(url,headers: {'Accept': "application/json"},body: data);
    
    return ApiRegister.fromJson(jsonDecode(response.body));
  }
  static Future<ApiRegister> registerAdmin(Map<String,String> data,String token)async{
    var url = Uri.parse('${BaseUrl}register_admin');
    var response = await http.post(url,headers: {'Accept': "application/json",'Authorization': "Bearer $token"},body: data);
    
    return ApiRegister.fromJson(jsonDecode(response.body));
  }
  static Future<ApiGetUser> getUser(String token)async{
    var url = Uri.parse('${BaseUrl}get_user');
    var response = await http.get(url,headers: {'Accept': "application/json","Authorization": "Bearer $token"});
    
    return ApiGetUser.fromJson(jsonDecode(response.body));
  }
  static Future<ApiGetUser> getAllUser(String filter,String token)async{
    var url = Uri.parse('${BaseUrl}all_user$filter');
    var response = await http.get(url,headers: {'Accept': "application/json","Authorization": "Bearer $token"});
    
    return ApiGetUser.fromJson(jsonDecode(response.body));
  }
  static Future<ApiTawarLelang> tawarLelang(String token,int idLelang,int tawar)async{
    var url = Uri.parse('${BaseUrl}tawar_lelang');
    var response = await http.post(url,headers: {'Accept': "application/json","Authorization": "Bearer $token"},
    body: {
      'tawar': tawar.toString(),
      'id_lelang': "$idLelang",
    });
    
    return ApiTawarLelang.fromJson(jsonDecode(response.body));
  }
}