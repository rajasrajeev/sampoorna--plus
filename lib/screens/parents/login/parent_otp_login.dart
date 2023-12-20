import 'package:flutter/material.dart';
import 'package:student_management/screens/parents/login/body.dart';



class ParentOtpLogin extends StatelessWidget {
  const ParentOtpLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/login_background.jpg"),
              fit: BoxFit.cover)),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: Body(),
      ),
    );
  }
}