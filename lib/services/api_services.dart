// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_management/constants.dart';
import 'package:http/http.dart' as http;
import 'package:student_management/services/jwt_token_parser.dart';

//API TO POST LOGIN
Future postLogin(data) async {
  final response = await http.post(
    Uri.parse('$apiUrl/authenticateUser/format/json'),
    /* headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    }, */
    body: data,
  );
  print("${response.body}");
  final token = jsonDecode(response.body);
  print("--------------------------> ${token}");

  var tokenData = parseJwt(response.body);
  print("======================> $tokenData");

  if (response.statusCode == 200) {
    Fluttertoast.showToast(
      msg: "An otp has been sent.",
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 15.0,
    );
    return response;
  }
  if (response.statusCode == 404) {
    Fluttertoast.showToast(
      msg: 'Invalid username.',
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 15.0,
    );
  } else {
    throw Exception('Failed to post get otp');
  }
}
