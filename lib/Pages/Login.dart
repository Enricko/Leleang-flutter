import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/main.dart';
import '';

import '../Admin/Home.dart';
import '../Api/Api.dart';
import '../ComponentLib/DataUser.dart';
import '../ComponentLib/SharedPref.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  bool isVisibility = true;
  bool registerClicked = false;
  late bool onHoverLogin = true;
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  String? id;
  String? name;
  String? level;
  String? token;

  login(BuildContext context){
    var email = controllerEmail.text;
    var password = controllerPassword.text;
    if(email.isEmpty && password.isEmpty){
      EasyLoading.showError('Please insert Email & Password',dismissOnTap: true);
      return;
    }else{
      if (email.isEmpty) {
        EasyLoading.showError('Please insert Email',dismissOnTap: true);
        return;
      }
      if (password.isEmpty) {
        EasyLoading.showError('Please insert Password',dismissOnTap: true);
        return;
      }
    }
    var data = {
      'email': email,
      'password': password,
    };
    Api.login(data).then((value) async{
      if(value.message == null){
        //muncul error
        await EasyLoading.showError('Email or Password is incorrect',dismissOnTap: true);
        return;
      }
      // print('masuk'+ value.data!.name!);

      Pref.saveToSharedPref(
        value.data!.id!.toString(), 
        value.data!.name!, 
        value.data!.level!, 
        value.token!
      );
      if(value.data!.level! != 'masyarakat'){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => adminMain())
        );
        await EasyLoading.showSuccess('Welcome Back ${value.data!.name!}',dismissOnTap: true);
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage(page:1))
        );
        await EasyLoading.showSuccess('Welcome Back ${value.data!.name!}',dismissOnTap: true);
      }
    });
  }

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _telp = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _password_confirmation = TextEditingController();

  register(BuildContext context)async{
    var name = _name.text;
    var email = _email.text;
    var telp = _telp.text;
    var password = _password.text;
    var password_confirmation = _password_confirmation.text;

    if(password != password_confirmation){
      await EasyLoading.showError('Your password and password confrimation doesn`t match',dismissOnTap: true);
      return;
    }

    var data = {
      'name' : name,
      'email' : email,
      'telp' : telp,
      'password' : password,
      'password_confirmation' : password_confirmation,
    };

    Api.masyarakatRegister(data).then((value) async{
      if(value.message != "Selamat datang"){
        await EasyLoading.showError(value.message!,dismissOnTap: true);
        return;
      }
      Pref.saveToSharedPref(
        value.data!.id!.toString(), 
        value.data!.name!, 
        value.data!.level!, 
        value.token!
      );
      if(value.data!.level! != 'masyarakat'){
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => adminMain())
        );
        await EasyLoading.showSuccess('Thank You For Register to our APPS',dismissOnTap: true);
      }else{
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => MyHomePage(page:1))
        );
        await EasyLoading.showSuccess('Thank You For Register to our APPS',dismissOnTap: true);
      };
    });
    
  }
  // user() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   var id_pref = prefs.getString('id');
  //   var name_pref = prefs.getString('name');
  //   if (id_pref == null) {
  //     print('Need Login!');
  //     // Navigator.of(context)
  //     //     .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
  //   }
  //   var DataUser = await Pref.getPref();
  //   print(prefs.getString('name'));
  //   setState(() {
  //     id = DataUser.id;
  //     name = DataUser.name;
  //   });
  // }
  

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 35,horizontal: 10),
      child: Center(
        child: SizedBox(
          width: 700,
          child: Card(
            color: Color.fromARGB(255, 124, 124, 124),
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 40),
              child: registerClicked ? RegisterSection(context) : LoginSection(context),
            ),
          ),
        ),
      ),
    );
  }
  Widget LoginSection(BuildContext context) {
    return Responsive(
      children: [
        Div(
          divison: Division(
            colL: 12,
          ),
          child: Text(
            "LOGIN",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 42
            ),
          ),
        ),
        Div(
          divison: Division(
            colL: 12,
          ),
          child: SizedBox(
            height: 25,
          ),
        ),
        Div(
          divison: Division(
            colL: 12,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.05,vertical: 7),
            child: TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: controllerEmail,
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
        ),
        Div(
          divison: Division(
            colL: 12,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.05,vertical: 7),
            child: TextFormField(
              obscureText: isVisibility,
              controller: controllerPassword,
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
                      // Memeberikan nilai pada variable isVisibility
                      // dengan nilai balikan dari nilai is inVisibility sebelumnya
                      isVisibility = !isVisibility;
                    });
                  },
                ),
              ),
            ),
          ),
        ),
        Div(
          divison: Division(colL: 12),
          child: SizedBox(
            height: 20,
          ),
        ),
        Center(
          child: TextButton(
            onPressed: () => login(context),
            child: Container(
              margin: EdgeInsets.only(top: 25,bottom: 10),
              padding: EdgeInsets.symmetric(horizontal:15,vertical: 10),
              decoration: BoxDecoration(
                color:Colors.blueAccent ,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Text(
                "LOGIN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Don't have account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              TextButton(
                onPressed: () =>
                setState(() {
                  registerClicked = !registerClicked;
                }),
                child: Text(
                  "Register",
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
  Widget RegisterSection(BuildContext context) {

    double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
    bool isVisibility = true;
    late bool onHoverLogin = true;
    return Responsive(
      children: [
        Div(
          divison: Division(
            colL: 12,
          ),
          child: Text(
            "Register",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 42
            ),
          ),
        ),
        Div(
          divison: Division(
            colL: 12,
          ),
          child: SizedBox(
            height: 25,
          ),
        ),
        Div(
          divison: Division(
            colL: 12,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.05,vertical: 7),
            child: TextFormField(
              controller: _name,
              keyboardType: TextInputType.name,
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
        ),
        Div(
          divison: Division(
            colL: 12,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.05,vertical: 7),
            child: TextFormField(
              controller: _telp,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(15),
                hintText: "NoTelp",
                labelText: "NoTelp",
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
        ),
        Div(
          divison: Division(
            colL: 12,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.05,vertical: 7),
            child: TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
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
        ),
        Div(
          divison: Division(
            colL: 12,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.05,vertical: 7),
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
        ),
        Div(
          divison: Division(
            colL: 12,
          ),
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.05,vertical: 7),
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
        ),
        Center(
          child: TextButton(
            onPressed: () => register(context),
            child: Container(
              margin: EdgeInsets.only(top: 25,bottom: 10),
              padding: EdgeInsets.symmetric(horizontal:15,vertical: 10),
              decoration: BoxDecoration(
                color:Colors.blueAccent ,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Text(
                "Register",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600
                ),
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Already have account?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white
                ),
              ),
              TextButton(
                onPressed: () =>
                setState(() {
                  registerClicked = !registerClicked;
                }),
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

