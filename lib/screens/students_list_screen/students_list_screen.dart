// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/banner.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/students_profile_screen/students_profile_screen.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

class StudentsListScreen extends StatefulWidget {
  const StudentsListScreen({super.key});

  @override
  State<StudentsListScreen> createState() => _StudentsListScreenState();
}

class _StudentsListScreenState extends State<StudentsListScreen> {
  dynamic studentsList = [];

  @override
  void initState() {
    getStudentsData();
    super.initState();
  }

  getStudentsData() async {
    final prefs = await SharedPreferences.getInstance();

    var data = {
      "batch_id": prefs.getString('permittedBatches'),
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

    final res = await studentList(data);
    final responseData = jsonDecode(res.body);

    if (res.statusCode == 200) {
      //await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pop();
      // print("-=-===-=-=-=-=-=-=---=> ${responseData['data']}");
      var data = parseJwtAndSave(responseData['data']);
      print(data);
      setState(() {
        studentsList = data['token'];
      });
      print("==================> ${studentsList}");
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
    final myProducts = List<String>.generate(10, (i) => 'Product $i');
    return Scaffold(
      appBar: AppBar(title: const Text("Students List")),
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
                  height: 56,
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
                    // After selecting the desired option,it will
                    // change button value to selected value
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownvalue = newValue!;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: size.width * 0.20,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      //shape: const StadiumBorder(),
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(size.width * 0.03),
                      minimumSize: const Size.fromHeight(54),
                    ),
                    child: const Icon(
                      Icons.filter_list,
                      size: 30,
                      color: Colors.red,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: ListView.builder(
                        // the number of items in the list
                        itemCount: studentsList.length,
                        shrinkWrap: true,
                        // display each item of the product list
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => StudentsProfileScreen(
                                        studentCode: studentsList[index]
                                                ['student_code']
                                            .toString())),
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
                                      Column(
                                        children: <Widget>[
                                          Text(
                                              "${studentsList[index]['full_name']}"),
                                          Text(
                                              "Student Code: ${studentsList[index]['student_code']}"),
                                          Text(
                                              "Admission No: ${studentsList[index]['admission_no']}"),
                                        ],
                                      ),
                                      // const SizedBox(width: 20),
                                      // Text("IX A")
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
