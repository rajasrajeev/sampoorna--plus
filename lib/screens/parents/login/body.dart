import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_management/screens/parents/login/otp_screen/otp_screen.dart';

import '../../../components/custom_textfield.dart';
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
                  numberEnabled:true,
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
                        "username": phoneController.text,
                        "usert_type": "PARENT",
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
                                padding: const EdgeInsets.symmetric(vertical: 20),
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
          
                      // debugPrint("*****Response Status code*******");
                      // final res = await postLogin(data);
                      // debugPrint("*****Response Status code*******");
                      // debugPrint(res.statusCode.toString());
          
                      // if (res.statusCode == 200) {
                      //   //await Future.delayed(const Duration(seconds: 3));
                      //   // ignore: use_build_context_synchronously
                      //   Navigator.of(context).pop();
                      //   // ignore: use_build_context_synchronously
                      //   Navigator.pushReplacement(
                      //     context,
                      //     MaterialPageRoute(
                      //       builder: (context) =>
                      //           OtpScreen(userName: phoneController.text),
                      //     ),
                      //   );
                      // } else {
                      //   // ignore: use_build_context_synchronously
                      //   Navigator.of(context).pop();
                      //   Fluttertoast.showToast(
                      //     msg: "Mobile Number not added to database!!!",
                      //     gravity: ToastGravity.TOP,
                      //     timeInSecForIosWeb: 1,
                      //     backgroundColor: Colors.red,
                      //     textColor: Colors.white,
                      //     fontSize: 15.0,
                      //   );
                      // }
                    }
                    // ignore: use_build_context_synchronously
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OtpScreen(
                          userName: phoneController.text,
                        ),
                      ),
                    );
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
