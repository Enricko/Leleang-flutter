import 'dart:math';

import 'package:flutter/material.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Home.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Pages/Home.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/ComponentLib/SharedPref.dart';

import '../../../Api/ApiGetUser.dart';
  
class UserAdmin extends StatefulWidget {
  const UserAdmin({super.key});

  @override
  State<UserAdmin> createState() => _UserAdminState();
}

class _UserAdminState extends State<UserAdmin> {
  // final DataTableSource _data = MyData();
  List<Data> getUser = [];
  Future<void> users()async{
    var dataUser = await Pref.getPref();
    Api.getAllUser('?admin=true', dataUser.token!).then((value){
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
            margin: EdgeInsets.only(top: 15,bottom: 7),
            child: Text(
              'Table User Admin/Petugas',
              style: TextStyle(
                fontSize: 24
              ),
            ),
          ),
          TextButton(
            onPressed: () => {
              Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => adminMain(page:3))
              ),
            },
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal:15,vertical: 10),
              decoration: BoxDecoration(
                color:Colors.blueAccent ,
                borderRadius: BorderRadius.circular(25)
              ),
              child: Text(
                "+ Tambah Data",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: PaginatedDataTable(
              arrowHeadColor: Colors.white,
              header: Text("Table User Admin/Petugas"),
              onRowsPerPageChanged: (perPage) {
                setState(() {
                  perPageSelected = perPage!;
                  // perPageSelectedOnChange = perPage;
                });
              },
              // onPageChanged: (int? n){
              //   setState(() {
              //     if (DaftarSiswa.length - n! < perPageSelected) {
              //       perPageSelected = PaginatedDataTable.defaultRowsPerPage;
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
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => userData.length;

  @override
  int get selectedRowCount => 0;
}