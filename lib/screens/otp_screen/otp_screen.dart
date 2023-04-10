import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:student_management/constants.dart';

import '../../components/submit_button.dart';

class OtpScreen extends StatefulWidget {
  final String userName;
  const OtpScreen({super.key, required this.userName});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  String otp = "";
  bool isLoading = false;

  void onSubmit() async {
    setState(() {
      isLoading = true;
    });
    final data = jsonEncode(<String, String>{
      "username": widget.userName,
      "otp": otp,
    });

    // final res = await authOTP(data);
    // setState(() {
    //   isLoading = false;
    // });
    // if (res.statusCode == 200) {
    //   Fluttertoast.showToast(
    //     msg: "User login successfull.",
    //     gravity: ToastGravity.TOP,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.green,
    //     textColor: Colors.white,
    //     fontSize: 15.0,
    //   );
    //   // ignore: use_build_context_synchronously
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const MainScreen(),
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Color.fromRGBO(30, 60, 87, 1),
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2.0),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          const Spacer(),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.15),
            child: const Text(
              'Enter OTP received through mobile number',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Center(
            child: Pinput(
              length: 6,
              defaultPinTheme: defaultPinTheme,
              validator: (s) {
                return null;
              },
              pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
              showCursor: true,
              onCompleted: (pin) => {
                setState(() {
                  otp = pin;
                }),
              },
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.030),
            child: SubmitButton(
              label: 'Submit',
             // loading: isLoading,
              onClick: () {
                onSubmit();
              },
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
