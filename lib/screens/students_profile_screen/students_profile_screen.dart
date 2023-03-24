// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/app_bar.dart';
import 'package:student_management/components/profile_details.dart';
import 'package:student_management/components/profile_header.dart';
import 'package:student_management/screens/main_screen/main_screen.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

class StudentsProfileScreen extends StatefulWidget {
  final String? studentCode;
  const StudentsProfileScreen({required this.studentCode, super.key});

  @override
  State<StudentsProfileScreen> createState() => _StudentsProfileScreenState();
}

class _StudentsProfileScreenState extends State<StudentsProfileScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  dynamic? studentDetail;

  @override
  void initState() {
    // TODO: implement initState
    getStudentDetails();
    super.initState();
  }

  getStudentDetails() async {
    final prefs = await SharedPreferences.getInstance();

    showDialog(
        // The user CANNOT close this dialog  by pressing outsite it
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Dialog(
            // The background color
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  // The loading indicator
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  // Some text
                  Text('Loading...')
                ],
              ),
            ),
          );
        });
    final res = await studentDetails(widget.studentCode);
    final responseData = jsonDecode(res.body);

    if (res.statusCode == 200) {
      //await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pop();
      // print("-=-===-=-=-=-=-=-=---=> ${responseData['data']}");
      var data = parseJwtAndSave(responseData['data']);
      // print(data);
      setState(() {
        studentDetail = data;
      });
      print("==================> ${studentDetail}");
    } else {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Unable to Sync Students List Now",
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ignore: prefer_const_constructors
    return Scaffold(
      key: key,
      appBar: AppBar(title: const Text("Profile"),
      elevation: 0,
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ),
                  );
                },
                child: const Icon(
                  Icons.home_filled,
                  size: 26.0,
                ),
              )
            ),
        ],
      ),
      body: Column(
        children: <Widget>[
           ProfileHeader(
              imageUrl:(studentDetail['personal_details']['gender']=="Male")? "assets/images/boy.png": "assets/images/girl.png",
              name: studentDetail['personal_details']['full_name'],
              grade: studentDetail['current_details']['class']+studentDetail['current_details']['division']),
          Center(
            child: Column(
              children: <Widget>[
                ProfileDetails(
                    title: "FULL NAME",
                    value: studentDetail['personal_details']['full_name']),
                ProfileDetails(
                    title: "ADMISSION NO",
                    value: studentDetail['personal_details']['admission_no']),
                ProfileDetails(
                    title: "GENDER",
                    value: studentDetail['personal_details']['gender']),
                ProfileDetails(
                    title: "SCHOOL NAME",
                    value: studentDetail['personal_details']['school_name']),
              ],
            ),
          ),
          Center()
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
