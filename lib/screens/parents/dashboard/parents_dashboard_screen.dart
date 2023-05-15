// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print

import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/child_card.dart';
import 'package:student_management/components/sidebar.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

class ParentsDashboardScreen extends StatefulWidget {
  const ParentsDashboardScreen({super.key});

  @override
  State<ParentsDashboardScreen> createState() => _ParentsDashboardScreenState();
}

class _ParentsDashboardScreenState extends State<ParentsDashboardScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  List childDetails = [];
  List items = [];
  List date = [];
  List day = [];
  List status = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    getData();
    getPastWeek();
    // getPastWeekAttendance();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    var details = prefs.getString('childDetails');
    dynamic data = json.decode(details!);
    debugPrint("$data");
    setState(() {
      childDetails = data;
    });
  }

  getPastWeek() {
    final workingDays = [];
    final dates = [];
    final currentDate = DateTime.now();
    final orderDate = currentDate.subtract(const Duration(days: 7));

    DateTime indexDate = currentDate;
    while (indexDate.difference(orderDate).inDays != 0) {
      workingDays.add(DateFormat('EEE').format(indexDate));
      dates.add(indexDate.day);

      indexDate = indexDate.subtract(const Duration(days: 1));
    }
    setState(() {
      day = workingDays.reversed.toList();
      date = dates.reversed.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      top: true,
      child: Scaffold(
        key: key,
        appBar: AppBar(
          title: const Text(""),
          elevation: 0,
        ),
        drawer: const SideBar(),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: size.height * 0.85,
                  child: ListView.builder(
                      itemCount: childDetails.length,
                      //shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ChildCard(
                              day: day,
                              date: date,
                              fullName: childDetails[index]['full_name'],
                              grade: childDetails[index]['class'],
                              division: childDetails[index]['name'],
                              school: childDetails[index]['school_name'],
                              studentCode: childDetails[index]['student_code'],
                              admissionNo: childDetails[index]['admission_no'],
                              schoolId: childDetails[index]['school_id'],
                              batchId: childDetails[index]['batch_id'],
                              imageURL:
                                  (childDetails[index]['photo_url'].toString()),
                            ),
                            SizedBox(height: size.height * 0.030),
                          ],
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }

  TextStyle buildMontserrat(
    Color color, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 12,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
