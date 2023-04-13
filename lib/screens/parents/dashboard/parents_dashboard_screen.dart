import 'dart:convert';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/banner.dart';
import 'package:student_management/components/profile_header.dart';
import 'package:student_management/components/student_profile_card.dart';
import 'package:student_management/constants.dart';

class ParentsDashboardScreen extends StatefulWidget {
  const ParentsDashboardScreen({super.key});

  @override
  State<ParentsDashboardScreen> createState() => _ParentsDashboardScreenState();
}

class _ParentsDashboardScreenState extends State<ParentsDashboardScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();
  String? schoolId;
  String grade = "";
  String userName = "";
  List permittedBatches = [];
  List items = [];
  List date = [];
  List day = [];

  @override
  void initState() {
    super.initState();
    getData();
    getPastWeek();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    var details = await prefs.getString('loginData');
    schoolId = await prefs.getString('school_id');
    dynamic data = json.decode(details!);
    setState(() {
      userName =
          "${prefs.getString('first_name')} ${prefs.getString('last_name')}";
      grade = "${prefs.getString('class')} ${prefs.getString('name')}";
    });
    setState(() {
      permittedBatches = data['permittedBatches'];
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
  }

  getPastWeek() {
    /* // Parse date without timestamp
    // final DateFormat formatter = DateFormat('yyyy-MM-dd');

    final DateTime today = DateTime.now();

    for (int i = 0; i < 6; i++) {
      // Get start date
      final DateTime startDate = today.subtract(Duration(days: i + 1));
      final DateTime endDate = today.subtract(Duration(days: i + 1));
      setState(() {
        day.add(DateFormat('EEE').format(endDate));
        date.add(endDate.day);
      });
    }
    print(day);
    print(date); */
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
    // ignore: prefer_const_constructors
    return SafeArea(
      top: true,
      child: Scaffold(
        key: key,
        appBar: AppBar(title: const Text("Profile")),
        body: SingleChildScrollView(
          child: Column(
            // ignore: prefer_const_literals_to_create_immutables
            children: <Widget>[
              CommonBanner(
                imageUrl: "assets/images/teacher.png",
                name: userName,
                grade: grade,
                showDiv: false,
              ),
              Column(
                children: <Widget>[
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                      height: 400,
                      width: MediaQuery.of(context).size.width - 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(color: Colors.black, width: 0.5)),
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
                                      const CircleAvatar(
                                        radius: 50,
                                        backgroundImage:
                                            AssetImage("assets/images/boy.png"),
                                      ),
                                      const SizedBox(width: 20),
                                      SizedBox(
                                        width: size.width * 0.5,
                                        //height: double.infinity,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            SizedBox(
                                              height: 50,
                                              child: Text(
                                                "rama krishna shivananada",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Color(0xFFFFFFFF),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              "5 B",
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8)
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
                            height: 20,
                          ),
                          SizedBox(
                              height: 150,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, right: 8.0, bottom: 8.0),
                                    child: Column(
                                      children: [
                                        Text(
                                          "St. Jpseph's H.S Mattakara",
                                          style: buildMontserrat(
                                            const Color(0xFF000000),
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.clip,
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.blue),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () => {},
                                    icon: Icon(
                                      Icons.send_rounded,
                                    ),
                                    label: Text(
                                      'Messages',
                                    ),
                                  ),
                                  TextButton.icon(
                                    style: TextButton.styleFrom(
                                      textStyle: TextStyle(color: Colors.blue),
                                      backgroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    onPressed: () => {},
                                    icon: Icon(
                                      Icons.send_rounded,
                                    ),
                                    label: Text(
                                      'Attendance',
                                    ),
                                  ),
                                ],
                              )),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width - 79,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.black, width: 0.5)),
                            child: Row(children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  width:
                                      (MediaQuery.of(context).size.width - 80) /
                                          7,
                                  child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      // reverse: true,
                                      itemCount: 7,
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Container(
                                          height: 50,
                                          width: (MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  80) /
                                              7,
                                          decoration: BoxDecoration(
                                              border: Border(
                                            right: (index != 6)
                                                ? const BorderSide(
                                                    color: Colors.black,
                                                    width: 0.5,
                                                  )
                                                : BorderSide.none,
                                          )),
                                          child: Column(children: [
                                            Container(
                                              height: 24,
                                              decoration: const BoxDecoration(
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          width: 0.5,
                                                          color:
                                                              Colors.black))),
                                              child: Center(
                                                  child: Text(
                                                      day[index].toString())),
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: primaryColor,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: index == 0
                                                      ? Radius.circular(5)
                                                      : Radius.zero,
                                                  bottomRight:
                                                      index == day.length - 1
                                                          ? Radius.circular(5)
                                                          : Radius.zero,
                                                ),
                                              ),
                                              height: 25,
                                              child: Center(
                                                  child: Text(
                                                      date[index].toString())),
                                            )
                                          ]),
                                        );
                                      }),
                                ),
                              ),
                            ]),
                          )
                        ],
                      )),
                ],
              )
            ],
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
      fontSize: 15,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
