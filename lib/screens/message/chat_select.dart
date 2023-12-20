import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../components/banner.dart';
import '../../components/custom_textfield.dart';
import '../../constants.dart';
import '../../services/api_services.dart';
import '../../services/database_helper.dart';
import '../../services/jwt_token_parser.dart';
import '../broadcast/broadcast_detail.dart';
import '../main_screen/main_screen.dart';
import 'chat_detail.dart';

class ChatSelect extends StatefulWidget {
  const ChatSelect({super.key});

  @override
  State<ChatSelect> createState() => _ChatSelectState();
}

class _ChatSelectState extends State<ChatSelect> {
  dynamic studentsList = [];
  List permittedBatches = [];
  String dropdownvalue = '';
  String grade = "";
  String userName = "";
  final TextEditingController searchController = TextEditingController();
  // List of items in our dropdown menu
  List items = [];
  DatabaseHelper _db = DatabaseHelper.instance;
  bool isSelected = false;
  @override
  void initState() {
    super.initState();
    getPermittedBatch();
  }

  getPermittedBatch() async {
    final prefs = await SharedPreferences.getInstance();
    var details = await prefs.getString('loginData');
    dynamic data = json.decode(details!);
    setState(() {
      userName =
          "${prefs.getString('first_name')} ${prefs.getString('last_name')}";
      grade = "${prefs.getString('class')} ${prefs.getString('name')}";
    });
    setState(() {
      permittedBatches = data['permittedBatches'];
      dropdownvalue = permittedBatches[0]['batch_id'];
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
    getStudentsList();
  }

  getStudentsList() async {
    dynamic localStudents = await _db.getStudentsFromLocal(dropdownvalue);
    if (localStudents.length > 0) {
      setState(() {
        studentsList = localStudents;
      });
    } else {
      getStudentsListFromApi();
    }
  }

  getStudentsListFromApi() async {
    final prefs = await SharedPreferences.getInstance();

    var data = {
      "batch_id": dropdownvalue,
      "school_id": prefs.getString('school_id'),
      "user_type": prefs.getString('user_type')
    };

    //Function To Display Showdialog
    showDialogDisplay();

    final res = await studentList(data);
    final responseData = jsonDecode(res.body);

    if (res.statusCode == 200) {
      Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['data']);

      setState(() {
        studentsList = data['token'];
      });

      //To insert Value into database
      // await syncStudentsList();
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

  sendBroadcastMessages(String studentsClassList) {
    var selectedGrade;
    items
        .map((map) => [
              if (studentsClassList == map['batch_id'])
                {selectedGrade = map['grade']}
            ])
        .toList();
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              // StudentsProfileScreen(
              //     studentCode: studentsList[
              //                 index]
              //             ['student_code']
              //         .toString())
              BroadcastDetail(
                  schoolDiv: selectedGrade,
                  schoolBatchId: studentsClassList //Class List from dropdown
                  )),
    );
  }

  showDialogDisplay() {
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
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // Initial Selected Value

    return SafeArea(
      top: true,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
          elevation: 0,
          actions: <Widget>[
            Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MainScreen(),
                      ),
                    );
                  },
                  child: const Icon(
                    Icons.home_filled,
                    size: 26.0,
                  ),
                )),
          ],
        ),
        body: Column(
          children: [
            SingleChildScrollView(
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
                      SizedBox(
                        //padding: EdgeInsets.all(size.width * 0.03),
                        height: size.height * 0.085,
                        width: size.width * 0.60,
                        // decoration: BoxDecoration(
                        //  color: Colors.white,
                        //   borderRadius: BorderRadius.circular(30.0),
                        //   border: Border.all(
                        //    style: BorderStyle.solid,
                        //   width: 2.0,
                        //    color: primaryColor,
                        //  ),
                        // ),
                        child: CustomTextField(
                          label: "Search here",
                          minLine: 1,
                          maxLine: 1,
                          enabled: true,
                          controller: searchController,
                          validator: (value) {
                            if (value == null || value.length < 1) {
                              return "please enter username";
                            }
                            return null;
                          },
                          onChanged: (value) async {
                            dynamic localStudents = await _db.getStudentSearch(
                                value, dropdownvalue);
                            if (localStudents.length > 0) {
                              setState(() {
                                studentsList = localStudents;
                              });
                            } else {
                              getStudentsList();
                            }
                          },
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: EdgeInsets.all(size.width * 0.03),
                        height: size.height * 0.07,
                        width: size.width * 0.30,
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
                          onChanged: (newValue) async {
                            setState(() {
                              dropdownvalue = newValue.toString();
                            });
                            await getStudentsList();
                          },
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  //  SizedBox(height: size.height * 0.05),
                  Column(
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SizedBox(
                              height: size.height * 0.6,
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
                                              builder: (context) =>
                                                  // StudentsProfileScreen(
                                                  //     studentCode: studentsList[
                                                  //                 index]
                                                  //             ['student_code']
                                                  //         .toString())
                                                  ChatDetail(
                                                    fullName:
                                                        studentsList[index]
                                                                ['full_name']
                                                            .toString(),
                                                    batchId: studentsList[index]
                                                            ['batch_id']
                                                        .toString(),
                                                    studentCode:
                                                        studentsList[index]
                                                                ['student_code']
                                                            .toString(),
                                                    studentName:
                                                        studentsList[index]
                                                            ['full_name'],
                                                  )),
                                        );
                                      },
                                      onLongPress: () {
                                        // handle long press here
                                        setState(() {
                                          isSelected = !isSelected;

                                          ///  studentsList[index]['student_code'] = !studentsList[index]['student_code'];
                                        });
                                        print(studentsList[index]
                                                ['student_code']
                                            .toString());
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
                                                            BorderRadius
                                                                .circular(15)),
                                                    alignment: Alignment.center,
                                                    child: Image.asset(
                                                        "assets/images/studentProfile.png")),
                                                const SizedBox(width: 30),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      "${studentsList[index]['full_name']}",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    /* Text(
                                                        "Student Code: ${studentsList[index]['student_code']}" ), */
                                                    Text(
                                                        "(Adm No: ${studentsList[index]['admission_no']})"),
                                                  ],
                                                ),
                                              ],
                                            )),
                                      ),
                                    );
                                  }),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: primaryColor,
          label: const Text("Broadcast Message"),
          icon: const Icon(Icons.sync),
          onPressed: () async {
            await sendBroadcastMessages(dropdownvalue);
          },
        ),
      ),
    );
  }
}
