import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/tile.dart';
import 'package:student_management/screens/attendanceList_screen/attendanceList_screen.dart';
import 'package:student_management/screens/attendance_screen/attendance_screen.dart';
import 'package:student_management/screens/nothing_screen/nothing_screen.dart';
import 'package:student_management/screens/teachers_profile_screen/teachers_profile_screen.dart';
import 'package:student_management/screens/students_list_screen/students_list_screen.dart';
import 'package:student_management/components/banner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../message/chat_select.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String userName = "";
  String grade = "";
  String userType = "";

  @override
  initState() {
    permission();
    getUserData();
    super.initState();
  }

  getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    userType = "${prefs.getString('user_type')}";
    print("=============> ============> ${prefs.getString("loginData")}");
    setState(() {
      userName =
          "${prefs.getString('first_name')} ${prefs.getString('last_name')}";
      grade = "${prefs.getString('class')} ${prefs.getString('name')}";
    });
  }

  permission() async {
    if (await Permission.storage.request().isGranted) {
    } else {
      Fluttertoast.showToast(
          msg: "File acess permission Not granted",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 300,
          // toastDuration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CommonBanner(
            imageUrl: "assets/images/teacher.png",
            name: userName,
            grade: grade,
            showDiv: true,
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Tile(
                      label: "Attendance List",
                      image: "assets/images/attendance_list.png",
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AttendanceList()),
                        );
                      },
                    ),
                    SizedBox(width: size.width * 0.029),
                    userType == "ADMIN"
                        ? Tile(
                            label: "Broadcast Messages",
                            image: "assets/images/config.png",
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChatSelect()),
                              );
                            },
                          )
                        : Tile(
                            label: "Add Attendance",
                            image: "assets/images/attendance.png",
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const AttendanceScreen(
                                          grade: 'null',
                                        )),
                              );
                            },
                          ),
                    SizedBox(width: size.width * 0.029),
                    Tile(
                      label: "Profile",
                      image: "assets/images/profile.png",
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const TeachersProfileScreen()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: size.width * 0.030),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Tile(
                      label: "Students List",
                      image: "assets/images/student_list.png",
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const StudentsListScreen()),
                        );
                      },
                    ),
                    SizedBox(width: size.width * 0.029),
                    Tile(
                      label: "Calendar",
                      image: "assets/images/calendar.png",
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Nothing()),
                        );
                      },
                    ),
                    SizedBox(width: size.width * 0.029),
                    Tile(
                      label: "Reports",
                      image: "assets/images/report.png",
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Nothing()),
                        );
                      },
                    ),
                  ],
                ),
                SizedBox(height: size.width * 0.030),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Tile(
                      label: "Exams",
                      image: "assets/images/exam.png",
                      onClick: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Nothing()),
                        );
                      },
                    ),
                    SizedBox(width: size.width * 0.029),
                    userType != "ADMIN"
                        ? Tile(
                            label: "Broadcast Messages",
                            image: "assets/images/config.png",
                            onClick: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const ChatSelect()),
                              );
                            },
                          )
                        : SizedBox(width: size.width * 0.29),
                    SizedBox(width: size.width * 0.029),//Spacing between tile don't change
                    SizedBox(
                      width: size.width * 0.29,
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: size.height * 0.1,
          ),
        ],
      ),
    );
  }
}
