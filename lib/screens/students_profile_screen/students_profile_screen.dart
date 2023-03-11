// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/app_bar.dart';
import 'package:student_management/components/profile_details.dart';
import 'package:student_management/components/profile_header.dart';
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
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        children: <Widget>[
          const ProfileHeader(
              imageUrl: "assets/images/profile.png",
              name: "Student 1",
              grade: "VIII A"),
          Center(
            child: Column(
              children: <Widget>[
                ProfileDetails(
                    title: "Full Name",
                    value: studentDetail['personal_details']['full_name']),
                ProfileDetails(
                    title: "Admission No",
                    value: studentDetail['personal_details']['admission_no']),
                ProfileDetails(
                    title: "Gender",
                    value: studentDetail['personal_details']['gender']),
                ProfileDetails(
                    title: "School Name",
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
