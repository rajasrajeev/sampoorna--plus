import 'package:flutter/material.dart';
import 'package:student_management/components/tile.dart';
import 'package:student_management/screens/attendanceList_screen/attendanceList_screen.dart';
import 'package:student_management/screens/attendance_screen/attendance_screen.dart';
import 'package:student_management/screens/nothing_screen/nothing_screen.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  initState() {
    permission();
    super.initState();
  }

  permission() async {
    if (await Permission.storage.request().isGranted) {
     // openAppSettings();
      // Either the permission was already granted before or the user just granted it.
      // ignore: use_build_context_synchronously
      Fluttertoast.showToast(
          msg: "File acess permission granted",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 300,
          // toastDuration: Duration(seconds: 2),
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Tile(
                  label: "Configure",
                  image: "assets/images/config.png",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Nothing()),
                    );
                  },
                ),
                Tile(
                  label: "Attendance",
                  image: "assets/images/attendance.png",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AttendanceScreen()),
                    );
                  },
                ),
                Tile(
                  label: "Exams",
                  image: "assets/images/exam.png",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Nothing()),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Tile(
                  label: "Calendar",
                  image: "assets/images/calendar.png",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Nothing()),
                    );
                  },
                ),
                Tile(
                  label: "Reports",
                  image: "assets/images/report.png",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Nothing()),
                    );
                  },
                ),
                Tile(
                  label: "Profile",
                  image: "assets/images/profile.png",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Nothing()),
                    );
                  },
                ),
                
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Tile(
                  label: "Attendance List",
                  image: "assets/images/attendance.png",
                  onClick: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AttendanceList()),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
