// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/app_bar.dart';
import 'package:student_management/components/profile_details.dart';
import 'package:student_management/components/profile_header.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/main_screen/main_screen.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

import '../../constants.dart';

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
      appBar: AppBar(
        title: const Text("Profile"),
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
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: CurveImage(),
              child: Container(
                width: size.width,
                decoration:
                    BoxDecoration(color: Color.fromARGB(214, 242, 242, 242)),
                child: ProfileHeader(
                    imageUrl:
                        (studentDetail['personal_details']['gender'] == "Male")
                            ? "assets/images/boy.png"
                            : "assets/images/girl.png",
                    name: studentDetail['personal_details']['full_name'],
                    grade: studentDetail['current_details']['class'] +
                        studentDetail['current_details']['division']),
              ),
            ),
            SizedBox(height: size.height * 0.05),
            Center(
              child: Column(
                children: <Widget>[
                  ProfileDetails(
                      title: "FULL NAME",
                      value: studentDetail['personal_details']['full_name']),
                  ProfileDetails(
                      title: "ADMISSION NO",
                      value: studentDetail['personal_details']
                          ['admission_no']),
                  ProfileDetails(
                      title: "GENDER",
                      value: studentDetail['personal_details']['gender']),
                  ProfileDetails(
                      title: "SCHOOL NAME",
                      value: studentDetail['personal_details']
                          ['school_name']),
                  ProfileDetails(
                      title: "STUDENT CODE",
                      value: studentDetail['personal_details']
                          ['student_code']),
                  ProfileDetails(
                      title: "NATIONALITY",
                      value: studentDetail['personal_details']
                          ['nationality']),
                  ProfileDetails(
                      title: ("hostelite").toUpperCase(),
                      value: studentDetail['personal_details']['hostelite']),
                  SizedBox(height: size.height * 0.05),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(size.height*0.03),
                        child:  Text(
                      ("parent details").toUpperCase(),
                     ),
                      ),
                    ],
                  ),
                 
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(height: size.height * 0.05),
                  ProfileDetails(
                      title: ("Mothers name").toUpperCase(),
                      value: studentDetail['parent_details']
                          ['mother_full_name']),
                  ProfileDetails(
                      title: ("Fathers name").toUpperCase(),
                      value: studentDetail['parent_details']
                          ['father_full_name']),
                  ProfileDetails(
                      title: ("Guardian name").toUpperCase(),
                      value: studentDetail['parent_details']
                          ['guardian_name']),
                  ProfileDetails(
                      title: ("Guardian Relation").toUpperCase(),
                      value: studentDetail['parent_details']
                          ['guardian_relation']),
                  ProfileDetails(
                      title: ("Guardian Occupation").toUpperCase(),
                      value: studentDetail['parent_details']
                          ['guardian_occupation']),
                  ProfileDetails(
                      title: ("Guardian Income").toUpperCase(),
                      value: studentDetail['parent_details']
                              ['guardian_income']
                          .toString()),
                  ProfileDetails(
                      title: ("APL/BPL").toUpperCase(),
                      value: studentDetail['parent_details']['apl']),
                  SizedBox(height: size.height * 0.05),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(size.height*0.03),
                        child: Text(
                      ("current details").toUpperCase(),
                     ),
                      ),
                    ],
                  ),
                  
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(height: size.height * 0.05),
                  ProfileDetails(
                      title: ("class").toUpperCase(),
                      value: studentDetail['current_details']['class']),
                  ProfileDetails(
                      title: ("division").toUpperCase(),
                      value: studentDetail['current_details']['division']),
                  ProfileDetails(
                      title: ("physically challenged").toUpperCase(),
                      value: studentDetail['current_details']
                          ['physical_challenge']),
                  ProfileDetails(
                      title: ("medium name").toUpperCase(),
                      value: studentDetail['current_details']['medium_name']),
                  ProfileDetails(
                      title: ("first language ").toUpperCase(),
                      value: studentDetail['current_details']
                          ['first_language']),
                  ProfileDetails(
                      title: ("second language").toUpperCase(),
                      value: studentDetail['current_details']
                              ['second_language']
                          .toString()),
                  ProfileDetails(
                      title: ("third language").toUpperCase(),
                      value: studentDetail['current_details']
                          ['third_language']),
                  ProfileDetails(
                      title: ("additional language").toUpperCase(),
                      value: studentDetail['current_details']
                          ['additional_language']),
                  ProfileDetails(
                      title: ("midday meal").toUpperCase(),
                      value: studentDetail['current_details']['middaymeal']),
                  SizedBox(height: size.height * 0.05),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(size.height*0.03),
                        child: Text(
                      ("vaccination details").toUpperCase(),
                     ),
                      ),
                    ],
                  ),
                  
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(height: size.height * 0.05),
                  ProfileDetails(
                      title: ("vaccinated").toUpperCase(),
                      value: studentDetail['vaccination_details']
                          ['vaccinated']),
                  SizedBox(height: size.height * 0.05),
                  Row(
                    crossAxisAlignment:CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(size.height*0.03),
                        child: Text(
                         
                            ("additional details").toUpperCase(),
                           ),
                      ),
                    ],
                  ),
                  const Divider(
                    height: 10,
                    thickness: 1,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.grey,
                  ),
                  SizedBox(height: size.height * 0.05),
                  ProfileDetails(
                      title: ("mother tongue").toUpperCase(),
                      value: studentDetail['additional_details']['mother_tongue']),
                  ProfileDetails(
                      title: ("homeless").toUpperCase(),
                      value: studentDetail['additional_details']
                          ['homeless']),
                  ProfileDetails(
                      title: ("habitation").toUpperCase(),
                      value: studentDetail['additional_details']['habitation']),
                  ProfileDetails(
                      title: ("uniform sets").toUpperCase(),
                      value: studentDetail['additional_details']
                          ['uniform_sets']),
                  ProfileDetails(
                      title: ("free texts").toUpperCase(),
                      value: studentDetail['additional_details']
                              ['free_texts']
                          .toString()),
                  ProfileDetails(
                      title: ("transport").toUpperCase(),
                      value: studentDetail['additional_details']
                          ['transport']),
                  ProfileDetails(
                      title: ("escort").toUpperCase(),
                      value: studentDetail['additional_details']
                          ['escort']),
                  ProfileDetails(
                      title: ("hostel facility").toUpperCase(),
                      value: studentDetail['additional_details']['hostel_facility']),
                      ProfileDetails(
                      title: ("special facility").toUpperCase(),
                      value: studentDetail['additional_details']['special_facility']),
                      ProfileDetails(
                      title: ("identification mark 1").toUpperCase(),
                      value: studentDetail['additional_details']['identification_mark_1']),
                      ProfileDetails(
                      title: ("identification mark 2").toUpperCase(),
                      value: studentDetail['additional_details']['identification_mark_2']),
                  SizedBox(height: size.height * 0.05),
                  // const Divider(
                  //   height: 10,
                  //   thickness: 1,
                  //   indent: 20,
                  //   endIndent: 20,
                  //   color: Colors.black45,
                  // ),
                  SizedBox(height: size.height * 0.05),
                ],
              ),
            ),
            Center()
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}

class CurveImage extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0.0, size.height - 30);
    path.quadraticBezierTo(
        size.width / 4, size.height, size.width / 2, size.height);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height,
        size.width, size.height - 30);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
