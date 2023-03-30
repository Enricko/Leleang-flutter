import  'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Pages/Lelang/FormInsertLelang.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Pages/Lelang/HistoryLelang.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Pages/Lelang/LelangTutup.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Pages/Lelang/lelang.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Pages/UserAdmin/FormInsertAdmin.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Pages/UserMasyarakat.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/Home.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/main.dart';

import '../ComponentLib/SharedPref.dart';
import 'Pages/Home.dart';
import 'Pages/UserAdmin/UserAdmin.dart';

class adminMain extends StatefulWidget {
  const adminMain({super.key,this.page = 0, this.id_lelang = 0});
  final int page;
  final int id_lelang;

  @override
  State<adminMain> createState() => _adminMainState();
}

class _adminMainState extends State<adminMain> {
  
  late int selectedIndex;
  String? id;
  String? name;
  String? level;
  String? token;

  Future<void> userCheck()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id_pref = prefs.getString('id');
    var name_pref = prefs.getString('name');
    if (id_pref == null) {
      Navigator.pop(context);
      Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(page: 3))
      );
      await EasyLoading.showError('You need login first',dismissOnTap: true);
      return;
    }else{
      var DataUser = await Pref.getPref();
      if(DataUser.level == 'masyarakat'){
        Navigator.pop(context);
        Navigator.pushReplacement(context, 
          MaterialPageRoute(builder: (context) => MyHomePage())
        );
        await EasyLoading.showError('You dont have access to that pages',dismissOnTap: true);
        return;
      }
      setState(() {
        id = DataUser.id;
        name = DataUser.name;
        level = DataUser.level;
        token = DataUser.token;
      });
    }
  }
  List<Widget> Pages = [];
  
  @override
  void initState() {
    selectedIndex = widget.page == 0 ? 0 : widget.page;
    super.initState();
    userCheck();
    Pages = [
      AdminHome(), //0
      UserMasyarakat(), //1
      UserAdmin(),//2
      FormInsertAdmin(),//3
      LelangIndex(),//4
      LelangTutup(),//5
      HistoryLelang(id_lelang:widget.id_lelang),//6
      FormInsertLelang(),//7
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Welcome to Admin Page'),
      ),
      body: SingleChildScrollView(
        child: level == null ? Container() : level == 'masyarakat' ? Container() : Pages[selectedIndex],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 75, 74, 74)
                ),
                child: Stack(
                  children:[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.asset(
                            'image/tambahan/download.jpeg',
                            width: 75,
                            height: 75,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Administrasi',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 49, 49, 49),
                          borderRadius: BorderRadius.circular(50)
                        ),
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.arrow_forward_ios),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                selectedColor: Colors.blueGrey,
                hoverColor: Colors.blueGrey,
                tileColor: selectedIndex == 0 ? Colors.blueGrey : null,
                title: Container(
                  child: Row(
                    children: [
                      Icon(Icons.speed,size: 16,color: Colors.white),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Dashboard',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () => onItemTapped(0),
              ),
              level == 'petugas' ? Container() :
              Container(
                margin: EdgeInsets.only(left: 15,top: 15,bottom: 10),
                child: Text(
                  "Users",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                  ),
                ),
              ),

              level == 'petugas' ? Container() :
              ListTile(
                selectedColor: Colors.blueGrey,
                hoverColor: Colors.blueGrey,
                tileColor: selectedIndex == 1 ? Colors.blueGrey : null,
                title: Container(
                  child: Row(
                    children: [
                      Icon(Icons.groups,size: 16,color: Colors.white),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'User Masyarakat',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () => onItemTapped(1),
              ),
              level == 'petugas' ? Container() :
              ListTile(
                selectedColor: Colors.blueGrey,
                hoverColor: Colors.blueGrey,
                tileColor: [2,3].contains(selectedIndex)? Colors.blueGrey : null,
                title: Container(
                  child: Row(
                    children: [
                      Icon(Icons.groups,size: 16,color: Colors.white),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'User Admin/Petugas',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () => onItemTapped(2),
              ),
              Container(
                margin: EdgeInsets.only(left: 15,top: 15,bottom: 10),
                child: Text(
                  "Lelang",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                  ),
                ),
              ),
              ListTile(
                selectedColor: Colors.blueGrey,
                hoverColor: Colors.blueGrey,
                tileColor: [4,6].contains(selectedIndex)? Colors.blueGrey : null,
                title: Container(
                  child: Row(
                    children: [
                      Icon(Icons.gavel,size: 16,color: Colors.white),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Lelang Dibuka',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () => onItemTapped(4),
              ),
              ListTile(
                selectedColor: Colors.blueGrey,
                hoverColor: Colors.blueGrey,
                tileColor: [5,6].contains(selectedIndex)? Colors.blueGrey : null,
                title: Container(
                  child: Row(
                    children: [
                      Icon(Icons.gavel,size: 16,color: Colors.white),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Lelang Ditutup',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () => onItemTapped(5),
              ),
              Container(
                margin: EdgeInsets.only(left: 15,top: 15,bottom: 10),
                child: Text(
                  "Settings",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14
                  ),
                ),
              ),
              ListTile(
                selectedColor: Colors.blueGrey,
                hoverColor: Colors.blueGrey,
                title: Container(
                  child: Row(
                    children: [
                      Icon(Icons.undo,size: 16,color: Colors.white),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Back To Front',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () =>{
                  Navigator.pop(context),
                  Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context) => MyHomePage(),)
                  ),
                },
              ),
              ListTile(
                selectedColor: Colors.blueGrey,
                hoverColor: Colors.blueGrey,
                title: Container(
                  child: Row(
                    children: [
                      Icon(Icons.power_settings_new,size: 16,color: Colors.white),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        'Logout',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      )
                    ],
                  ),
                ),
                onTap: () => null,
              ),
            ],
          ),
        ),
      ),
    );
  }
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

