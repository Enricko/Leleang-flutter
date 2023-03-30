import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiLelang.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/DetailLelang.dart';

import '../ComponentLib/Components.dart';

final List<String> imgList = [
  'image/lelang/palu.jpeg',
  'image/lelang/lelang1.jpeg',
];
final List<String> textSlider = [
  "Selamat Datang Di Lelang WEI.",
  "Lelang Terpercaya Se-Indonesia.",
];
final List<String> topList = [
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-nIVi5tIOdZXyrCWcc5M76F6QlfLR_VrEIQ&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBC1F66EwirdF6kpYfY7zb292dTYqeLjzLww&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTbJ6q6nCvC-F8ctwjE8F_gh176HK1p-EcKg&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhze-QNnca2liBrhRj4CjswGZSkqbhvSDJsQ&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrTFrhr_-pYR74jUgOy7IerAoHAX3zPIZZcg&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4qPmyou8HM0n-ia6ZoZYnSPZDyiyfE1Rxlw&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS-nIVi5tIOdZXyrCWcc5M76F6QlfLR_VrEIQ&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQBC1F66EwirdF6kpYfY7zb292dTYqeLjzLww&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQTbJ6q6nCvC-F8ctwjE8F_gh176HK1p-EcKg&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhze-QNnca2liBrhRj4CjswGZSkqbhvSDJsQ&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRrTFrhr_-pYR74jUgOy7IerAoHAX3zPIZZcg&usqp=CAU',
  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT4qPmyou8HM0n-ia6ZoZYnSPZDyiyfE1Rxlw&usqp=CAU',
];
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
final List<Widget> imageSliders = imgList
    .map((item) => Center(
      child: Container(
            child: Container(
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      Image.asset(
                        item, 
                        fit: BoxFit.cover,
                        height: double.infinity, 
                        width: double.infinity,
                        color: Colors.grey.withOpacity(0.5),
                        colorBlendMode: BlendMode.modulate,
                      ),
                      Positioned(
                        bottom: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(200, 0, 0, 0),
                                Color.fromARGB(0, 0, 0, 0)
                              ],
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: Text(
                              '${textSlider[imgList.indexOf(item)]}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )),
            ),
          ),
    ))
    .toList();
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final currencyFormatter = NumberFormat('#,000', 'ID');
  String? id;
  String? name;
  String? level;
  String? token;
  String? imageBarangPath;
  List<Data> lelang = [];
  List<Data> newLelang = [];
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Api.topLelang().then((value){
      setState(() {
        lelang = value.data!;
        imageBarangPath = value.imageBarangPath!;
      });
    });
    Api.newLelang('1').then((value){
      setState(() {
        newLelang = value.data!;
        imageBarangPath = value.imageBarangPath!;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Responsive(
        children: [
          Center(
            child: SizedBox(
              width: 1000,
              height: 250,
              child: CarouselSlider(
                options: CarouselOptions(
                  autoPlay: true,
                  aspectRatio: 2.0,
                  enlargeCenterPage: true,
                ),
                items: imageSliders,
              ),
            ),
          ),
          Div(
            divison: Division(
              colL: 12
            ),
            child: Container(
              margin: EdgeInsets.only(left: 25,top: 15),
              child: const Text(
                "Barang Paling Top",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 3,
            indent: 20,
            endIndent: 20, 
            color: Colors.black, 
            height: 20, 
          ),
          SizedBox(
            height: 200,
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView.builder(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: lelang.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var hargaLelang = lelang[index].barang!.hargaAkhir! == "" ? lelang[index].barang!.hargaAwal! : lelang[index].barang!.hargaAkhir!;
                  return GestureDetector(
                    onTap: () => 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailLelang(id_lelang: int.parse(lelang[index].idLelang!),))
                      ),
                    child: Card(
                      color: Color.fromARGB(255, 95, 95, 95),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 150,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  "$imageBarangPath${lelang[index].barang!.imageBarang!}",
                                  width: 100,
                                  height: 100,
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
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                capitalizeAllSentence("${lelang[index].barang!.namaBarang!}"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Rp.${currencyFormatter.format(int.parse(hargaLelang))}",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
          
              ),
            ),
          ),
          Div(
            divison: Division(
              colL: 12
            ),
            child: Container(
              margin: EdgeInsets.only(left: 25,top: 15),
              child: const Text(
                "Lelang Terbaru",
                textAlign: TextAlign.start,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          Divider(
            thickness: 3,
            indent: 20,
            endIndent: 20, 
            color: Colors.black, 
            height: 20, 
          ),
          SizedBox(
            height: 200,
            child: ScrollConfiguration(
              behavior: MyCustomScrollBehavior(),
              child: ListView.builder(
                physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                itemCount: newLelang.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  var hargaLelang = newLelang[index].barang!.hargaAkhir! == "" ? newLelang[index].barang!.hargaAwal! : newLelang[index].barang!.hargaAkhir!;
                  return GestureDetector(
                    onTap: () => 
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DetailLelang(id_lelang:int.parse(newLelang[index].idLelang!)))
                      ),
                    child: Card(
                      color: Color.fromARGB(255, 95, 95, 95),
                      child: Container(
                        margin: EdgeInsets.all(10),
                        child: SizedBox(
                          width: 150,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  "$imageBarangPath${newLelang[index].barang!.imageBarang!}",
                                  width: 100,
                                  height: 100,
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
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                capitalizeAllSentence("${newLelang[index].barang!.namaBarang!}"),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Rp.${currencyFormatter.format(int.parse(hargaLelang))}",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
          
              ),
            ),
          ),
        ],
      ),
    );
  }
}