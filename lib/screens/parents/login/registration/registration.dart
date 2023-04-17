import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:student_management/components/custom_textfield.dart';
import 'package:student_management/components/forms/password_field.dart';
import 'package:student_management/components/submit_button.dart';
import 'package:student_management/screens/login_screen/login_screen.dart';

class Registration extends StatefulWidget {
  const Registration({super.key});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController parentPasswordController =
      TextEditingController();
  final TextEditingController confirmParentPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const SizedBox(height: 30),
          Image.asset(
            "assets/images/sampoorna.png",
            width: 200,
            height: 200,
          ),
          const SizedBox(height: 30),
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: "First Name",
                  minLine: 1,
                  maxLine: 1,
                  enabled: true,
                  controller: nameController,
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return "please enter your name";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: "Email",
                  minLine: 1,
                  maxLine: 1,
                  enabled: true,
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return "please enter Email";
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                CustomTextField(
                  label: "Mobile Number",
                  minLine: 1,
                  maxLine: 1,
                  enabled: true,
                  controller: phoneController,
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return "please enter Mobile Number";
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
                PasswordField(
                  label: "Confirm Password",
                  minLine: 1,
                  maxLine: 1,
                  enabled: true,
                  controller: confirmParentPasswordController,
                  validator: (value) {
                    if (value == null || value.length < 1) {
                      return "please confirm password";
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

                        //Remove when API available
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(passedRoles:"PARENT"),
                          ),
                        );
                      }
                    })
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
