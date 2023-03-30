import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'DataUser.dart';

class Pref{
  static Future<bool> saveToSharedPref(String id,String name,String level,String token)async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString('id', id);
    pref.setString('name', name);
    pref.setString('level', level);
    pref.setString('token',token);
    return true;
  }
  //cek apakah user memiliki preference sengan key "id"
  static Future<bool> checkPref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    //jika ada maka bernilai true, jika tidak maka bernilai false
    bool status = pref.containsKey("id");

    return status;
  }
  static Future<DataUser> getPref() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    DataUser dataUser = DataUser();
    dataUser.id = pref.getString("id");
    dataUser.name = pref.getString("name");
    dataUser.level = pref.getString("level");
    dataUser.token = pref.getString("token");
    return dataUser;
  }
  static Future<bool> logout() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    return true;
  }
}