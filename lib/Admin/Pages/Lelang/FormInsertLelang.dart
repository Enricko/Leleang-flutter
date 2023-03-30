import 'dart:convert';
import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
// import 'dart:html';
import 'package:image_picker/image_picker.dart' if(kIsWeb) 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:responsive_ui/responsive_ui.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Home.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/ComponentLib/SharedPref.dart';

class FormInsertLelang extends StatefulWidget {
  const FormInsertLelang({super.key});

  @override
  State<FormInsertLelang> createState() => _FormInsertLelangState();
}

class _FormInsertLelangState extends State<FormInsertLelang> {
  bool isVisibility = true;
  final List<Map<String, dynamic>> _items = [
    {
      'value': 'Petugas',
    },
    {
      'value': 'Administrasi',
    },
  ];

  File? pickedImage;
  Uint8List webImage = Uint8List(8);
  String? baseImage;

  /// Widget
  Future<void> _pickImage()async{
    final ImagePicker imagePicker = ImagePicker();
    var choosedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    var f = await choosedImage!.readAsBytes();
    setState(() {
      webImage = f;
      pickedImage = File(choosedImage.path);
    });
    // if(!kIsWeb){
    //   final ImagePicker _picker = ImagePicker();
    //   XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    //   if(image != null){
    //     var f = await image.readAsBytes();
    //     var selected = File(image.path);
    //     setState(() {
    //       webImage = f;
    //       pickedImage = selected;
    //     });
    //   }else{
    //     print('No image has been selected');
    //   }
    // }else if(kIsWeb){
    //   final ImagePicker _picker = ImagePicker();
    //   XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    //   if(image != null){
    //     var f = await image.readAsBytes();
    //     var selected = File(image.path);
    //     setState(() {
    //       webImage = f;
    //       pickedImage = File('a');
    //       pickedImage = selected;
    //     });
    //   }else{
    //     print('No image has been selected');
    //   }
    // }else{
    //   print('Something went wrong!!');
    // }
  }

  TextEditingController controllerNamaBarang = TextEditingController();
  TextEditingController controllerHargaAwal= TextEditingController();
  TextEditingController controllerLamaLelang = TextEditingController();
  TextEditingController controllerDeskripsiBarang = TextEditingController();

  submit(BuildContext context) async{
    var NamaBarang = controllerNamaBarang.text;
    var HargaAwal = controllerHargaAwal.text;
    var LamaLelang = controllerLamaLelang.text;
    var DeskripsiBarang = controllerDeskripsiBarang.text;
    var dataUser = await Pref.getPref();
    String token = dataUser.token!;
    // print(HargaAwal);
    try{
      if(!kIsWeb){
        List<int> imageBytes = pickedImage!.readAsBytesSync();
        String baseImage = base64Encode(imageBytes);
      }
    }catch(e){
      print('Error During Converting to Base64');
    }

    var data = {
      'nama_barang': NamaBarang,
      'harga_awal': HargaAwal,
      'deskripsi_barang': DeskripsiBarang,
      'lama_lelang': LamaLelang,
    };
    Api.insertLelang(data,baseImage,webImage,token).then((value) async{
      if(value.message == null){
        //muncul error
        await EasyLoading.showError('Something Went Wrong',dismissOnTap: true);
        return;
      }
      await EasyLoading.showSuccess(value.message!,dismissOnTap: true);
      Navigator.pushReplacement(context, 
        MaterialPageRoute(builder: (context)=> adminMain(page: 4)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Card(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Buka Lelang',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600
                ),
              ),
              SizedBox(height: 25),
              Container(
                margin: EdgeInsets.only(bottom: 15),
                child: Responsive(
                  children: [
                    Container(
                      child: GestureDetector(
                        onTap: _pickImage,
                        child: DottedBorder(
                          borderType: BorderType.RRect,
                          radius: Radius.circular(12),
                          padding: EdgeInsets.all(6),
                          strokeWidth: 2,
                          color: Colors.white,
                          child: ClipRRect(
                            child: pickedImage == null
                              ? Image.asset('image/tambahan/image_placeholder.png',width: 200,height: 200, fit: BoxFit.cover)
                              : kIsWeb ? Image.memory(webImage,fit: BoxFit.cover,width: 200,height: 200,)
                              : Image.file(pickedImage!,fit: BoxFit.cover,width: 200,height: 200,),
                          ),
                        ),
                      ),
                    ),
                    Div(
                      divison: Division(
                        colXS: 12,
                        colS: 12,
                        colM: 12,
                        colL: 8,
                        colXL: 8,
                      ),
                      child: Responsive(
                        children: [
                          Container(
                            margin: EdgeInsets.only(left: 10,right: 5),
                            child: Text(
                              "Select Image Barang Lelang",
                              style: TextStyle(
                                fontSize: 20
                              ),
                            ),
                          ),
                          Text(
                            "#Only Android/Ios/Website only",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                child: TextFormField(
                  keyboardType: TextInputType.name,
                  controller: controllerNamaBarang,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Nama Barang",
                    labelText: "Nama Barang",
                    hintStyle: TextStyle(
                      color: Colors.black
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800
                    ),
                    fillColor: Colors.white60,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white54),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white70),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controllerHargaAwal,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Harga Awal",
                    labelText: "Harga Awal",
                    hintStyle: TextStyle(
                      color: Colors.black
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800
                    ),
                    fillColor: Colors.white60,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white54),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white70),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                child: TextFormField(
                  // keyboardType: TextInputType.number,
                  keyboardType: TextInputType.datetime,
                  controller: controllerLamaLelang,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Lama Lelang",
                    labelText: "Lama Lelang",
                    hintStyle: TextStyle(
                      color: Colors.black
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800
                    ),
                    fillColor: Colors.white60,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white54),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white70),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 7),
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  controller: controllerDeskripsiBarang,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(15),
                    hintText: "Deskripsi Barang",
                    labelText: "Deskripsi Barang",
                    hintStyle: TextStyle(
                      color: Colors.black
                    ),
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800
                    ),
                    fillColor: Colors.white60,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white54),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.white70),
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => submit(context),
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 10),
                    padding: EdgeInsets.symmetric(horizontal:15,vertical: 10),
                    decoration: BoxDecoration(
                      color:Colors.blueAccent ,
                      borderRadius: BorderRadius.circular(25)
                    ),
                    child: Text(
                      "Submit",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}