import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/ComponentLib/SharedPref.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/DetailLelang.dart';

import '../Api/ApiLelang.dart';

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

class ViewAll extends StatefulWidget {
  const ViewAll({super.key,required this.title, required this.page ,this.id_user = 0,this.token = ''});
  final String title;
  final String token;
  final int page;
  final int id_user;

  @override
  State<ViewAll> createState() => _ViewAllState();
}

class _ViewAllState extends State<ViewAll> {
  final currencyFormatter = NumberFormat('#,000', 'ID');
  Future<ApiLelang>? allLelang;
  Map<String,String>? filter;
  String? token;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.title == "Lelang yang telah kamu ikuti"){
      allLelang = Api.ikutLelang(widget.page.toString(),widget.token,'');
    }else if(widget.title == 'Tawaran saat ini'){
      allLelang = Api.ikutLelang(widget.page.toString(),widget.token,'&status=dibuka');
    }else if(widget.title != "Lelang yang telah kamu ikuti" && widget.title != 'Tawaran saat ini'){
      filter = {
        'Lelang Terbaru' : 'status=dibuka&time=new',
        'History Lelang' : 'status=ditutup',
        'Lelang yang telah kamu menangi' : 'status=ditutup&user_id=${widget.id_user}',
      };
      allLelang = Api.pageLelang(widget.page.toString(),filter![widget.title]!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: allLelang,
      builder: (context, AsyncSnapshot<ApiLelang> snapshot){
        if(snapshot.hasData){
          return viewAllPage(context,snapshot.data!.data!,snapshot.data!.imageBarangPath!,(snapshot.data!.count! / 21).ceil());
        }
        if(snapshot.hasError){
          return Text('Something went wrong ${snapshot.error}');
        }
        return Center(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              Text('if you stuck here press back'),
              ElevatedButton(onPressed: (){
                Navigator.pop(context);
              }, 
              child: Text('< Back'))
            ],
          ),
        );
      },
    );
  }

  Scaffold viewAllPage(BuildContext context, List<Data> list,String imageBarangPath, int totalPage) {
    return Scaffold(
    appBar: AppBar(
      title: Text(capitalizeAllSentence(widget.title)),
    ),
    body: SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.all(15),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 10),
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 89, 121, 138),
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Text(
                      '1',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              thickness: 3,
              indent: 20,
              endIndent: 20, 
              color: Colors.black, 
              height: 20, 
            ),
            Responsive(
              children: [
                for(var i = 0; i < list.length; i++) 
                GestureDetector(
                  onTap: () => 
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DetailLelang(id_lelang: int.parse(list[i].idLelang!)))
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
                                "$imageBarangPath${list[i].barang!.imageBarang!}",
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
                              capitalizeAllSentence("${list[i].barang!.namaBarang!}"),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              "Rp.${currencyFormatter.format(int.parse(list[i].barang!.hargaAkhir! == "" ? list[i].barang!.hargaAwal! : list[i].barang!.hargaAkhir!))}",
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
                ),
              ],
            )
          ],
        ),
      ),
    ),
    bottomNavigationBar: Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.blueGrey
      ),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => widget.page <= 1 ? null : 
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAll(title: widget.title, page: widget.page - 1)))
                ,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  decoration: BoxDecoration(
                    color: widget.page <= 1 ? Color.fromARGB(255, 95, 95, 95) : Colors.grey,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Text(
                    '<',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
                child: ListView.builder(
                  itemCount: totalPage,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context,int index){
                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () => widget.page == index+1 ? null : null,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                            decoration: BoxDecoration(
                              color: widget.page == index+1 ? Color.fromARGB(255, 95, 95, 95) : Colors.grey,
                              borderRadius: BorderRadius.circular(50)
                            ),
                            child: Text(
                              '${index+1}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () => widget.page >= totalPage ? null :
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewAll(title: widget.title, page: widget.page + 1)))
                ,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  decoration: BoxDecoration(
                    color: widget.page >= totalPage ? Color.fromARGB(255, 95, 95, 95) : Colors.grey,
                    borderRadius: BorderRadius.circular(50)
                  ),
                  child: Text(
                    '>',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    ),
  );
  }
}