// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_management/screens/parents/login/otp_screen/otp_screen.dart';
import 'package:student_management/services/jwt_token_parser.dart';
import 'dart:convert';

import 'package:student_management/components/forms/text_field.dart';
import '../../../components/submit_button.dart';
import '../../../services/api_services.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 50),
          Image.asset(
            "assets/images/sampoorna.png",
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 50),
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: "Mobile Number",
                  minLine: 1,
                  maxLine: 1,
                  enabled: true,
                  // numberEnabled: true,
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return "please enter Mobile Number";
                    }
                    return null;
                  },
                ),
                // TextButton(
                //   child: const Text(
                //     "Don't have an account Signup Now",
                //     style: TextStyle(fontSize: 10),
                //   ),
                //   onPressed: () {
                //     //Mobile number screen screen
                //     Navigator.pushReplacement(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => OtpScreen(
                //             userName: phoneController.text),
                //       ),
                //     );
                //   },
                // ),
                SubmitButton(
                  label: "Submit",
                  onClick: () async {
                    // material page route
                    if (formKey.currentState!.validate()) {
                      var data = {
                        "mobile": phoneController.text,
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
                                padding:
                                    const EdgeInsets.symmetric(vertical: 20),
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

                      final res = await sendOTP(data);
                      final token = jsonDecode(res.body);

                      if (res.statusCode == 200) {
                        var tokenData = parseJwtAndSave(token['Data']);
                        Navigator.of(context).pop();

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OtpScreen(
                                userName: phoneController.text,
                                generatedOtp: tokenData['generated_otp'],
                                token: token['Data']),
                          ),
                        );
                      } else {
                        if (token['status'] == 401) {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg: token['message'],
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 15.0,
                          );
                        } else {
                          Navigator.of(context).pop();
                          Fluttertoast.showToast(
                            msg:
                                "Something went wrong. Please retry or contact admin!!!",
                            gravity: ToastGravity.TOP,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 15.0,
                          );
                        }
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
