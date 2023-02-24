import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/individual_attendance_screen/individual_attendance_screen.dart';

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
    final myProducts = List<String>.generate(1000, (i) => 'Product $i');
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
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
                      itemCount: 10,
                      shrinkWrap: true,
                      // display each item of the product list
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const IndividualAttendanceScreen()),
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
                                    const Text("Ram"),
                                    const SizedBox(width: 20),
                                    const Text("IX A"),
                                    const SizedBox(width: 20),
                                    const Text("02/07/2022")
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
    );
  }
}
