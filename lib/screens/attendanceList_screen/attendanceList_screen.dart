import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:student_management/constants.dart';

class AttendanceList extends StatefulWidget {
  const AttendanceList({super.key});

  @override
  State<AttendanceList> createState() => _AttendanceListState();
}

class _AttendanceListState extends State<AttendanceList> {
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
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: 
        <Widget>[
           const SizedBox(height: 50),
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
                 child: 
                 DropdownButton(
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
        ],
      ),
    );
  }
}