import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/screens/main_screen/main_screen.dart';
import 'package:upgrader/upgrader.dart';
import 'package:flutter/material.dart';
import 'package:student_management/screens/login_screen/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  String  token="";
  bool isLogedIn=true;
  @override
  void initState() {
     permission();

    Timer(
      const Duration(seconds: 4),
      () => Navigator.pushReplacement(
        context,
        isLogedIn?
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ):
         MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
      ),
    );

    super.initState();
  }


  getUserLoggin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
     token ="${prefs.getString('token')}";
    });
    if(token!="null"){
      isLogedIn=true;
    }
    else{
      isLogedIn=false;
    }
  }

  permission() async {
    if (await Permission.storage.request().isGranted) {
          getUserLoggin();
    } else {
      isLogedIn=false;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: UpgradeAlert(
        upgrader: Upgrader(
          durationUntilAlertAgain:const Duration(days: 1),
          dialogStyle:Platform.isIOS? UpgradeDialogStyle.cupertino:UpgradeDialogStyle.material,
          canDismissDialog: true,
          shouldPopScope: ()=>true,
         ),
        child: Column(
          children: <Widget>[
            const Spacer(),
            Image.asset("assets/images/sampoorna.png"),
            // const Text(
            //   "Student Management",
            //   style: TextStyle(fontSize: 24),
            // ),
            const Spacer(),
            const Text("V 1.0.0"),
            const SizedBox(height: 3),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: const Text(
                          'Powered by',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 147, 3, 113))),
                        child: Image.asset(
                          'assets/images/kite.jpg',
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
