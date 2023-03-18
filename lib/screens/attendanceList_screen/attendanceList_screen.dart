import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:student_management/components/banner.dart';
import 'package:student_management/components/calender.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/individual_attendance_screen/individual_attendance_screen.dart';
import 'package:student_management/screens/single_day_attendance/single_day_attendance.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Initial Selected Value
    String dropdownvalue = 'Class 1';

    // List of items in our dropdown menu
    var items = [
      'Class 1',
      'Class 2',
      'Class 3',
      'Class 4',
      'Class 5',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance List"),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const CommonBanner(
                imageUrl: "assets/images/profile.png",
                name: "Test Teacher",
                grade: "VIIIA"),
            const SizedBox(height: 10),
            Row(
              children: <Widget>[
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(size.width * 0.03),
                  height: 40,
                  width: size.width * 0.60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                    border: Border.all(
                      style: BorderStyle.solid,
                      width: 2.0,
                      color: primaryColor,
                    ),
                  ),
                  child: DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    isExpanded: true,
                    alignment: Alignment.bottomCenter,
                    dropdownColor: Colors.white,
                    underline: const SizedBox(),
                    elevation: 16,
                    style: const TextStyle(color: Colors.black87),
                    // Array list of items
                    items: items.map((String items) {
                      return DropdownMenuItem(
                        value: items,
                        child: Text(items),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
                const Spacer()
              ],
            ),
            const SizedBox(height: 10),
            const AttendanceListCalender()
          ],
        ),
      ),
    );
  }
}
