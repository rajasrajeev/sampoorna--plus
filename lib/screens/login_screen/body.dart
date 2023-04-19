// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/components/custom_dropdown.dart';
import 'package:student_management/components/forms/password_field.dart';
import 'package:student_management/components/forms/text_field.dart';
import 'package:student_management/components/submit_button.dart';
import 'package:student_management/screens/parents/dashboard/parents_dashboard_screen.dart';
import 'package:student_management/screens/parents/login/otp_screen/otp_screen.dart';
import 'package:student_management/screens/parents/login/parent_otp_login.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

import '../main_screen/main_screen.dart';

class Body extends StatefulWidget {
  late String passedRole;
  Body({super.key, required this.passedRole});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController parentUsernameController =
      TextEditingController();
  final TextEditingController parentPasswordController =
      TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController dropDownController = TextEditingController();
  String role = "";
  List roles = [
    {"id": "TEACHER", "name": "TEACHER"},
    {"id": "HM", "name": "HM"},
    {"id": "PARENT", "name": "PARENT"}
  ];
  @override
  void initState() {
    super.initState();
    getRoles();
  }

  Future<void> getRoles() async {
    // setState(() {
    //   roles = [];
    // });
    if (widget.passedRole == "PARENT") {
      setState(() {
        role = widget.passedRole;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: <Widget>[
        const Spacer(),
        Image.asset(
          "assets/images/sampoorna.png",
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 50),
        Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              CustomDropDown(
                label: "Select Your Role",
                value: role,
                data: roles,
                onChange: (value) {
                  setState(() {
                    role = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please select your role";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              role == "PARENT"
                  ? Column(
                      children: [
                        CustomTextField(
                          label: "Username",
                          minLine: 1,
                          maxLine: 1,
                          enabled: true,
                          controller: parentUsernameController,
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
                          controller: parentPasswordController,
                          validator: (value) {
                            if (value == null || value.length < 1) {
                              return "please enter password";
                            }
                            return null;
                          },
                        ),
                        SubmitButton(
                          label: "Submit",
                          onClick: () async {
                            // material page route
                            if (formKey.currentState!.validate()) {
                              var data = {
                                "username": parentUsernameController.text,
                                "password": parentPasswordController.text,
                                "usert_type": role,
                              };
                              // ignore: use_build_context_synchronously
                              showDialog(
                                  // The user CANNOT close this dialog  by pressing outsite it
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (_) {
                                    return Dialog(
                                      // The background color
                                      backgroundColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            // The loading indicator
                                            CircularProgressIndicator(),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            // Some text
                                            Text('Loading...')
                                          ],
                                        ),
                                      ),
                                    );
                                  });

                              final res = await parentLogin(data);

                              if (res.statusCode == 200) {
                                //await Future.delayed(const Duration(seconds: 3));
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                                // ignore: use_build_context_synchronously
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ParentsDashboardScreen(),
                                  ),
                                );
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                  msg:
                                      "Username or password is incorrect. Please try again later!!!",
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 15.0,
                                );
                              }
                            }
                          },
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: size.width * 0.2),
                          child: Row(
                            children: [
                              const Text("Doesn't have an account?"),
                              TextButton(
                                child: const Text(
                                  "Signup",
                                  style: TextStyle(fontSize: 20),
                                ),
                                onPressed: () {
                                  //Mobile number screen screen
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ParentOtpLogin(),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : Column(
                      children: [
                        CustomTextField(
                          label: "Username",
                          minLine: 1,
                          maxLine: 1,
                          enabled: true,
                          controller: usernameController,
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
                          controller: passwordController,
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
                              var data = {
                                "username": usernameController.text,
                                "password": passwordController.text,
                                "usert_type": role,
                              };
                              // ignore: use_build_context_synchronously
                              showDialog(
                                  // The user CANNOT close this dialog  by pressing outsite it
                                  barrierDismissible: true,
                                  context: context,
                                  builder: (_) {
                                    return Dialog(
                                      // The background color
                                      backgroundColor: Colors.white,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 20),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: const [
                                            // The loading indicator
                                            CircularProgressIndicator(),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            // Some text
                                            Text('Loading...')
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                              final res = await postLogin(data);

                              if (res.statusCode == 200) {
                                // ignore: use_build_context_synchronously

                                // ignore: use_build_context_synchronously
                                final token = jsonDecode(res.body);

                                if (token["user_type"] == "ADMIN") {
                                  if (token['message'] != "No Data Found!") {
                                    var tokenData =
                                        parseJwtAndSave(token['token']);
                                    final response = await getDivisionList({
                                      "school_id": tokenData['token']
                                          ['school_id'],
                                      "startYear": "2022"
                                    });
                                    if (response.statusCode == 200) {
                                      Navigator.of(context).pop();
                                      final data = jsonDecode(response.body);
                                      var tokenData =
                                          parseJwtAndSave(data['data']);
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      var details =
                                          prefs.getString('loginData');
                                      dynamic permittedBatches =
                                          json.decode(details!);
                                      permittedBatches['permittedBatches'] =
                                          tokenData['token'];
                                      await prefs.setString('tokenData',
                                          permittedBatches.toString());
                                      await prefs.setString('loginData',
                                          json.encode(permittedBatches));
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const MainScreen(),
                                        ),
                                      );
                                    } else {
                                      Navigator.of(context).pop();
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();
                                      await preferences.clear();
                                      Fluttertoast.showToast(
                                        msg:
                                            "Unable to fetch class list. Contact Admin!!!",
                                        gravity: ToastGravity.TOP,
                                        timeInSecForIosWeb: 1,
                                        backgroundColor: Colors.red,
                                        textColor: Colors.white,
                                        fontSize: 15.0,
                                      );
                                    }
                                  } else {
                                    Navigator.of(context).pop();
                                    SharedPreferences preferences =
                                        await SharedPreferences.getInstance();
                                    await preferences.clear();
                                    Fluttertoast.showToast(
                                      msg:
                                          "No Class List Found. Contact Admin!!!",
                                      gravity: ToastGravity.TOP,
                                      timeInSecForIosWeb: 1,
                                      backgroundColor: Colors.red,
                                      textColor: Colors.white,
                                      fontSize: 15.0,
                                    );
                                  }
                                } else {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MainScreen(),
                                    ),
                                  );
                                }
                              } else {
                                // ignore: use_build_context_synchronously
                                Navigator.of(context).pop();
                                Fluttertoast.showToast(
                                  msg:
                                      "Username or password is incorrect. Please try again later!!!",
                                  gravity: ToastGravity.TOP,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 15.0,
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
            ],
          ),
        ),
        const Spacer()
      ],
    );
  }
}
