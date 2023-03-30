import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Home.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';

import '../../../Api/ApiHistoryLelang.dart';
  
class HistoryLelang extends StatefulWidget {
  const HistoryLelang({super.key, required this.id_lelang});
  final int id_lelang;

  @override
  State<HistoryLelang> createState() => _HistoryLelangState();
}

class _HistoryLelangState extends State<HistoryLelang> {
  List<Data> history = [];

  @override
  void initState() {
    super.initState();
    Api.detailHistoryLelang(widget.id_lelang).then((value){
      setState(() {
        history = value.data!;
      });
    });
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
              'Table History Lelang #${widget.id_lelang}',
              style: TextStyle(
                fontSize: 24
              ),
            ),
          ),
          SingleChildScrollView(
            child: PaginatedDataTable(
              arrowHeadColor: Colors.white,
              dataRowHeight: 100,
              header: Text("Table History Lelang #1"),
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
                  label: Text('Penawar'),
                ),
                DataColumn(
                  label: Text('Telp'),
                ),
                DataColumn(
                  label: Text('Email'),
                ),
                DataColumn(
                  label: Text('Penawaran Harga'),
                ),
              ],
              source: MyData(history: history, context: context),
            ),
          ),
        ],
      ),
    );
  }
}
class MyData extends DataTableSource {
  MyData({required this.context,required this.history});
  final BuildContext context;
  final List<Data> history;
  @override
  DataRow? getRow(int index) {
    if(index >= history.length){
      return null;
    }
    final historyData = history[index];
    return DataRow(cells: [
      DataCell(Text("${index + 1}")),
      DataCell(Column(
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
          Text("${historyData.user!.name!}")
        ],
      )),
      DataCell(Text("${historyData.user!.telp!}")),
      DataCell(Text("${historyData.user!.email!}")),
      DataCell(Text("${historyData.penawaranHarga!}")),
    ]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => history.length;

  @override
  int get selectedRowCount => 0;
}