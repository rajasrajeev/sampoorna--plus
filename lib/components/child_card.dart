// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:student_management/components/student_profile_card.dart';
import 'package:student_management/components/tile_link.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/exams/exams.dart';
import 'package:student_management/screens/individual_attendance_screen/individual_attendance_screen.dart';
import 'package:student_management/screens/message/chat_detail.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

import '../screens/broadcast/broadcast_detail.dart';
import '../screens/message/chat_select.dart';
import 'package:intl/intl.dart';

class ChildCard extends StatefulWidget {
  final List day;
  final List date;
  final String fullName;
  final String grade;
  final String division;
  final String school;
  final String studentCode;
  final String admissionNo;
  final String schoolId;
  final String batchId;
  final String imageURL;
  const ChildCard({
    Key? key,
    required this.day,
    required this.date,
    required this.fullName,
    required this.grade,
    required this.division,
    required this.school,
    required this.studentCode,
    required this.admissionNo,
    required this.schoolId,
    required this.batchId,
    required this.imageURL,
  }) : super(key: key);

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  List attendanceData = [];
  bool loading = false;
  List status = [];

  @override
  void initState() {
    super.initState();
    getPastWeekAttendance();
  }

  getAttendanceStatus() {
    for (var i = 0; i < attendanceData.length; i++) {
      for (var j = 0;
          j < attendanceData[i]['last_week_attendance'].length;
          j++) {
        status.add({
          widget.studentCode: {
            'date': attendanceData[i]['last_week_attendance'][j]['date']
                        .split("-")[2] ==
                    widget.date[j]
                ? attendanceData[i]['last_week_attendance'][j]['date']
                    .split("-")[2]
                : widget.date[j],
            'fn': attendanceData[i]['last_week_attendance'][j]['marked'] == "0"
                ? const Color.fromARGB(255, 145, 149, 145)
                : attendanceData[i]['last_week_attendance'][j]['marked'] == "1"
                    ? const Color.fromARGB(255, 49, 115, 58)
                    : primaryColor,
            'an': attendanceData[i]['last_week_attendance'][j]['marked'] == "0"
                ? const Color.fromARGB(255, 145, 149, 145)
                : attendanceData[i]['last_week_attendance'][j]['marked'] == "2"
                    ? const Color.fromARGB(255, 49, 115, 58)
                    : primaryColor
          }
        });
      }
    }
    setState(() {
      loading = false;
    });
  }

