import 'package:flutter/material.dart';

import '../constants.dart';

//const darkColor = Color(0xFF49535C);

class StudentProfileCard extends StatelessWidget {
  const StudentProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var montserrat = const TextStyle(
      fontSize: 12,
    );
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Container(
          constraints: BoxConstraints(maxWidth: size.width * 0.9),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(166, 142, 138, 138),
                spreadRadius: 1,
                blurRadius: 4,
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                            topRight: Radius.circular(20),
                            topLeft: Radius.circular(20),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Padding(
                                      padding: EdgeInsets.all(10.0),
                                      child: Text(
                                        "StudentName rama krishna shivananada",
                                        // softWrap: true,
                                        // textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "5 B",
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: 8)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 30,
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Student Class     :\nStudent Division :",
                              style: montserrat,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Student ID           :\nAttendance         :",
                              style: montserrat,
                            ),
                          ],
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("2ffdd2", style: montserrat),
                            Text("5", style: montserrat),
                            const SizedBox(height: 16),
                            Text("B", style: montserrat),
                            Text("22", style: montserrat),
                          ],
                        )
                      ],
                    ),
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(
                  //     horizontal: 16,
                  //     vertical: 30,
                  //   ),
                  //   child: Row(
                  //     children: [
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.end,
                  //         children: [
                  //           Text(
                  //             "Student Class     :\nStudent Division :",
                  //             style: montserrat,
                  //           ),
                  //           const SizedBox(height: 16),
                  //           Text(
                  //             "Student ID           :\nAttendance         :",
                  //             style: montserrat,
                  //           ),
                  //         ],
                  //       ),
                  //       const SizedBox(width: 8),
                  //       Column(
                  //         crossAxisAlignment: CrossAxisAlignment.start,
                  //         children: [
                  //           Text("2ffdd2", style: montserrat),
                  //           Text("5", style: montserrat),
                  //           const SizedBox(height: 16),
                  //           Text("B", style: montserrat),
                  //           Text("22", style: montserrat),
                  //         ],
                  //       )
                  //     ],
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 40),
              Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Text(
                          "6280",
                          style: buildMontserrat(
                            const Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "MArk",
                          style: buildMontserrat(Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                      child: VerticalDivider(
                        color: Color(0xFF9A9A9A),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "1745",
                          style: buildMontserrat(
                            const Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Attendance",
                          style: buildMontserrat(Colors.black),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                      child: VerticalDivider(
                        color: Color(0xFF9A9A9A),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "163",
                          style: buildMontserrat(
                            const Color(0xFF000000),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Mark",
                          style: buildMontserrat(Colors.black),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8)
            ],
          ),
        ),
      ),
    );
  }

  TextStyle buildMontserrat(
    Color color, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 18,
      color: color,
      fontWeight: fontWeight,
    );
  }
}

class AvatarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..lineTo(0, size.height)
      ..lineTo(8, size.height)
      ..arcToPoint(Offset(114, size.height), radius: const Radius.circular(1))
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
