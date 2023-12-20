// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/profile_details.dart';
import 'package:student_management/components/profile_header.dart';
import 'package:student_management/services/jwt_token_parser.dart';
import 'package:student_management/services/api_services.dart';

class TeachersProfileScreen extends StatefulWidget {
  const TeachersProfileScreen({super.key});

  @override
  State<TeachersProfileScreen> createState() => _TeachersProfileScreenState();
}

class _TeachersProfileScreenState extends State<TeachersProfileScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  dynamic? teachersProfile = {};
  String grade = "";
  String school_id = "";

  @override
  void initState() {
    getTeachersProfile();
    super.initState();
  }

  getTeachersProfile() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      grade = "${prefs.getString('class')} ${prefs.getString('name')}";
      school_id = "${prefs.getString('school_id')}";
    });
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

    final res = await teacherProfile(prefs.getString('user_id'));
    final responseData = jsonDecode(res.body);

    if (res.statusCode == 200) {
      Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['data']);
      setState(() {
        teachersProfile = data['token'][0];
      });
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
    return SafeArea(
      top: true,
      child: Scaffold(
        key: key,
        appBar: AppBar(title: const Text("Teacher's Profile")),
        body: Column(
          children: <Widget>[
            ProfileHeader(
                imageUrl: "assets/images/teacher.png",
                name:
                    "${teachersProfile['first_name']} ${teachersProfile['last_name']}",
                grade: grade),
            Center(
              child: Column(
                children: <Widget>[
                  ProfileDetails(
                      title: "First Name",
                      value: "${teachersProfile['first_name']}"),
                  ProfileDetails(
                      title: "Last Name",
                      value: "${teachersProfile['last_name']}"),
                  ProfileDetails(
                      title: "Email", value: "${teachersProfile['email']}"),
                  ProfileDetails(title: "School ID", value: school_id),
                ],
              ),
            ),
            Center()
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
