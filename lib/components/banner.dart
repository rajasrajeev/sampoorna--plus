import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/bezier_clipper.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/models/teachers.dart';

class CommonBanner extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String grade;
  final bool showDiv;

  const CommonBanner(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.grade,
      required this.showDiv
      });

  @override
  State<CommonBanner> createState() => _CommonBannerState();
}

class _CommonBannerState extends State<CommonBanner> {
  List permittedBatches = [];

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    final prefs = await SharedPreferences.getInstance();
    var details = await prefs.getString('loginData');
    dynamic data = json.decode(details!);
    setState(() {
      permittedBatches = data['permittedBatches'];
    });
    print(permittedBatches);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //final double height = MediaQuery.of(context).size.height * 0.15;
    return ClipPath(
      clipper: BezierClipper(1),
      child: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryColor,
                  secondaryColor,
                ],
              )),
              height: size.height * 0.15,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.contain,
                      height: 75,
                      width: 75,
                    ),
                  ),
                  const Spacer(),
                  // ignore: prefer_const_constructors
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Color.fromARGB(221, 255, 255, 255),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      widget.showDiv !=false ?
                      SizedBox(
                        width: size.width * 0.4,
                        height: size.height * 0.05,
                        child: ListView.builder(
                            itemCount: permittedBatches.length,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Container(
                                width: size.width * 0.2,
                                // height: size.height*0.02,
                                margin: const EdgeInsets.all(8),
                                padding: const EdgeInsets.all(0.1),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 255, 255, 255)),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "${permittedBatches[index]['class']} ${permittedBatches[index]['name']}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Color.fromARGB(221, 255, 255, 255),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              );
                            }),
                      ):const SizedBox(),
                    ],
                  ),
                  const Spacer(),
                ],
              )),
        ],
      ),
    );
  }
}
