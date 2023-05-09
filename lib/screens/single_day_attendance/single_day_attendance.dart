// ignore_for_file: use_build_context_synchronously, unrelated_type_equality_checks

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/individual_attendance_screen/individual_attendance_screen.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

class SingleDayAttendanceScreen extends StatefulWidget {
  final String date;
  final String batchId;
  final String schoolId;
  final String date1;
  final String date2;
  const SingleDayAttendanceScreen(
      {required this.batchId,
      required this.schoolId,
      required this.date,
      required this.date1,
      required this.date2,
      super.key});

  @override
  State<SingleDayAttendanceScreen> createState() =>
      _SingleDayAttendanceScreenState();
}

class _SingleDayAttendanceScreenState extends State<SingleDayAttendanceScreen> {
  int absentCount = 0;
  dynamic attendanceDates = [];
  bool _loading = false;
  String grade = "";
  String userName = "";
  String markedStatus = "";
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      getStudentsData(widget.date, widget.schoolId, widget.batchId);
    });
  }

  getStudentsData(String date, String schoolId, String batchId) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
      userName =
          "${prefs.getString('first_name')} ${prefs.getString('last_name')}";
      grade = "${prefs.getString('class')} ${prefs.getString('name')}";
    });

    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return Dialog(
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  CircularProgressIndicator(),
                  SizedBox(
                    height: 15,
                  ),
                  Text('Loading...')
                ],
              ),
            ),
          );
        });

    final res = await attendanceOnDate(date, schoolId, batchId);

    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      final responseData = jsonDecode(res.body);

      Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['data']);
        debugPrint("attendanceOnDate Data ********* $data");
      setState(() {
        attendanceDates = data['token'];
        markedStatus = data['markedStatus'];
      });

      for (var i = 0; i < attendanceDates.length; i++) {
        if (attendanceDates[i]["absent_FN"] == 1 ||
            attendanceDates[i]["absent_FN"] == "1" ||
            attendanceDates[i]["absent_AN"] == 1 ||
            attendanceDates[i]["absent_AN"] == "1") {
          absentCount++;
        }
      }
    } else {
      setState(() {
        _loading = false;
      });
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

  forenoonOrAfternoon(value, text) {
    if (markedStatus == "") {
      return Container(
          width: 35,
          height: 35,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 145, 149, 145),
              borderRadius: BorderRadius.circular(50)),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ));
    } else if (markedStatus == 1 || markedStatus == "1") {
      if (value == null || value == 0 || value == "0") {
        return Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 49, 115, 58),
                borderRadius: BorderRadius.circular(50)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ));
      } else {
        return Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(50)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ));
      }
    } else {
      if (value == null || value == 0 || value == "0") {
        return Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 49, 115, 58),
                borderRadius: BorderRadius.circular(50)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ));
      } else {
        return Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
                color: primaryColor, borderRadius: BorderRadius.circular(50)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(color: Colors.white),
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Attendance of Students"),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(
                  color: primaryColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 30),
                      Row(
                        children: [
                          Text("Date :${widget.date}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                              )),
                          const Spacer(),
                          Text(
                              "Total Absent :$absentCount/${attendanceDates.length}",
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: _loading == false && attendanceDates.length > 0
                          ? ListView.builder(
                              itemCount: attendanceDates.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              IndividualAttendanceScreen(
                                                studentCode:
                                                    attendanceDates[index]
                                                        ['student_code'],
                                                date1: widget.date1,
                                                date2: widget.date2,
                                              )),
                                    );
                                  },
                                  child: Card(
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
                                                      BorderRadius.circular(
                                                          15)),
                                              alignment: Alignment.center,
                                              child: attendanceDates[index]
                                                          ["photo_url"] ==
                                                      ""
                                                  ? Image.asset(
                                                      "assets/images/studentProfile.png")
                                                  : Image.memory(base64Decode(
                                                      attendanceDates[index]
                                                          ["photo_url"])),
                                            ),
                                            const SizedBox(width: 30),
                                            SizedBox(
                                              width: 90,
                                              height: 40,
                                              child: Center(
                                                child: Text(
                                                    "${attendanceDates[index]["full_name"]}"),
                                              ),
                                            ),
                                            const SizedBox(width: 30),
                                            forenoonOrAfternoon(
                                                attendanceDates[index]
                                                    ["absent_FN"],
                                                "FN"),
                                            const SizedBox(width: 5),
                                            forenoonOrAfternoon(
                                                attendanceDates[index]
                                                    ["absent_AN"],
                                                'AN'),
                                          ],
                                        )),
                                  ),
                                );
                              })
                          : const Center(child: Text("Loading...")),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
