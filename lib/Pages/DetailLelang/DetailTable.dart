import 'package:flutter/material.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:intl/intl.dart';
import '../../Api/ApiHistoryLelang.dart';

String capitalizeAllSentence(String value) {
  var result = value[0].toUpperCase();
  bool caps = false;
  bool start = true;

  for (int i = 1; i < value.length; i++) {
    if(start == true){
        if (value[i - 1] == " " && value[i] != " "){
            result = result + value[i].toUpperCase();
            start = false;
        }else{
            result = result + value[i];
        }
    }else{
      if (value[i - 1] == " " && caps == true) {
        result = result + value[i].toUpperCase();
        caps = false;
      } else {
          if(caps && value[i] != " "){
              result = result + value[i].toUpperCase();
              caps = false;
          }else{
              result = result + value[i];
          }
      }

      if(value[i] == "."){
          caps = true;
      }
    }  
  }
  return result;
}

class TableDetail extends StatefulWidget {
  const TableDetail({super.key, required this.id_lelang});
  final String id_lelang;

  @override
  State<TableDetail> createState() => _TableDetailState();
}

class _TableDetailState extends State<TableDetail> {
  final currencyFormatter = NumberFormat('#,000', 'ID');
  List<Data> history = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Api.detailHistoryLelang(int.parse(widget.id_lelang)).then((value){
      setState(() {
        history = value.data!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: {
        0: const FixedColumnWidth(50.0),// fixed to 100 width
        1: const FlexColumnWidth(),
        2: const FlexColumnWidth(),//fixed to 100 width
      },
      border: TableBorder.all(
        color: const Color.fromARGB(255, 143, 143, 143),
        width: 3
      ),
      children: [
        for(var i = 0; i < history.length; i++) 
        TableRow(
          children: [
            TableCell(
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: i == 0 ? Color.fromARGB(255, 201, 201, 65) : i == 1 ? Color.fromARGB(255, 125, 129, 127) : i == 2 ? Color.fromARGB(255, 122, 83, 68) : null,
                ),
                child: Text(
                  '${i + 1}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                decoration: BoxDecoration(
                  color: i == 0 ? Color.fromARGB(255, 201, 201, 65) : i == 1 ? Color.fromARGB(255, 125, 129, 127) : i == 2 ? Color.fromARGB(255, 122, 83, 68) : null,
                ),
                margin: const EdgeInsets.all(3),
                child: Text(
                  history[i].user!.name!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
              ),
            ),
            TableCell(
              child: Container(
                decoration: BoxDecoration(
                  color: i == 0 ? Color.fromARGB(255, 201, 201, 65) : i == 1 ? Color.fromARGB(255, 125, 129, 127) : i == 2 ? Color.fromARGB(255, 122, 83, 68) : null,
                ),
                margin: const EdgeInsets.all(3),
                child: Text(
                  'Rp.${currencyFormatter.format(int.parse(history[i].penawaranHarga!))}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20
                  ),
                ),
              ),
            ),
          ]
        ),
      
      ],
    );
  }
}