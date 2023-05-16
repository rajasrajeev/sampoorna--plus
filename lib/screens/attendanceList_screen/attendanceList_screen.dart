// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/banner.dart';
import 'package:student_management/components/calender.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';
import 'package:student_management/services/utils.dart';

import '../../components/live_title.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
  dynamic attendanceDates = [];
  List permittedBatches = [];
  String dropdownvalue = '';
  String? schoolId;
  String grade = "";
  String userName = "";
// List of items in our dropdown menu
  List items = [];
  String date1 = "";
  String date2 = "";
  dynamic currentMarkedAttendance = '';

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    var details = prefs.getString('loginData');
    schoolId = prefs.getString('school_id');
    dynamic data = json.decode(details!);
    setState(() {
      userName =
          "${prefs.getString('first_name')} ${prefs.getString('last_name')}";
      grade = "${prefs.getString('class')} ${prefs.getString('name')}";
    });
    setState(() {
      permittedBatches = data['permittedBatches'];
      dropdownvalue = permittedBatches[0]['batch_id'];
      schoolId = prefs.getString('school_id');
    });
    for (var i = 0; i < permittedBatches.length; i++) {
      setState(() {
        items.add({
          "grade":
              '${permittedBatches[i]['class']} ${permittedBatches[i]['name']}',
          "batch_id": '${permittedBatches[i]['batch_id']}'
        });
      });
    }
    getDataBetweenDates();
  }

  getLastMarkedAttendance() async {
    final res = await lastMarkedDateApi(schoolId, dropdownvalue);
    if (res.statusCode == 200) {
      final responseData = jsonDecode(res.body);
      //Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['data']);
      debugPrint("individualAttendanceForStudent Data ********* $data");
      dynamic lastmarkedField = data['token']['lastmarked'];

      if (lastmarkedField is List<dynamic>) {
        List<dynamic> lastmarked = lastmarkedField;

        if (lastmarked.isNotEmpty) {
          // do something with the value of "lastmarked"
          setState(() {
            currentMarkedAttendance = lastmarked.toString();
          });
        } else {
          // "lastmarked" is empty
          setState(() {
            currentMarkedAttendance = "";
          });
        }
      } else {
        // handle the case where "lastmarked" is not a list
        setState(() {
          currentMarkedAttendance = lastmarkedField;
        });
      }
    } else {
      // Navigator.of(context).pop();
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

  getDataBetweenDates() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      schoolId = prefs.getString('school_id');
    });
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateFormat monthFormatter = DateFormat('MM');
    setState(() {
      date2 = formatter.format(now);
      date1 = "${now.year}-${monthFormatter.format(now)}-01";
    });
    // print("-=-=-=-=$date1 =-=-=-=-=$date2");
    getStudentsData(date1, date2, schoolId!, dropdownvalue);
    getLastMarkedAttendance();
  }

  getStudentsData(
      String date1, String date2, String schoolId, String batchId) async {
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

    final res = await attendanceBetweenDates(date1, date2, schoolId, batchId);

    if (res.statusCode == 200) {
      final responseData = jsonDecode(res.body);
      Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['data']);
      setState(() {
        attendanceDates = data['token'];
      });
      formatDates(data['token']);
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

  formatDates(List dates) async {
    for (var i = 0; i < dates.length; i++) {
      var currentDate = DateTime.parse(dates[i]['date']);
      final kEventSource = {
        // for (var item in List.generate(50, (index) => index))
        if (dates[i]['total_absentees'] != 'Holiday' &&
            dates[i]['total_absentees'] != "")
          DateTime.utc(currentDate.year, currentDate.month, currentDate.day):
              List.generate(
                  int.parse(dates[i]['total_absentees']),
                  (index) => Event(
                      'Event ${dates[i]['total_absentees']} | ${index + 1}'))
      };
      kEvents.addAll(kEventSource);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Attendance List"),
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CommonBanner(
                imageUrl: "assets/images/teacher.png",
                name: userName,
                grade: grade,
                showDiv: false,
              ),
              const SizedBox(height: 10),
              Row(
                children: <Widget>[
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(size.width * 0.03),
                    height: size.height * 0.065,
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
                      items: items
                          .map(
                            (map) => DropdownMenuItem(
                              value: map['batch_id'],
                              child: Text(map['grade']),
                            ),
                          )
                          .toList(),
                      // After selecting the desired option,it will
                      // change button value to selected value
                      onChanged: (newValue) {
                        setState(() {
                          dropdownvalue = newValue.toString();
                        });
                        getStudentsData(date1, date2, schoolId!, dropdownvalue);
                        getLastMarkedAttendance();
                      },
                    ),
                  ),
                  const Spacer()
                ],
              ),
              LiveTitle(
                  title: currentMarkedAttendance == ''
                      ? 'Last Marked Attendance Not Found...'
                      : 'Last Marked Attendance $currentMarkedAttendance'),
              const SizedBox(height: 10),
              AttendanceListCalender(
                batchId: dropdownvalue,
                schoolId: schoolId.toString(),
                attendanceDates: attendanceDates!,
                date1: date1,
                date2: date2,
                onPageChanged: (date) {
                  if (date.month == DateTime.now().month) {
                    getDataBetweenDates();
                  } else {
                    final DateFormat formatter = DateFormat('yyyy-MM-dd');

                    int lastDay = DateTime(date.year, date.month + 1, 0).day;
                    setState(() {
                      date1 = formatter.format(date);
                      date2 = "${date.year}-${date.month}-$lastDay";
                    });
                    getStudentsData(date1, date2, schoolId!, dropdownvalue);
                  }

                  // _focusedDay = date;
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
