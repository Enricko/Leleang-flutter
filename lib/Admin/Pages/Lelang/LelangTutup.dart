import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Home.dart';

import '../../../Api/Api.dart';
import '../../../Api/ApiLelang.dart';
import '../../../ComponentLib/SharedPref.dart';
  
class LelangTutup extends StatefulWidget {
  const LelangTutup({super.key});

  @override
  State<LelangTutup> createState() => _LelangTutupState();
}
class Manusia {
  DateTime buka,tutup;
  int harga_awal,id_user,id_petugas;
  String image,nama_barang;

  Manusia(
      this.image,
      this.nama_barang,
      this.buka,
      this.tutup,
      this.harga_awal,
      this.id_user,
      this.id_petugas,
      );
}

class _LelangTutupState extends State<LelangTutup> {
  String? imagePath;
  Future<ApiLelang>? futureLelang;

  Future<void> lelang()async{
    var dataUser = await Pref.getPref();
    futureLelang = Api.LelangTable(dataUser.token! ,'status=ditutup');
     
    Api.LelangTable(dataUser.token! ,'status=ditutup').then((value){
      setState(() {
        imagePath = value.imageBarangPath!;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    lelang();
  }

  int perPageSelected = 10;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(top: 15,bottom: 25),
            child: Text(
              'Table Lelang Ditutup',
              style: TextStyle(
                fontSize: 24
              ),
            ),
          ),
          FutureBuilder(
            future: futureLelang,
            builder: (context, AsyncSnapshot<ApiLelang> snapshot) {
              if(snapshot.hasData){
                return DataTableLelang(context,snapshot.data!.data!);
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting: return Center(child: CircularProgressIndicator());
                default:
                  if (snapshot.hasError)
                    return Center(child: Text('Error: ${snapshot.error}'));
                  else
                  return Center(
                    child:Text('No data were generate in this tables')
                  );
              }
            },
          ),
        ],
      ),
    );
  }

  SingleChildScrollView DataTableLelang(BuildContext context, List<Data> lelangList) {
    return SingleChildScrollView(
          child: PaginatedDataTable(
            arrowHeadColor: Colors.white,
            dataRowHeight: 100,
            header: Text("Table Lelang Ditutup"),
            onRowsPerPageChanged: (perPage) {
              setState(() {
                perPageSelected = perPage!;
              });
            },
            rowsPerPage: perPageSelected,
            columns: <DataColumn>[
              DataColumn(
                label: Text('No'),
              ),
              DataColumn(
                label: Text('Image'),
              ),
              DataColumn(
                label: Text('Nama Barang'),
              ),
              DataColumn(
                label: Text('Tanggal Dibuka'),
              ),
              DataColumn(
                label: Text('Tanggal Ditutup'),
              ),
              DataColumn(
                label: Text('Harga Awal'),
              ),
              DataColumn(
                label: Text('Harga Tertinggi'),
              ),
              DataColumn(
                label: Text('Penanggung Jawab'),
              ),
              DataColumn(
                label: Text('History Lelang'),
              ),
            ],
            source: MyData(lelangList: lelangList, context: context,imagePath:imagePath!),
          ),
        );
  }
}
class MyData extends DataTableSource {
  MyData({required this.context,required this.lelangList,required this.imagePath});
  final BuildContext context;
  final String imagePath;
  final List<Data> lelangList;
  @override
  DataRow? getRow(int index) {
    if(index >= lelangList.length){
      return null;
    }
    final user = lelangList[index];
    return DataRow(cells: [
      DataCell(Text("${index + 1}")),
      DataCell(Image.network(
        '$imagePath${user.barang!.imageBarang}',
        height: 75,
        width: 100,
        fit: BoxFit.cover,
      )),
      DataCell(Text("${user.barang!.namaBarang!}")),
      DataCell(Text("${DateFormat("EEEE, yyyy-MM-dd HH:mm:ss").format(DateTime.parse(user.tglDibuka!))}")),
      DataCell(Text("${DateFormat("EEEE, yyyy-MM-dd HH:mm:ss").format(DateTime.parse(user.tglDitutup!))}")),
      DataCell(Text("${user.barang!.hargaAwal!}")),
      DataCell(
        user.user!.id! == "" ? Text("Belum ada penawar"):
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                'image/tambahan/download.jpeg',
                height: 50,
                width: 50,
              ),
            ),
            Text("${user.user!.name!}"),
            Text("Rp.${user.barang!.hargaAkhir!}"),
          ],
        )
      ),
      DataCell(
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ClipRRect(
            //   borderRadius: BorderRadius.circular(50),
            //   child: Image.asset(
            //     'image/tambahan/download.jpeg',
            //     height: 75,
            //     width: 75,
            //   ),
            // ),
            Text("${user.idPetugas!}"),
          ],
        )
      ),
      DataCell(
        TextButton(
          onPressed: () => {
            Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => adminMain(page:6,id_lelang:int.parse(user.idLelang!)))
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
              "History Lelang",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => lelangList.length;

  @override
  int get selectedRowCount => 0;
}