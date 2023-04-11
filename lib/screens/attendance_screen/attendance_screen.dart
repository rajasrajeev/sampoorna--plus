// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/app_bar.dart';
import 'package:student_management/components/sidebar.dart';
import 'package:student_management/components/submit_button.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/services/database_helper.dart';

import '../../components/custom_dropdown.dart';
import '../../services/api_services.dart';
import '../../services/jwt_token_parser.dart';
import 'package:intl/intl.dart';

class AttendanceScreen extends StatefulWidget {
  final String grade;
  const AttendanceScreen({
    super.key,
    required this.grade,
  });

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  //database helper
  DatabaseHelper _db = DatabaseHelper.instance;
  // Initial Selected Value
  String dropdownvalue = 'Class 1';
  dynamic batchid = "";
  // List of items in our dropdown menu
  // List of items in our dropdown menu
  List items = [];
  dynamic studentsList = [];
  List<Map<String, dynamic>> attendanceCheckers = [];
  List permittedBatches = [];
  bool checked10 = false;
  bool checked1 = false;
  DateTime selectedDate = DateTime.now();
  String markedStatus = "";

  @override
  void initState() {
    getData();
    super.initState();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    var details = await prefs.getString('loginData');
    dynamic data = json.decode(details!);
    setState(() {
      permittedBatches = data['permittedBatches'];
      if (widget.grade != "null") {
        for (var i = 0; i < permittedBatches.length; i++) {
          if (widget.grade ==
              '${permittedBatches[i]['class']} ${permittedBatches[i]['name']}') {
            dropdownvalue = permittedBatches[i]['batch_id'];
          }
        }
      } else {
        dropdownvalue = permittedBatches[0]['batch_id'];
      }
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

    getStudentsData(dropdownvalue);
  }

  getStudentsData(String batchId) async {
    final prefs = await SharedPreferences.getInstance();
    batchid = batchId;
    var data = {
      "batch_id": batchId,
      "school_id": prefs.getString('school_id'),
      "user_type": prefs.getString('user_type')
    };

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
    final DateFormat formatter = DateFormat('dd-MM-yyyy');
    var date = formatter.format(selectedDate);
    final res =
        await attendanceOnDate(date, data['school_id'], data['batch_id']);
    final responseData = jsonDecode(res.body);

    if (res.statusCode == 200) {
      Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['data']);

      setState(() {
        markedStatus = data['markedStatus'];
        studentsList = data['token'];
      });
      await createCheckersList(data['token']);
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

  createCheckersList(students) {
    attendanceCheckers = [];
    //debugPrint("*****Checker List*********");
    for (int i = 0; i < students.length; i++) {
      Map<String, dynamic> obj = {
        "student_id": students[i]["student_code"],
        "full_name": students[i]["full_name"],
        //"fn": true,
        //"an": true
        "fn": (students[i]["absent_FN"] != null)
            ? (students[i]["absent_FN"] != '1')
                ? true
                : false
            : false, //When null checkbox is not ticked for fn

        "an": (students[i]["absent_AN"] != null)
            ? (students[i]["absent_AN"] != '1')
                ? true
                : false
            : false //When null checkbox is not ticked for an
      };
      attendanceCheckers.add(obj);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      getStudentsData(dropdownvalue);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(title: const Text("Add Attendance")),
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            SizedBox(height: size.height * 0.05),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(size.width * 0.03),
                    height: size.height * 0.07,
                    width: size.width * 0.40,
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
                        getStudentsData(dropdownvalue);
                      },
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.all(size.width * 0.014),
                    height: size.height * 0.07,
                    width: size.width * 0.50,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                      color: Colors.white10,
                      border: Border.all(
                        width: 2.0,
                        // assign the color to the border color
                        color: primaryColor,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        children: <Widget>[
                          const Spacer(),
                          Text(
                            selectedDate.toString().substring(0, 10),
                            style: const TextStyle(
                              color: primaryColor,
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          // SizedBox(width: size.width*1),

                          IconButton(
                            onPressed: () {
                              _selectDate(context);
                            },
                            icon: const Icon(
                              Icons.date_range,
                              size: 20,
                              color: primaryColor,
                            ),
                          ),
                          // const Spacer(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  columnSpacing: 18,
                  columns: <DataColumn>[
                    const DataColumn(
                      label: Text(
                        'Id',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    const DataColumn(
                      label: Text(
                        'Name',
                        style: TextStyle(fontStyle: FontStyle.italic),
                      ),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          Checkbox(
                              value: checked1,
                              onChanged: (val) {
                                for (var i = 0; i < studentsList.length; i++) {
                                  setState(() {
                                    attendanceCheckers[i]['fn'] = !checked1;
                                  });
                                }
                                setState(() {
                                  checked1 = !checked1;
                                });
                              }),
                          const Text(
                            'FN',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                    DataColumn(
                      label: Row(
                        children: [
                          Checkbox(
                              value: checked10,
                              onChanged: (val) {
                                for (var i = 0; i < studentsList.length; i++) {
                                  setState(() {
                                    attendanceCheckers[i]['an'] = !checked10;
                                  });
                                }
                                setState(() {
                                  checked10 = !checked10;
                                });
                              }),
                          const Text(
                            'AN',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                  rows: List.generate(studentsList.length, (index) {
                    Map<String, dynamic> attendance =
                        attendanceCheckers.firstWhere((item) =>
                            item['student_id'] ==
                            studentsList[index]["student_code"]);
                    return DataRow(cells: <DataCell>[
                      DataCell(Text('${index + 1}')),
                      DataCell(Text('${studentsList[index]["full_name"]}')),
                      DataCell(Checkbox(
                        value: attendance["fn"],
                        onChanged: (bool? val) {
                          setState(() {
                            attendance["fn"] = val!;
                          });
                        },
                      )),
                      DataCell(Checkbox(
                        value: attendance["an"],
                        onChanged: (bool? val) {
                          setState(() {
                            attendance["an"] = val!;
                          });
                        },
                      )),
                    ]);
                  }),
                ),
              ),
            ),
            Column(
              children: [
                SubmitButton(
                    label: "Submit",
                    onClick: () async {
                      showDialog(
                          // The user CANNOT close this dialog  by pressing outsite it
                          barrierDismissible: true,
                          context: context,
                          builder: (_) {
                            return Dialog(
                              // The background color
                              backgroundColor: Colors.white,
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
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
                      int listLength = attendanceCheckers.length;
                      List absentees = [];
                      int fn, an;

                      for (int i = 0; i < listLength; i++) {
                        attendanceCheckers[i]["fn"] == true ? fn = 1 : fn = 0;
                        attendanceCheckers[i]["an"] == true ? an = 1 : an = 0;

                        Map<String, dynamic> obj = {
                          attendanceCheckers[i]["student_id"]: {
                            "1": fn,
                            "2": an,
                            "3": attendanceCheckers[i]["full_name"]
                          }
                        };
                        absentees.add(obj);
                      }

                      final DateFormat formatter = DateFormat('dd-MM-yyyy');
                      var date = formatter.format(selectedDate);

                      dynamic dataToSubmit = {
                        "ts": date,
                        "school_id": studentsList[0]["school_id"],
                        "batch_id": batchid,
                        "absentee": absentees
                      };

                      final res = await addAttendance(dataToSubmit);

                      if (res.statusCode == 200) {
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: "Attendance Submitted Succesfully",
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 10,
                          backgroundColor: Colors.green,
                          textColor: Colors.white,
                          fontSize: 15.0,
                        );
                      } else if (res.statusCode == 202) {
                        final responseData = jsonDecode(res.body);
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: responseData["message"],
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 10,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 15.0,
                        );
                      } else {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context);
                        Fluttertoast.showToast(
                          msg: "Something went wrong!!!",
                          gravity: ToastGravity.TOP,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 15.0,
                        );
                      }
                    }),
              ],
            )
          ],
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        //   floatingActionButton: FloatingActionButton.extended(
        //   backgroundColor: primaryColor,
        //   label: const Text('Submit'),
        //   icon: const Icon(Icons.check_circle),
        //   onPressed: () {
        //     setState(() {
        //      // i++;
        //     });
        //   },

        // ),
      ),
    );
  }
}
