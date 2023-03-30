import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/ComponentLib/SharedPref.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/Home.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/Login.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/Profile.dart';

import 'ComponentLib/Components.dart';
import 'Pages/Auction.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lelang',
      theme: ThemeData(
        canvasColor: Color.fromRGBO(65, 65, 65, 1.0),
        primarySwatch: Colors.blueGrey,
        textTheme: Theme.of(context).textTheme.apply(  //  Set default Text() color;  Use:  apply()
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        cardColor: Color.fromARGB(255, 85, 85, 85),
      ),
      builder: EasyLoading.init(),
      scrollBehavior: MyCustomScrollBehavior(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, this.page = 1});
  final int page;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> onTapRouteBar = [AuctionPage(),HomePage(),LoginPage()];
  int selectedIndex = 1;
  String? id;
  String? name;
  String? level;
  String? token;

  Future<void> userCheck()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id_pref = prefs.getString('id');
    var name_pref = prefs.getString('name');
    if (id_pref == null) {
      // Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute(builder: (context) => Login()));
    }else{
      var DataUser = await Pref.getPref();
      // print(prefs.getString('name'));
      setState(() {
        id = DataUser.id;
        name = DataUser.name;
        token = DataUser.token;
        onTapRouteBar = [AuctionPage(),HomePage(),ProfilePage()];
      });
    }
  }
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userCheck();
    selectedIndex = widget.page;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Lelang'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        child: onTapRouteBar[selectedIndex]
      ),
      bottomNavigationBar: ConvexAppBar(
        initialActiveIndex: widget.page,
        items: const [
          TabItem(icon: Icons.account_balance, title: 'Auction'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        onTap: (int i) => onItemTapped(i),
      ),
    );
  }
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }
}

// class ImageUpload extends StatefulWidget{
//   @override
//   State<StatefulWidget> createState() {
//     return _ImageUpload();
//   }
// }

// class _ImageUpload extends State<ImageUpload>{

//   final ImagePicker imagePicker = ImagePicker();
//   File? uploadimage;
//   Uint8List webImage = Uint8List(8);

//   Future<void> chooseImage()async{
//     var choosedImage = await imagePicker.pickImage(source: ImageSource.gallery);
//     // if (kIsWeb) {
//     // }
//     var f = await choosedImage!.readAsBytes();
//     setState(() {
//       webImage = f;
//       uploadimage = File(choosedImage.path);
//     });
//   }

//   Future<void> uploadImage()async{
//     var uploadUrl = Uri.parse("http://127.0.0.1:8000/api/test");
//     try{
//       if(!kIsWeb){
//         List<int> imageBytes = uploadimage!.readAsBytesSync();
//         String baseImage = base64Encode(imageBytes);
//         var response = await http.post(uploadUrl,body: {'image': baseImage});
//         if(response.statusCode == 200){
//           var jsondata = json.decode(response.body);
//           if(jsondata['error']){
//             print(jsondata['data']);
//           }else{
//             print('Upload Succesfully');
//           }
//         }else{
//           print('Error during connection to server.');
//         }
//       }else if(kIsWeb){
//         var request = http.MultipartRequest("POST",uploadUrl);
//         request.files.add(http.MultipartFile.fromBytes('image', webImage,contentType: MediaType('application','octet-stream'), filename: 'myImage.png'));
//         request.send().then((response) => {
//           if(response.statusCode == 200){
//             response.stream.transform(utf8.decoder).listen((value) {
//               print(value);
//             })
//           }else{
//             print('File Uploaded Failed')
//           }
//         });
//       }
//     }catch(e){
//       print('Error During Converting to Base64');
//     }
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//          appBar: AppBar(
//            title: Text("Upload Image to Server"),
//            backgroundColor: Colors.deepOrangeAccent,
//          ),
//          body:Container(
//              height:300,
//              alignment: Alignment.center,
//              child:Column(
//                     mainAxisAlignment: MainAxisAlignment.center, //content alignment to center 
//                     children: [
//                         // Container(  //show image here after choosing image
//                         //     child:uploadimage == null? 
//                         //        Container(): //if uploadimage is null then show empty container
//                         //        Container(   //elese show image here
//                         //           child: SizedBox( 
//                         //              height:150,
//                         //              child:Image.network("$uploadimage") //load image from file
//                         //           )
//                         //        )
//                         // ),

//                         // Container( 
//                         //     //show upload button after choosing image
//                         //   child:uploadimage == null? 
//                         //        Container(): //if uploadimage is null then show empty container
//                         //        Container(   //elese show uplaod button
//                         //           child:ElevatedButton.icon(
//                         //             onPressed: (){
//                         //                 uploadImage();
//                         //                 //start uploading image
//                         //             }, 
//                         //             icon: Icon(Icons.file_upload), 
//                         //             label: Text("UPLOAD IMAGE"),
//                         //             // color: Colors.deepOrangeAccent,
//                         //             // colorBrightness: Brightness.dark,
//                         //             //set brghtness to dark, because deepOrangeAccent is darker coler
//                         //             //so that its text color is light
//                         //           )
//                         //        ) 
//                         // ),
//                         uploadimage != null ?
//                         kIsWeb ? 
//                         Image.memory(webImage,width: 200,height: 200):
//                         Image.file(uploadimage!,width: 200,height: 200):
//                         Container(),

//                         Container(
//                           child: ElevatedButton.icon(
//                             onPressed: (){
//                                 chooseImage(); // call choose image function
//                             },
//                             icon:Icon(Icons.folder_open),
//                             label: Text("CHOOSE IMAGE"),
//                             // color: Colors.deepOrangeAccent,
//                             // colorBrightness: Brightness.dark,
//                           ),
//                         ),
//                         Container(
//                           child: ElevatedButton.icon(
//                             onPressed: (){
//                                 uploadImage(); // call choose image function
//                             },
//                             icon:Icon(Icons.folder_open),
//                             label: Text("UPLOAD IMAGE"),
//                             // color: Colors.deepOrangeAccent,
//                             // colorBrightness: Brightness.dark,
//                           ),
//                         )
//               ],),
//           ),
//     );
//   }
// }