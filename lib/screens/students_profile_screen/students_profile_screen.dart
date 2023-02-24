import 'package:flutter/material.dart';
import 'package:student_management/components/app_bar.dart';
import 'package:student_management/components/profile_details.dart';
import 'package:student_management/components/profile_header.dart';

class StudentsProfileScreen extends StatefulWidget {
  const StudentsProfileScreen({super.key});

  @override
  State<StudentsProfileScreen> createState() => _StudentsProfileScreenState();
}

class _StudentsProfileScreenState extends State<StudentsProfileScreen> {
  final GlobalKey<ScaffoldState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // ignore: prefer_const_constructors
    return Scaffold(
      key: key,
      appBar: AppBar(title: const Text("Profile")),
      body: Column(
        children: <Widget>[
          const ProfileHeader(
              imageUrl: "assets/images/profile.png",
              name: "Student 1",
              grade: "VIII A"),
          Center(
            child: Column(
              children: const <Widget>[
                ProfileDetails(title: "First Name", value: "Teacher"),
                ProfileDetails(title: "Last Name", value: "1340A"),
                ProfileDetails(title: "Email", value: "teacher@mailinator.com"),
                ProfileDetails(title: "School ID", value: "5033"),
                ProfileDetails(title: "Email", value: "Teacher"),
              ],
            ),
          ),
          Center()
        ],
      ),
      backgroundColor: Colors.white,
    );
  }
}
