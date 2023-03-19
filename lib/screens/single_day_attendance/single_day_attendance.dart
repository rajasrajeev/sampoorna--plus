import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/banner.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/individual_attendance_screen/individual_attendance_screen.dart';

class SingleDayAttendanceScreen extends StatefulWidget {
  final String date;
  const SingleDayAttendanceScreen({required this.date, super.key});

  @override
  State<SingleDayAttendanceScreen> createState() =>
      _SingleDayAttendanceScreenState();
}

class _SingleDayAttendanceScreenState extends State<SingleDayAttendanceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance of Students")),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const CommonBanner(
                imageUrl: "assets/images/profile.png",
                name: "Test Teacher",
                grade: "VIIIA"),
            const SizedBox(height: 10),
            Text("${widget.date}"),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                        // the number of items in the list
                        itemCount: 10,
                        shrinkWrap: true,
                        // display each item of the product list
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const IndividualAttendanceScreen()),
                              );
                            },
                            child: Card(
                              // In many cases, the key isn't mandatory
                              // key: ValueKey(myProducts[index]),
                              borderOnForeground: true,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                    children: [
                                      Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          alignment: Alignment.center,
                                          child: Image.asset(
                                              "assets/images/profile.png")),
                                      const SizedBox(width: 30),
                                      const Text("Ram"),
                                      const SizedBox(width: 20),
                                      const Text("IX A"),
                                      const SizedBox(width: 20),
                                      const Text("02/07/2022")
                                    ],
                                  )),
                            ),
                          );
                        }),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
