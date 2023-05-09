// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/app_bar.dart';
import 'package:student_management/components/profile_details.dart';
import 'package:student_management/components/profile_header.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

class IndividualAttendanceScreen extends StatefulWidget {
  final String studentCode;
  final String date1;
  final String date2;
  const IndividualAttendanceScreen(
      {required this.studentCode,
      required this.date1,
      required this.date2,
      super.key});

  @override
  State<IndividualAttendanceScreen> createState() =>
      _IndividualAttendanceScreenState();
}

class _IndividualAttendanceScreenState
    extends State<IndividualAttendanceScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
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
      getStudentsData();
    });
  }

  getStudentsData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _loading = true;
      userName =
          "${prefs.getString('first_name')} ${prefs.getString('last_name')}";
      grade = "${prefs.getString('class')} ${prefs.getString('name')}";
    });

    var data = {
      "date1": widget.date1,
      "date2": widget.date2,
      "student_code": widget.studentCode
    };

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

    final res =
        await individualAttendanceForStudent(data, prefs.getString('token'));

    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      final responseData = jsonDecode(res.body);

      Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['token']);
        debugPrint("individualAttendanceForStudent Data ********* $data");
      setState(() {
        attendanceDates = data['attendance_data'];
      });
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

  forenoonOrAfternoon(value, text, markedStatus) {
    if (markedStatus == "0") {
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
    Size size = MediaQuery.of(context).size;
    // ignore: prefer_const_constructors
    return SafeArea(
      top: true,
      child: Scaffold(
        key: key,
        appBar: AppBar(title: const Text("Individual Attendance")),
        body: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: <Widget>[
            /* const ProfileHeader(
                imageUrl: "assets/images/studentProfile.png",
                name: "Student 1",
                grade: "VIII A"), */
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
                              /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        IndividualAttendanceScreen(
                                          studentCode: attendanceDates[index]
                                              ['student_code'],
                                          date1: widget.date1,
                                          date2: widget.date2,
                                        )),
                              ); */
                            },
                            child: Card(
                              borderOnForeground: true,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 15),
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(
                                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      //const SizedBox(width: 30),
                                      SizedBox(
                                        width: 90,
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                              "${attendanceDates[index]["date"]}"),
                                        ),
                                      ),
                                      const SizedBox(width: 30),
                                      forenoonOrAfternoon(
                                          attendanceDates[index]["absent_FN"],
                                          "FN",
                                          attendanceDates[index]["marked"]),
                                     // const SizedBox(width: 5),
                                      forenoonOrAfternoon(
                                          attendanceDates[index]["absent_AN"],
                                          'AN',
                                          attendanceDates[index]["marked"]),
                                    ],
                                  )),
                            ),
                          );
                        })
                    : const Center(child: Text("Loading...")),
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
