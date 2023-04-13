import 'package:flutter/material.dart';

import '../../components/student_profile_card.dart';

class Nothing extends StatefulWidget {
  const Nothing({super.key});

  @override
  State<Nothing> createState() => _NothingState();
}

class _NothingState extends State<Nothing> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ignore: prefer_const_constructors
    return SafeArea(
      top: true,
      child: Scaffold(
        key: key,
        appBar: AppBar(),
        body: Column(
          children: [
            const Center(child: Text("Under Maintenance")),
            //ProfilePicturePicker(),

            SizedBox(
              height: size.height * 0.85,
              child: Stack(
                children: [
                  SingleChildScrollView(
                      child: Column(
                    children: const [
                      StudentProfileCard(),
                      SizedBox(
                        height: 20,
                      ),
                      StudentProfileCard(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  )),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
    );
  }
}
