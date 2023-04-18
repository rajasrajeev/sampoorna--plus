// ignore_for_file: use_build_context_synchronously

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
  String token = "";

  @override
  void initState() {
    super.initState();
    permission();
  }

  getUserLoggin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      token = "${prefs.getString('token')}";
    });
    if (token != "null") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginScreen(passedRoles: "",),
        ),
      );
    }
  }

  permission() async {
    if (await Permission.storage.request().isGranted) {
      Timer(
        const Duration(seconds: 2),
        () => getUserLoggin(),
      );
    } else {
      Timer(
        const Duration(seconds: 2),
        () => getUserLoggin(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: UpgradeAlert(
        upgrader: Upgrader(
          durationUntilAlertAgain: const Duration(days: 1),
          dialogStyle: Platform.isIOS
              ? UpgradeDialogStyle.cupertino
              : UpgradeDialogStyle.material,
          canDismissDialog: true,
          shouldPopScope: () => true,
        ),
        child: Column(
          children: <Widget>[
            const Spacer(),
            Image.asset("assets/images/sampoorna.png"),
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
