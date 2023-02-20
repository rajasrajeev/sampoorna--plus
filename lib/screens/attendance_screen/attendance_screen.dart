import 'package:flutter/material.dart';
import 'package:student_management/components/app_bar.dart';
import 'package:student_management/components/sidebar.dart';
import 'package:student_management/constants.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // Initial Selected Value
  String dropdownvalue = 'Item 1';

  // List of items in our dropdown menu
  var items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
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
      appBar: AppBar(),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          const SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(size.width * 0.03),
            height: 46,
                width: size.width * 0.60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Color.fromARGB(222, 154, 154, 159),
                ),
                child: 
                Column(
                 // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  
                  children: [
                  
                  DropdownButton(
                    value: dropdownvalue,
                    icon: const Icon(Icons.keyboard_arrow_down),
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
                  )
                ]),
              ),
          Row(
            children: <Widget>[
              const Spacer(),
              
              Container(
                padding: EdgeInsets.all(size.width * 0.03),
                height: 56,
                width: size.width * 0.60,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  color: primaryColor,
                  
                ),
                child: Row(
                  children: <Widget>[
                    const Spacer(),
                    Text(
                      selectedDate.toString().substring(0, 10),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 20),
                    IconButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      icon: const Icon(
                        Icons.date_range,
                        size: 30,
                        color: Colors.white,
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                width: size.width * 0.30,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    //shape: const StadiumBorder(),
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(size.width * 0.03),
                    minimumSize: const Size.fromHeight(54),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 20),
          Center(
            child: DataTable(
              columns: const <DataColumn>[
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Id',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Name',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Half Day',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                ),
                DataColumn(
                  label: Expanded(
                    child: Text(
                      'Full Day',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
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
        ],
      ),
    );
  }
}
