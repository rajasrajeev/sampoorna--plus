// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:student_management/constants.dart';
import 'package:http/http.dart' as http;
import 'package:student_management/models/permitted_classes.dart';
import 'package:student_management/models/teachers.dart';
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

  if (response.statusCode == 200) {
    final token = jsonDecode(response.body);
    await prefs.setString('token', token['token']);
    await prefs.setString('user_id', token['user_id']);
    await prefs.setString('user_type', token['user_type']);
    //await prefs.setString('isLoggedIn',"true");

    var tokenData = parseJwtAndSave(token['token']);

    await prefs.setString('school_id', tokenData['token']['school_id']);
    await prefs.setString('first_name', tokenData['token']['first_name']);
    await prefs.setString('last_name', tokenData['token']['last_name']);
    await prefs.setString('username', tokenData['token']['username']);
    await prefs.setString(
        'permittedBatches', tokenData['permittedBatches'][0]['batch_id']);
    await prefs.setString('class', tokenData['permittedBatches'][0]['class']);
    await prefs.setString('name', tokenData['permittedBatches'][0]['name']);
    await prefs.setString('tokenData', tokenData.toString());
    // Teachers res = Teachers.fromJson(tokenData);
    await prefs.setString('loginData', json.encode(tokenData));
  } else {}
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
  return response;
}

//API TO POST LOGIN
Future studentDetails(studentCode) async {
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
  final response = await http
      .post(Uri.parse('$apiUrl/getStudentDetailsById/format/json/'), headers: {
    'Authorization': 'Bearer ${token}',
  }, body: {
    "studentCode": studentCode
  });
  return response;
}

//API TO POST LOGIN
Future teacherProfile(user_id) async {
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
  final response = await http
      .post(Uri.parse('$apiUrl/teacherProfileById/format/json/'), headers: {
    'Authorization': 'Bearer ${token}',
  }, body: {
    "user_id": user_id
  });
  return response;
}

//API TO POST LOGIN
Future attendanceBetweenDates(date1, date2, school_id, batch_id) async {
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
  final response = await http
      .post(Uri.parse('$apiUrl/attendenceCountByDates/format/json/'), headers: {
    'Authorization': 'Bearer ${token}',
  }, body: {
    "date1": date1,
    "date2": date2,
    "school_id": school_id,
    "batch_id": batch_id
  });
  return response;
}

//API TO POST LOGIN
Future attendanceOnDate(date, page, school_id, batch_id) async {
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
  final response = await http
      .post(Uri.parse('$apiUrl/student_list_absentee/format/json/'), headers: {
    'Authorization': 'Bearer ${token}',
  }, body: {
    "page": page,
    "date": date,
    "school_id": school_id,
    "batch_id": batch_id
  });
  return response;
}

//API TO POST Add Attendance
Future addAttendance(payload) async {
     debugPrint("**********PAyload Response***********");
    debugPrint("$payload");

  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
   debugPrint("**********API Response***********");
  final response = await http
      .post(Uri.parse('$apiUrl/entry_form/format/json/'), headers: {
    'Authorization': 'Bearer $token',
  }, body: payload

  );
   debugPrint("**********API Response***********");
   // debugPrint("${response.body}");
  return response;
}