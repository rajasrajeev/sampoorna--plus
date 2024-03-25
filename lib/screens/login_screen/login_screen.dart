import 'package:flutter/material.dart';
import 'package:student_management/screens/login_screen/body.dart';

class LoginScreen extends StatelessWidget {
  final String passedRoles;
  const LoginScreen({super.key, required this.passedRoles});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login_background.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Body(
          passedRole: passedRoles,
        ),
      ),
    );
  }
}
