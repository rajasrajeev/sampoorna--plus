import 'package:flutter/material.dart';
import 'package:student_management/components/app_bar.dart';

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
        appBar:AppBar(),
        body: const Center(child: Text("Under Maintenance")),
        backgroundColor: Colors.white,
      ),
    );
  }
}