  getPastWeekAttendance() async {
    setState(() {
      loading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    String? pastData = prefs.getString('pastWeekAttendance');
    // print("$pastData");

    /* if (prefs.getString('currentDate') ==
        DateFormat('dd-MM-yyyy').format(DateTime.now())) {
      var pastWeekAttendance = json.decode(pastData!);
      setState(() {
        attendanceData = pastWeekAttendance;
        loading = false;
      });
      return;
    } */

    var data = {
      "user_id": prefs.getString('user_id'),
    };

    final res = await lastWeekAttendance(data);

    if (res.statusCode == 200) {
      final responseData = jsonDecode(res.body);
      dynamic data = parseJwtAndSave(responseData['token'].toString());
      prefs.setString('currentDate',
          DateFormat('dd-MM-yyyy').format(DateTime.now()).toString());
      prefs.setString('pastWeekAttendance', json.encode(data['token']));
      setState(() {
        attendanceData = data['token'];
      });
      getAttendanceStatus();
    } else {
      setState(() {
        loading = true;
      });
      Fluttertoast.showToast(
        msg: "Unable to Sync Last Week Attendance!! Try again Later.",
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
    var montserrat = const TextStyle(
      fontSize: 12,
    );
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.7,
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(maxWidth: size.width * 0.9),
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(166, 142, 138, 138),
              spreadRadius: 1,
              blurRadius: 4,
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: AvatarClipper(),
                    child: Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 11,
                    top: 50,
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: primaryColor,
                          // ignore: unnecessary_null_comparison
                          backgroundImage: (widget.imageURL == null)
                              ? AssetImage(
                                  base64Decode(widget.imageURL).toString())
                              : const AssetImage(
                                  'assets/images/studentProfile.png'),
                          // child:(widget.imageURL =="")
                          //                       ? Image.memory(base64Decode(
                          //                           widget.imageURL))
                          //                       : Image.asset(
                          //                           "assets/images/studentProfile.png",
                          //                           fit: BoxFit.contain,
                          //                            height:100,
                          //                            width:100,
                          //                           ),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: size.width * 0.5,
                          //height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                child: Text(
                                  widget.fullName.toString(),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${widget.grade} ${widget.division}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              // mainAxisAlignment: MainAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.all(0.0),
                  child: Text(
                    widget.school,
                    style: buildMontserrat(
                      const Color(0xFF000000),
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.clip,
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /* Text(
                            "School Id",
                            style: montserrat,
                          ),
                          const SizedBox(height: 16), */
                          Text(
                            "Student Id",
                            style: montserrat,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Admission Number",
                            style: montserrat,
                          ),
                          /* const SizedBox(height: 16),
                          Text(
                            "Class",
                            style: montserrat,
                          ), */
                        ],
                      ),
                      const SizedBox(width: 5),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /* Text(
                            ":${widget.schoolId.toString()}",
                            style: montserrat,
                          ), */
                          /* const SizedBox(height: 16), */
                          Text(
                            ": ${widget.studentCode.toString()}",
                            style: montserrat,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            ": ${widget.admissionNo.toString()}",
                            style: montserrat,
                          ),
                          /* const SizedBox(height: 16),
                          Text(
                            ":${widget.grade.toString()}${widget.division.toString()}",
                            style: montserrat,
                          ), */
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.blue),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ChatDetail(
                                    batchId: widget.batchId,
                                    fullName:
                                        "${widget.grade} ${widget.division}",
                                    studentCode: widget.studentCode,
                                    studentName: widget.fullName,
                                  )),
                        )
                      },
                      icon: const Icon(
                        Icons.send_rounded,
                      ),
                      label: const Text(
                        'Messages',
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.blue),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExamsScreen()),
                        )
                      },
                      icon: const Icon(
                        Icons.history_edu,
                      ),
                      label: const Text(
                        'Exams',
                      ),
                    ),
                    /* TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.blue),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => IndividualAttendanceScreen(
                                  studentCode: widget.studentCode,
                                  date1: '01-02-2023',
                                  date2: '28-02-2023')),
                        )
                      },
                      icon: const Icon(
                        Icons.my_library_books_rounded,
                      ),
                      label: const Text(
                        'Attendance',
                      ),
                    ), */
                  ],
                ),
              ],
            ),
            SizedBox(height: size.height * 0.030),
            loading == false
                ? Container(
                    height: size.height * 0.15,
                    width: MediaQuery.of(context).size.width - 79,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black, width: 0.5)),
                    child: Row(children: [
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          width: (MediaQuery.of(context).size.width - 100) / 7,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // reverse: true,
                              itemCount: 7,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: size.height * 0.30,
                                  width:
                                      (MediaQuery.of(context).size.width - 80) /
                                          7,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    right: (index != 6)
                                        ? const BorderSide(
                                            color: Color.fromARGB(
                                                255, 105, 25, 25),
                                            width: 0.5,
                                          )
                                        : BorderSide.none,
                                  )),
                                  child: Column(children: [
                                    Container(
                                      height: size.height * 0.030,
                                      decoration: const BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  width: 0.5,
                                                  color: Colors.black))),
                                      child: Center(
                                          child: Text(
                                              widget.day[index].toString())),
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: index == 0
                                              ? const Radius.circular(0)
                                              : Radius.zero,
                                          bottomRight:
                                              index == widget.day.length - 1
                                                  ? const Radius.circular(0)
                                                  : Radius.zero,
                                        ),
                                      ),
                                      height: size.height * 0.070,
                                      child: Center(
                                        child: Text(
                                          widget.date[index].toString(),
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: index == 0
                                              ? const Radius.circular(5)
                                              : Radius.zero,
                                          bottomRight:
                                              index == widget.day.length - 1
                                                  ? const Radius.circular(5)
                                                  : Radius.zero,
                                        ),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Text(
                                              "FN",
                                              style: TextStyle(
                                                  color: status[index]
                                                          [widget.studentCode]
                                                      ['fn'],
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                            Text(
                                              "AN",
                                              style: TextStyle(
                                                  color: status[index]
                                                          [widget.studentCode]
                                                      ['an'],
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                );
                              }),
                        ),
                      ),
                    ]),
                  )
                : Container(
                    height: size.height * 0.15,
                    width: MediaQuery.of(context).size.width - 79,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(color: Colors.black, width: 0.5)),
                    child: Row(children: [
                      Expanded(
                        child: SizedBox(
                          height: 100,
                          width: (MediaQuery.of(context).size.width - 100) / 7,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              // reverse: true,
                              itemCount: 7,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: size.height * 0.30,
                                  width:
                                      (MediaQuery.of(context).size.width - 80) /
                                          7,
                                  decoration: BoxDecoration(
                                      border: Border(
                                    right: (index != 6)
                                        ? const BorderSide(
                                            color: Color.fromARGB(
                                                255, 105, 25, 25),
                                            width: 0.5,
                                          )
                                        : BorderSide.none,
                                  )),
                                  child: Column(children: [
                                    Shimmer(
                                      duration: const Duration(seconds: 2),
                                      color: Color.fromARGB(255, 67, 67, 67),
                                      enabled: loading,
                                      child: Container(
                                        height: size.height * 0.030,
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 0.5,
                                                    color: Colors.black))),
                                        child: const Center(),
                                      ),
                                    ),
                                    Shimmer(
                                      duration: const Duration(seconds: 2),
                                      color: Color.fromARGB(255, 170, 152, 152),
                                      enabled: loading,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: index == 0
                                                ? const Radius.circular(0)
                                                : Radius.zero,
                                            bottomRight:
                                                index == widget.day.length - 1
                                                    ? const Radius.circular(0)
                                                    : Radius.zero,
                                          ),
                                        ),
                                        height: size.height * 0.070,
                                        child: const Center(),
                                      ),
                                    ),
                                    Shimmer(
                                      duration: const Duration(seconds: 2),
                                      color: Color.fromARGB(255, 67, 67, 67),
                                      enabled: loading,
                                      child: Container(
                                        height: 25,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: index == 0
                                                ? const Radius.circular(5)
                                                : Radius.zero,
                                            bottomRight:
                                                index == widget.day.length - 1
                                                    ? const Radius.circular(5)
                                                    : Radius.zero,
                                          ),
                                        ),
                                        child: Center(
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: const [],
                                          ),
                                        ),
                                      ),
                                    )
                                  ]),
                                );
                              }),
                        ),
                      ),
                    ]),
                  ),
            // SizedBox(height: size.height * 0.030),
          ],
        ));
  }

  TextStyle buildMontserrat(
    Color color, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 14,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
