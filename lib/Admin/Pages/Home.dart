import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Pages/LaporanPrint.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/ComponentLib/SharedPref.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  int countAllBarang = 0;
  int countSedangDijual = 0;
  int countTelahDijual = 0;
  int userMas = 0;
  String? token;
  Future<void> users()async{
    var dataUser = await Pref.getPref();
    setState(() {
      token = dataUser.token!;
    });
    Api.getAllUser('?level=masyarakat', dataUser.token!).then((value){
      setState(() {
        userMas = value.count!;
      });
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    users();
    super.initState();
    Api.pageLelang('1','status=dibuka').then((value){
      setState(() {
        countSedangDijual = value.count!;
      });
    });
    Api.pageLelang('1','status=ditutup').then((value){
      setState(() {
        countTelahDijual = value.count!;
      });
    });
    Api.pageLelang('1','').then((value){
      setState(() {
        countAllBarang = value.count!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15),
      child: Column(
        children: [
          Responsive(
            children: [
              Div(
                divison: Division(
                  colXS: 12,
                  colS: 12,
                  colM: 6,
                  colL: 3,
                  colXL: 3
                ),
                child: Card(
                  child: Row(
                    children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15,top: 15,left: 15,right: 25),
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent
                      ),
                      child: Icon(
                        Icons.widgets_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Barang',
	                    overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          '${countAllBarang}',
                        ),
                      ],
                    )
                   ],
                  ),
                ),
              ),
              Div(
                divison: Division(
                  colXS: 12,
                  colS: 12,
                  colM: 6,
                  colL: 3,
                  colXL: 3
                ),
                child: Card(
                  child: Row(
                    children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15,top: 15,left: 15,right: 25),
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.redAccent
                      ),
                      child: Icon(
                        Icons.sell,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Sedang Dijual',
	                    overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          '${countSedangDijual}',
                        ),
                      ],
                    )
                   ],
                  ),
                ),
              ),
              Div(
                divison: Division(
                  colXS: 12,
                  colS: 12,
                  colM: 6,
                  colL: 3,
                  colXL: 3
                ),
                child: Card(
                  child: Row(
                    children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15,top: 15,left: 15,right: 25),
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent
                      ),
                      child: Icon(
                        Icons.attach_money_outlined,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Telah Terjual',
	                    overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          '${countTelahDijual}',
                        ),
                      ],
                    )
                   ],
                  ),
                ),
              ),
              Div(
                divison: Division(
                  colXS: 12,
                  colS: 12,
                  colM: 6,
                  colL: 3,
                  colXL: 3
                ),
                child: Card(
                  child: Row(
                    children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 15,top: 15,left: 15,right: 25),
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: Colors.yellow
                      ),
                      child: Icon(
                        Icons.groups,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 100
                          ),
                          child: Text(
                            'User Masyarakat',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700
                            ),
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          '$userMas',
                        ),
                      ],
                    )
                   ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 25,
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: ()=>Navigator.push(context,
                MaterialPageRoute(builder: (context) => LaporanPrint(token: token!,))),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(15)
                ),
                child: Text(
                  'Laporan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}