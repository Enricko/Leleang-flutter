import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/ComponentLib/SharedPref.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/DetailLelang.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/main.dart';
import 'package:intl/intl.dart';

import '../../Api/ApiHistoryLelang.dart';

class DetailBottom extends StatefulWidget {
  const DetailBottom({
    super.key,
    required this.controllerTawar,
    required this.id_lelang,
    required this.id,
    required this.token,
  });
  final TextEditingController controllerTawar;
  final int id_lelang;
  final int id;
  final String token;

  @override
  State<DetailBottom> createState() => _DetailBottomState();
}

class _DetailBottomState extends State<DetailBottom> {
  final currencyFormatter = NumberFormat('#,000', 'ID');
  List<Data> historyUser = [];
  TextEditingController controllerTawar = TextEditingController();

  Future<void> tawar(BuildContext context)async{
    var user = await Pref.getPref();
    var valueTawar = int.parse((controllerTawar.text).replaceAll(RegExp("[a-zA-Z:\s. ()]"),''));
    
    Api.tawarLelang(user.token!, widget.id_lelang, valueTawar).then((value) async{
      if (value.message! != "Selamat anda telah menawar barang ini") {
        await EasyLoading.showError('${value.message!}',dismissOnTap: true);
        return;
      }
      await EasyLoading.showSuccess('${value.message!}',dismissOnTap: true);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => DetailLelang(id_lelang: widget.id_lelang))
      );
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Api.detailHistoryUser(widget.id_lelang, widget.id,widget.token).then((value){
      setState(() {
        historyUser = value.data!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 8,bottom: 8,left: 10,right: 10),
      child: Responsive(
        children: [
          Div(
            divison: const Division(
              colXS: 8,
              colS: 8,
              colM: 8,
              colL: 8
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 7,bottom: 5),
                  child: Text(
                    "Tawar barang ini dengan harga mu!!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controllerTawar,
                  inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(19),
                      CurrencyTextInputFormatter(
                        locale: 'ID',
                        decimalDigits: 0,
                        symbol: '(IDR) Rp. ',
                      ),
                  ],
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Tawar",
                    hintStyle: TextStyle(
                      color: Colors.white
                    ),
                    fillColor: Color.fromARGB(153, 148, 148, 148),
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white54),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white70),
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 7,bottom: 5,top: 5),
                  child: Text(
                    "Penawaran mu sekarang",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 7,bottom: 5),
                  child: Text(
                    // "Rp.${currencyFormatter.format((historyUser.isEmpty ? 0 : (historyUser[0].penawaranHarga)))}",
                    "Rp.${currencyFormatter.format((historyUser.isEmpty ? 0 : int.parse(historyUser[0].penawaranHarga!)))}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w300
                    ),
                  ),
                ),
              ],
            ),
          ),
          Div(
            divison: const Division(
              colXS: 4,
              colS: 4,
              colM: 4,
              colL: 4
            ),
            child: SizedBox(
              height: 125,
              child: Container(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => tawar(context),
                  child: Text(
                    'Tawar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22  
                    ),
                  ),
                  style: ButtonStyle(
                    fixedSize: MaterialStateProperty.all(Size(200, 50)),
                    backgroundColor: MaterialStateProperty.all(Color.fromARGB(255, 83, 142, 219)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                                color: Colors.teal, 
                                width: 2.0,
                            ),
                        ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}