// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/parents/login/registration/registration.dart';

import '../../../../components/submit_button.dart';
import '../../../../services/api_services.dart';

class OtpScreen extends StatefulWidget {
  final String userName;
  final String generatedOtp;
  final String token;
  const OtpScreen(
      {super.key,
      required this.userName,
      required this.generatedOtp,
      required this.token});

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
    final data = {
      "mobile": widget.userName,
      "entered_otp": otp,
      "generated_otp": widget.generatedOtp
    };
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
    final res = await validateOTP(data, widget.token);

    if (res.statusCode == 200) {
      Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "OTP verification successful",
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 15.0,
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Registration(userName: widget.userName, token: widget.token)),
      );
    } else {
      Navigator.of(context).pop();

      Fluttertoast.showToast(
        msg: "Error! Something went wrong!!!",
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }
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
              length: 5,
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
