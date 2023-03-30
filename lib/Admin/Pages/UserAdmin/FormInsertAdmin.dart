import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:select_form_field/select_form_field.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Home.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/ComponentLib/SharedPref.dart';

class FormInsertAdmin extends StatefulWidget {
  const FormInsertAdmin({super.key});

  @override
  State<FormInsertAdmin> createState() => _FormInsertAdminState();
}

class _FormInsertAdminState extends State<FormInsertAdmin> {
  bool isVisibility = true;
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'petugas',
    },
    {
      'value': 'administrasi',
    },
  ];
  TextEditingController _name = TextEditingController();
  TextEditingController _level = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _password_confirmation = TextEditingController();

  register(BuildContext context)async{
    var user = await Pref.getPref();

    var name = _name.text;
    var level = _level.text;
    var email = _email.text;
    var password = _password.text;
    var password_confirmation = _password_confirmation.text;

    if(password != password_confirmation){
      await EasyLoading.showError('Your password and password confrimation doesn`t match',dismissOnTap: true);
      return;
    }

    var data = {
      'name' : name,
      'email' : email,
      'level' : level,
      'password' : password,
      'password_confirmation' : password_confirmation,
    };

    Api.registerAdmin(data,user.token!).then((value) async{
      if(value.message != "Selamat datang"){
        await EasyLoading.showError(value.message!,dismissOnTap: true);
        return;
      }
      Navigator.pop(context);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => adminMain(page:2))
      );
      await EasyLoading.showSuccess('A new admin has been created!!!',dismissOnTap: true);
    });
    
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register Admin/Petugas',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: _name,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Name",
                    labelText: "Name",
                    hintStyle: TextStyle(
                      color: Colors.black
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800
                    ),
                    fillColor: Colors.white60,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white54),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white70),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 7),
                  child: SelectFormField(
                    controller: _level,
                    type: SelectFormFieldType.dropdown,
                    items: _items,
                    style: TextStyle(
                      color: Colors.black
                    ),
                    decoration: InputDecoration(
                      hintText: "Level",
                      labelText: "Level",
                      hintStyle: TextStyle(
                        color: Colors.black
                      ),
                      labelStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800
                      ),
                      fillColor: Colors.white60,
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.white54),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(width: 3, color: Colors.white70),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    // onChanged: (val) => print(val),
                    // onSaved: (val) => print(val),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: _email,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Email",
                    labelText: "Email",
                    hintStyle: TextStyle(
                      color: Colors.black
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800
                    ),
                    fillColor: Colors.white60,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white54),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white70),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                child: TextFormField(
                  obscureText: isVisibility,
                  controller: _password,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Password",
                    labelText: "Password",
                    hintStyle: TextStyle(
                      color: Colors.black
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800
                    ),
                    fillColor: Colors.white60,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white54),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white70),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    suffixIcon: IconButton(
                      icon: isVisibility == true
                          ? Icon(Icons.visibility_off)
                          : Icon(Icons.visibility),
                      onPressed: () {
                        setState(() {
                          isVisibility = !isVisibility;
                        });
                      },
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                child: TextFormField(
                  obscureText: true,
                  controller: _password_confirmation,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Password Confirm",
                    labelText: "Password Confirm",
                    hintStyle: TextStyle(
                      color: Colors.black
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800
                    ),
                    fillColor: Colors.white60,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white54),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white70),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => register(context),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal:15,vertical: 10),
                    decoration: BoxDecoration(
                      color:Colors.blueAccent ,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}