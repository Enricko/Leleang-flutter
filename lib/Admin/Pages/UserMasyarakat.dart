import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/ComponentLib/SharedPref.dart';

import '../../Api/ApiGetUser.dart';
  
class UserMasyarakat extends StatefulWidget {
  const UserMasyarakat({super.key});

  @override
  State<UserMasyarakat> createState() => _UserMasyarakatState();
}

class _UserMasyarakatState extends State<UserMasyarakat> {
  // final DataTableSource _data = MyData();
  List<Data> getUser = [];
  Future<void> users()async{
    var dataUser = await Pref.getPref();
    Api.getAllUser('?level=masyarakat', dataUser.token!).then((value){
      setState(() {
        getUser = value.data!;
      });
    });
  }
  @override
  void initState() {
    super.initState();
    users();
  }

  int perPageSelected = 10;
  // int perPageSelectedOnChange = 10;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15,bottom: 25),
            child: Text(
              'Table User Masyarakat',
              style: TextStyle(
                fontSize: 24
              ),
            ),
          ),
          SingleChildScrollView(
            child: PaginatedDataTable(
              arrowHeadColor: Colors.white,
              header: Text("Table User Masyarakat"),
              onRowsPerPageChanged: (perPage) {
                setState(() {
                  perPageSelected = perPage!;
                  // perPageSelectedOnChange = perPage;
                });
              },
              // onPageChanged: (int? n){
              //   setState(() {
              //     if (DaftarSiswa.length - n! < perPageSelected) {
              //       if (DaftarSiswa.length - n < 10) {
              //         perPageSelected = 10;
              //       }else if(DaftarSiswa.length - n < 20){
              //         perPageSelected = 20;
              //       }else if(DaftarSiswa.length - n < 50){
              //         perPageSelected = 50;
              //       }else if(DaftarSiswa.length - n < 100){
              //         perPageSelected = 100;
              //       }
              //     }else{
              //       perPageSelected = perPageSelectedOnChange;
              //     }
              //   });
              // },
              rowsPerPage: perPageSelected,
              columns: <DataColumn>[
                DataColumn(
                  label: Text('No'),
                ),
                DataColumn(
                  label: Text('ID'),
                ),
                DataColumn(
                  label: Text('Name'),
                ),
                DataColumn(
                  label: Text('Email'),
                ),
                DataColumn(
                  label: Text('Telp'),
                ),
              ],
              source: MyData(userData: getUser),
            ),
          ),
          // SizedBox(
          //   width: double.infinity,
          //   child: Center(
          //     child: 
          //   ),
          // ),
        ],
      ),
    );
  }
}
class MyData extends DataTableSource {
  MyData({required this.userData});
  final List<Data> userData;
  @override
  DataRow? getRow(int index) {
    if(index >= userData.length){
      return null;
    }
    final user = userData[index];
    return DataRow(cells: [
      DataCell(Text("${index + 1}")),
      DataCell(Text(user.id.toString())),
      DataCell(Text(user.name!)),
      DataCell(Text(user.email!)),
      DataCell(Text(user.telp.toString())),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userData.length;

  @override
  int get selectedRowCount => 0;
}