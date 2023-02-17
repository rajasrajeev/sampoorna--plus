import 'package:flutter/material.dart';
import 'package:student_management/components/tile.dart';
import 'package:student_management/screens/attendance_screen/attendance_screen.dart';
import 'package:student_management/screens/nothing_screen/nothing_screen.dart';

class Body extends StatelessWidget {
  const Body({super.key});

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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
