import 'package:flutter/material.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:intl/intl.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/Auction/LelangHistory.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/Auction/LelangTerbaru.dart';

import 'DetailLelang.dart';
import 'ViewAll.dart';

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

class AuctionPage extends StatefulWidget {
  const AuctionPage({super.key});

  @override
  State<AuctionPage> createState() => _AuctionPageState();
}

class _AuctionPageState extends State<AuctionPage> {
  final currencyFormatter = NumberFormat('#,000', 'ID');
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          // My Current Action
          LelangTerbaru(currencyFormatter: currencyFormatter, context: context),
          SizedBox(
            height: 15,
          ),
          HistoryLelang(currencyFormatter: currencyFormatter, context: context)
          // My Current Action
        ],
      ),
    );
  }
}

