// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/banner.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/individual_attendance_screen/individual_attendance_screen.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

class SingleDayAttendanceScreen extends StatefulWidget {
  final String date;
  final String batchId;
  final String schoolId;
  const SingleDayAttendanceScreen(
      {required this.batchId,
      required this.schoolId,
      required this.date,
      super.key});

  @override
  State<SingleDayAttendanceScreen> createState() =>
      _SingleDayAttendanceScreenState();
}

class _SingleDayAttendanceScreenState extends State<SingleDayAttendanceScreen> {
  dynamic attendanceDates = [];

  @override
  void initState() {
    super.initState();
    getStudentsData(widget.date, widget.schoolId, widget.batchId);
  }

  getStudentsData(String date, String schoolId, String batchId) async {
    final prefs = await SharedPreferences.getInstance();

    showDialog(
        // Thed user CANNOT close this dialog  by pressing outsite it
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

    final res = await attendanceOnDate(date, schoolId, batchId);

    if (res.statusCode == 200) {
      final responseData = jsonDecode(res.body);
      Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['data']);
      setState(() {
        attendanceDates = data['token'];
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
                        itemCount: attendanceDates.length,
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
                                      /* Text(
                                          "${attendanceDates["$index"]["full_name"]}"), */
                                      /* const SizedBox(width: 20),
                                      const Text("IX A"),
                                      const SizedBox(width: 20),
                                      const Text("02/07/2022") */
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
