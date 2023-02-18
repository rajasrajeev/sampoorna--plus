import 'package:flutter/material.dart';
import 'package:student_management/components/forms/password_field.dart';
import 'package:student_management/components/forms/text_field.dart';
import 'package:student_management/components/submit_button.dart';
import 'package:student_management/screens/home_screen/home_screen.dart';

import '../main_screen/main_screen.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Image.asset(
          "assets/images/splash.png",
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 50),
        Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                label: "Username",
                minLine: 1,
                maxLine: 1,
                enabled: true,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return "please enter username";
                  }
                  return null;
                },
              ),
              PasswordField(
                label: "Password",
                minLine: 1,
                maxLine: 1,
                enabled: true,
                validator: (value) {
                  if (value == null || value.length < 1) {
                    return "please enter password";
                  }
                  return null;
                },
              ),
              SubmitButton(
                label: "Login",
                onClick: () async {
                  // material page route
                  if (formKey.currentState!.validate()) {                  
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainScreen(),
                        ),
                      );
                  } else {}
                },
              ),
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }
}
