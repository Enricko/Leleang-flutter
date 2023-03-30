import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiLelang.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/DetailLelang/DetailBottom.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/DetailLelang/DetailCloseBottom.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/DetailLelang/DetailTable.dart';

import '../ComponentLib/SharedPref.dart';
import '../main.dart';

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

class DetailLelang extends StatefulWidget {
  const DetailLelang({super.key, required this.id_lelang});
  final int id_lelang;

  @override
  State<DetailLelang> createState() => _DetailLelangState();
}

class _DetailLelangState extends State<DetailLelang> {
  final currencyFormatter = NumberFormat('#,000', 'ID');
  TextEditingController controllerTawar = TextEditingController();
  String? id;
  String? name;
  String? level;
  String? token;
  String? imageBarangPath;
  String? status;
  Future<ApiLelang>? detailLelang;
  Future<void> userCheck()async{
    var DataUser = await Pref.getPref();
      // print(prefs.getString('name'));
      setState(() {
        id = DataUser.id;
        name = DataUser.name;
        level = DataUser.level;
        token = DataUser.token;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userCheck();
    Api.detailLelang(widget.id_lelang).then((value){
      setState(() {
        detailLelang = Api.detailLelang(widget.id_lelang);
        imageBarangPath = value.imageBarangPath!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: detailLelang,
      builder: (context,AsyncSnapshot<ApiLelang> snapshot){
        if (snapshot.hasData) {
          return Detail(context, snapshot.data!.data!);
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

  Scaffold Detail(BuildContext context, List<Data> list) {
    var hargaSekarang = list[0].barang!.hargaAkhir! == "" ? list[0].barang!.hargaAwal! : list[0].barang!.hargaAkhir!;
    // print(hargaSekarang);
    return Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text(capitalizeAllSentence("${list[0].barang!.namaBarang!}")),
    ),
    body: SingleChildScrollView(
      child: Container(
        child: Responsive(
          children: [
            Div(
              divison: const Division(
                colL: 12
              ),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 15),
                child: Center(
                  child: SizedBox(
                    width: 230,
                    height: 230,
                    child: Image.network(
                      '$imageBarangPath${list[0].barang!.imageBarang}',
                      width: 230,
                      height: 230,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress){
                        if (loadingProgress == null) {
                          return child;
                        }
                        return Image.asset(
                          "image/tambahan/image_placeholder.png",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
            Div(
              divison: const Division(colL: 12),
              child: Container(
                width: 1000,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 99, 98, 98),
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25))
                ),
                child: Container(
                  margin: const EdgeInsets.all(20),
                  child: Responsive(
                    children: [
                      Div(
                        divison: const Division(
                          colXS: 12,
                          colS: 12,
                          colM: 12,
                          colL: 6
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                capitalizeAllSentence(list[0].barang!.namaBarang!),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w600
                                ),
                              ),
                            ),          
                            const SizedBox(
                              height: 20,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Harga Sekarang:',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 219, 219, 219)
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "Rp.${currencyFormatter.format(int.parse(hargaSekarang))}",
                                style: const TextStyle(
                                  color: Color.fromARGB(255, 245, 245, 245),
                                  fontSize: 26,
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 250,
                                maxWidth: 1000,
                                minWidth: 1000,
                              ),
                              child: SingleChildScrollView(
                                // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                child: Container(
                                  child: Text(
                                    list[0].barang!.deskripsi!,
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 245, 245, 245),
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Div(
                        divison: Division(
                          colXS: 12,
                          colS: 12,
                          colM: 12,
                          colL: 0
                        ),
                        child: SizedBox(
                          height: 25,
                        ),
                      ),
                      Div(
                        divison: const Division(
                          colXS: 12,
                          colS: 12,
                          colM: 12,
                          colL: 6
                        ),
                        child: Column(
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              margin: const EdgeInsets.only(bottom: 10),
                              child: const Text(
                                'History Lelang',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w400
                                ),
                              ),
                            ),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 350,
                              ),
                              child: Column(
                                children: [
                                  Table(
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
                                      TableRow(
                                        children: [
                                          TableCell(
                                            child: Container(
                                              margin: const EdgeInsets.all(3),
                                              color: Colors.black54,
                                              child: Text(
                                                '#',
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
                                              margin: const EdgeInsets.all(3),
                                              color: Colors.black54,
                                              child: Text(
                                                'User',
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
                                              margin: const EdgeInsets.all(3),
                                              color: Colors.black54,
                                              child: Text(
                                                'Penawaran',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20
                                                ),
                                              ),
                                            ),
                                          ),
                                        ]
                                      ),
                                    ],
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxHeight: 320,
                                    ),
                                    child: SingleChildScrollView(
                                      // physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                                      child: TableDetail(id_lelang: list[0].idLelang!,),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
    bottomNavigationBar: 
    list[0].status != 'ditutup'?
      id != null ?
      DetailBottom(controllerTawar: controllerTawar, id: int.parse(id!),id_lelang: int.parse(list[0].idLelang!),token: token!,):
      Container(
        padding: EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => {
                  Navigator.pop(context),
                  Navigator.pushReplacement(context, 
                    MaterialPageRoute(builder: (context) => MyHomePage(page: 2)),
                  ),
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text(
                    "Login Untuk Menawar",
                    textAlign:TextAlign.center,
                    style: TextStyle(
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ):
    DetailCloseBottom(id_lelang: int.parse(list[0].idLelang!)),
  );
    
  }
}
