import 'package:flutter/material.dart';
import 'package:student_management/components/app_bar.dart';
import 'package:student_management/components/sidebar.dart';
import 'package:student_management/components/submit_button.dart';
import 'package:student_management/constants.dart';

import '../../components/custom_dropdown.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Initial Selected Value
  String dropdownvalue = 'Class 1';

  // List of items in our dropdown menu
  String studentClass = "";
  List studentClasses = [
    {"id": "1", "name": "Class1B"},
    {"id": "2", "name": "Class1A"},
    {"id": "3", "name": "Class2B"}
  ];
  bool checked1 = true;
  bool checked2 = true;
  bool checked3 = false;
  bool checked4 = false;
  bool checked5 = true;
  bool checked6 = false;
  bool checked7 = false;
  bool checked8 = true;
  bool checked9 = false;
  bool checked10 = false;

  DateTime selectedDate = DateTime.now();

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
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: const Text("Add Attendance")),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: size.height * 0.05),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: size.width * 0.5,
                  child: CustomDropDown(
                    label: "Select Your Class",
                    value: studentClass,
                    data: studentClasses,
                    onChange: (value) {
                      setState(() {
                        studentClass = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.length < 1) {
                        return "please select your Class";
                      }
                      return null;
                    },
                  ),
                ),
                const Spacer(),
                Container(
                  //padding: EdgeInsets.all(size.width * 0.02),
                  height: 60,
                  width: size.width * 0.40,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(30)),
                    color: Colors.white10,
                    border: Border.all(
                      width: 2.0,
                      // assign the color to the border color
                      color: primaryColor,
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      const Spacer(),
                      Text(
                        selectedDate.toString().substring(0, 10),
                        style: const TextStyle(
                          color: primaryColor,
                          fontSize: 20,
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
                          size: 30,
                          color: primaryColor,
                        ),
                      ),
                      // const Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              //scrollDirection: Axis.values(size),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: DataTable(
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
                              value: checked10,
                              onChanged: (val) {
                                setState(() {
                                  checked10 = !checked10;
                                });
                              }),
                          const Text(
                            'Forenoon',
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
                                setState(() {
                                  checked10 = !checked10;
                                });
                              }),
                          const Text(
                            'Afternoon',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    ),
                  ],
                  rows: <DataRow>[
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('1')),
                        const DataCell(Text('Sarath')),
                        DataCell(Checkbox(
                          value: checked1,
                          onChanged: (val) {
                            setState(() {
                              checked1 = !checked1;
                            });
                          },
                          //checkColor:const Color.fromARGB(255, 254, 0, 190),
                          //activeColor:Color.fromARGB(255, 8, 237, 12),
                          //     hoverColor: const Color.fromARGB(249, 253, 169, 0),
                          //       side: BorderSide(
                          //   color: Color.fromARGB(248, 55, 253, 0), //your desire colour here
                          //   width: 1.5,
                          // ),
                        )),
                        DataCell(Checkbox(
                            value: checked2,
                            onChanged: (val) {
                              setState(() {
                                checked2 = !checked2;
                              });
                            })),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('2')),
                        const DataCell(Text('Renjith')),
                        DataCell(Checkbox(
                            value: checked3,
                            onChanged: (val) {
                              setState(() {
                                checked3 = !checked3;
                              });
                            })),
                        DataCell(Checkbox(
                            value: checked4,
                            onChanged: (val) {
                              setState(() {
                                checked4 = !checked4;
                              });
                            })),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('3')),
                        const DataCell(Text('Suben')),
                        DataCell(Checkbox(
                            value: checked5,
                            onChanged: (val) {
                              setState(() {
                                checked5 = !checked5;
                              });
                            })),
                        DataCell(Checkbox(
                            value: checked6,
                            onChanged: (val) {
                              setState(() {
                                checked6 = !checked6;
                              });
                            })),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('4')),
                        const DataCell(Text('Sona')),
                        DataCell(Checkbox(
                            value: checked7,
                            onChanged: (val) {
                              setState(() {
                                checked7 = !checked7;
                              });
                            })),
                        DataCell(Checkbox(
                            value: checked8,
                            onChanged: (val) {
                              setState(() {
                                checked8 = !checked8;
                              });
                            })),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('5')),
                        const DataCell(Text('Sona')),
                        DataCell(Checkbox(
                            value: checked7,
                            onChanged: (val) {
                              setState(() {
                                checked7 = !checked7;
                              });
                            })),
                        DataCell(Checkbox(
                            value: checked8,
                            onChanged: (val) {
                              setState(() {
                                checked8 = !checked8;
                              });
                            })),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('6')),
                        const DataCell(Text('Rajas')),
                        DataCell(Checkbox(
                            value: checked10,
                            onChanged: (val) {
                              setState(() {
                                checked10 = !checked10;
                              });
                            })),
                        DataCell(Checkbox(
                            value: checked9,
                            onChanged: (val) {
                              setState(() {
                                checked9 = !checked9;
                              });
                            })),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('7')),
                        const DataCell(Text('Vishnu')),
                        DataCell(Checkbox(
                            value: checked10,
                            onChanged: (val) {
                              setState(() {
                                checked10 = !checked10;
                              });
                            })),
                        DataCell(Checkbox(
                            value: checked9,
                            onChanged: (val) {
                              setState(() {
                                checked9 = !checked9;
                              });
                            })),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('8')),
                        const DataCell(Text('Rajas')),
                        DataCell(Checkbox(
                            value: checked10,
                            onChanged: (val) {
                              setState(() {
                                checked10 = !checked10;
                              });
                            })),
                        DataCell(Checkbox(
                            value: checked9,
                            onChanged: (val) {
                              setState(() {
                                checked9 = !checked9;
                              });
                            })),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('9')),
                        const DataCell(Text('Siva Kumar Saxena')),
                        DataCell(Checkbox(
                            value: checked10,
                            onChanged: (val) {
                              setState(() {
                                checked10 = !checked10;
                              });
                            })),
                        DataCell(Checkbox(
                            value: checked9,
                            onChanged: (val) {
                              setState(() {
                                checked9 = !checked9;
                              });
                            })),
                      ],
                    ),
                    DataRow(
                      cells: <DataCell>[
                        const DataCell(Text('10')),
                        const DataCell(Text('Rajas')),
                        DataCell(Checkbox(
                            value: checked10,
                            onChanged: (val) {
                              setState(() {
                                checked10 = !checked10;
                              });
                            })),
                        DataCell(Checkbox(
                            value: checked9,
                            onChanged: (val) {
                              setState(() {
                                checked9 = !checked9;
                              });
                            })),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
              bottom: 50,
              //left: 50,
              child: SubmitButton(label: "Submit", onClick: () {}))
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
    );
  }
}
