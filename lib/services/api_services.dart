// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:student_management/constants.dart';
import 'package:http/http.dart' as http;
import 'package:student_management/services/jwt_token_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

//API TO POST LOGIN
Future postLogin(data) async {
  final prefs = await SharedPreferences.getInstance();
  final response = await http.post(
    Uri.parse('$apiUrl/authenticateUser/format/json'),
    body: data,
  );
  // print("${response.body}");
  final token = jsonDecode(response.body);
  await prefs.setString('token', token['token']);
  await prefs.setString('user_id', token['user_id']);
  await prefs.setString('user_type', token['user_type']);

  var tokenData = parseJwtAndSave(token['token']);
  await prefs.setString('school_id', tokenData['token']['school_id']);
  await prefs.setString('username', tokenData['token']['username']);
  await prefs.setString(
      'permittedBatches', tokenData['permittedBatches'][0]['batch_id']);
  await prefs.setString('tokenData', tokenData.toString());
  return response;
}

//API TO POST LOGIN
Future studentList(data) async {
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
  final response = await http.post(
    Uri.parse('$apiUrl/student_list_all/format/json/'),
    headers: {
      'Authorization': 'Bearer ${token}',
    },
    body: data,
  );
/*   // print("${response.body}");
  final token = jsonDecode(response.body);
  await prefs.setString('token', token['token']);
  await prefs.setString('user_id', token['user_id']);
  await prefs.setString('user_type', token['user_type']);

  var tokenData = parseJwtAndSave(token['token']);
  await prefs.setString('tokenData', tokenData.toString()); */
  return response;
}
