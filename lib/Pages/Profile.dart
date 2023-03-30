import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Home.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Admin/Pages/LaporanPrint.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/Api.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiLelang.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Api/ApiGetUser.dart' as ApiGetUser;
import 'package:tampilan_lelang_ukk_jan_29_2023/ComponentLib/SharedPref.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/Pages/ViewAll.dart';
import 'package:tampilan_lelang_ukk_jan_29_2023/main.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String? id;
  String? name;
  String? level;
  String? token;
  String lelangCount = '0';
  String menangCount = '0';
  Future<ApiGetUser.ApiGetUser>? userProfile;

  Future<void> userCheck()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var id_pref = prefs.getString('id');
    var name_pref = prefs.getString('name');
    if (id_pref == null) {
      Navigator.pop(context);
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => MyHomePage(page: 2,)));
      return;
    }
    var DataUser = await Pref.getPref();
    setState(() {
      id = id_pref;
      name = DataUser.name;
      level = DataUser.level;
      token = DataUser.token;
    });
    Api.userLelang(id!, token!,"status=dibuka").then((value){
      setState(() {
        lelangCount = value.count!.toString();
      });
    });
    Api.userLelang(id!, token!,"status=ditutup").then((value){
      setState(() {
        menangCount = value.count!.toString();
      });
    });
    userProfile = Api.getUser(token!);
  }
  @override
  void initState() {
    userCheck();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userProfile,
      builder: (context, AsyncSnapshot<ApiGetUser.ApiGetUser> snapshot) {
        if(snapshot.hasData){
          return User(context,snapshot.data!.data!);
        }
        if(snapshot.hasData){
          return Center(
            child: Text("Something Went Wrong ${snapshot.hasError}"),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Container User(BuildContext context, List<ApiGetUser.Data> userProfile){
    return Container(
    margin: EdgeInsets.symmetric(vertical: 50),
    alignment: Alignment.center,
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
        ),
        child: Card(
          elevation: 10, 
          shadowColor: Colors.black, 
          child: Container(
            margin: EdgeInsets.all(25),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'image/tambahan/download.jpeg',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
                Text(
                  '$name'.toUpperCase(),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  width: 275,
                  child: Card(
                    color: Color.fromARGB(255, 124, 124, 124),
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              Text(
                                'Menang Lelang',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500
                                ),
                              ),
                              SizedBox(height: 3),
                              Text(
                                '$menangCount',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 236, 229, 229),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.email,color: Colors.white,size: 30,),
                          Text('${userProfile[0].email!}')
                        ],
                      ),
                      SizedBox(height: 5,),
                      userProfile[0].telp == null ? Container() :
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.smartphone,color: Colors.white, size: 30,),
                          Text('${userProfile[0].telp}')
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewAll(page:1,title: 'Lelang yang telah kamu menangi',id_user: int.parse(id!),))
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        'Lihat Semua Lelang Yang di Menangi'
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ViewAll(page:1,title: 'Lelang yang telah kamu ikuti',token: token!,))
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        'Lihat Semua Lelang Yang di Ikuti'
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                level == 'masyarakat' ?
                lelangCount != '' ?
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (context) => ViewAll(page:1,title: 'Tawaran saat ini',token: token!,))
                          ),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10)
                            ),
                            child: Text(
                              'Barang yang kamu tawar saat ini',
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 1,
                        right: 1,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(50)
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${lelangCount}',
                          ),
                        ),
                      )
                    ],
                  ),
                )
                :Container() : Container(),
                level != 'masyarakat' ?
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (context) => adminMain())
                    ),
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        'Go To Admin',
                      ),
                    ),
                  ),
                ) : Container(),
                SizedBox(height: 10,),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async{
                      await Pref.logout();
                      Navigator.pushReplacement(context,
                       MaterialPageRoute(builder: (context) => MyHomePage(page: 2,)));
                       EasyLoading.showError('You have been logout');
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)
                      ),
                      child: Text(
                        'Logout',
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    ),
  );
  }
}