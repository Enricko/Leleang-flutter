import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:intl/intl.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiHistoryLelang.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiLelang.dart' as lelang;


class DetailCloseBottom extends StatefulWidget {
  const DetailCloseBottom({
    super.key,required this.id_lelang,
  });
  final int id_lelang;

  @override
  State<DetailCloseBottom> createState() => _DetailCloseBottomState();
}

class _DetailCloseBottomState extends State<DetailCloseBottom> {
  final currencyFormatter = NumberFormat('#,000', 'ID');
  List<Data> history = [];
  Future<ApiHistoryLelang>? historyData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Api.detailHistoryLelang(widget.id_lelang).then((value){
      setState(() {
        history = value.data!;
        historyData = Api.detailHistoryLelang(widget.id_lelang);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: historyData,
      builder: (context, AsyncSnapshot<ApiHistoryLelang> snapshot){
        if(snapshot.hasData){
          return CloseBottom(context,snapshot.data!.data!);
        }
        if (snapshot.hasError) {
          return Center(
            child: Text("Somethink wrong ${snapshot.error}"),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Container CloseBottom(BuildContext context, List<Data> list) {
    if (list.length == 0) {
      return Container(
        padding: EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
        child: Responsive(
          children: [
            Div(
              divison: Division(
                colXS: 12,
                colS: 12,
                colM: 12,
                colL: 12,
                colXL: 12,
              ), 
              child: Text(
                'Barang Lelang ini tidak laku',
                textAlign:TextAlign.center,
                style: TextStyle(
                  fontSize: 20
                ),  
              ),
            ),
          ],
        ),
      );
    }
    return Container(
    padding: EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
    child: Responsive(
      children: [
        Div(
          divison: Division(
            colXS: 12,
            colS: 12,
            colM: 12,
            colL: 12,
            colXL: 12,
          ),
          child: Container(
            child: Text(
              "Lelang telah di tutup dan dimenangkan oleh",
              textAlign:TextAlign.center,
              style: TextStyle(
                fontSize: 20
              ),
            ),
          ),
        ),
        Div(
          divison: Division(
            colXS: 12,
            colS: 12,
            colM: 12,
            colL: 12,
            colXL: 12,
          ),
          child: Container(
            child: Text(
              "${list[0].user!.name!}",
              textAlign:TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
        Div(
          divison: Division(
            colXS: 12,
            colS: 12,
            colM: 12,
            colL: 12,
            colXL: 12,
          ),
          child: Container(
            child: Text(
              "dengan penawaran : Rp.${currencyFormatter.format(int.parse(list[0].penawaranHarga!))}",
              textAlign:TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
        ),
      ],
    ),
  );
  }
}

