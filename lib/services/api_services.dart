// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:student_management/constants.dart';
import 'package:http/http.dart' as http;
import 'package:student_management/services/jwt_token_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http_parser/http_parser.dart';

//API TO POST LOGIN
Future postLogin(data) async {
  final prefs = await SharedPreferences.getInstance();
  final response = await http.post(
    Uri.parse('$apiUrl/SampoornaApp/authenticateUser/format/json'),
    body: data,
  );
  if (response.statusCode == 200) {
    final token = jsonDecode(response.body);
    await prefs.setString('token', token['token']);
    await prefs.setString('user_id', token['user_id']);
    await prefs.setString('user_type', token['user_type']);

    var tokenData = parseJwtAndSave(token['token']);
    await prefs.setString('school_id', tokenData['token']['school_id']);
    await prefs.setString('first_name', tokenData['token']['first_name']);
    await prefs.setString('last_name', tokenData['token']['last_name']);
    await prefs.setString('username', tokenData['token']['username']);

    await prefs.setString('tokenData', tokenData.toString());
    await prefs.setString('loginData', json.encode(tokenData));
  } else {}
  return response;
}

//API TO POST LOGIN
Future studentList(data) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.post(
    Uri.parse('$apiUrl/SampoornaApp/student_list_all/format/json/'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: data,
  );
  return response;
}

//API TO POST LOGIN
Future studentDetails(studentCode) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.post(
      Uri.parse('$apiUrl/SampoornaApp/getStudentDetailsById/format/json/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "studentCode": studentCode
      });
  return response;
}

//API TO POST LOGIN
Future teacherProfile(user_id) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.post(
      Uri.parse('$apiUrl/SampoornaApp/teacherProfileById/format/json/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "user_id": user_id
      });
  return response;
}

//API TO POST LOGIN
Future attendanceBetweenDates(date1, date2, school_id, batch_id) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.post(
      Uri.parse('$apiUrl/SampoornaApp/attendenceCountByDates/format/json/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "date1": date1,
        "date2": date2,
        "school_id": school_id,
        "batch_id": batch_id
      });
  return response;
}

//API TO POST LOGIN
Future attendanceOnDate(date, school_id, batch_id) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.post(
      Uri.parse('$apiUrl/SampoornaApp/student_list_absentee/format/json/'),
      headers: {
        'Authorization': 'Bearer $token',
      },
      body: {
        "date": date,
        "school_id": school_id,
        "batch_id": batch_id
      });

  return response;
}

//API TO POST Add Attendance
Future addAttendance(payload) async {
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
  final response = await http.post(
      Uri.parse('$apiUrl/SampoornaApp/entry_form/format/json/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json'
      },
      body: json.encode(payload));
  return response;
}

Future broadcastGet(payload) async {
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
  final response = await http.post(
      Uri.parse(
          '$apiUrl/Broadcast/get_broadcast_messages_by_sender/format/json/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json'
      },
      body: json.encode(payload));
  return response;
}

Future broadcastSend(payload) async {
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
  final response = await http.post(
      Uri.parse('$apiUrl/Broadcast/broadcast_save/format/json/'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-type': 'application/json'
      },
      body: json.encode(payload));
  return response;
}

//API TO POST Add Attendance
Future getDivisionList(payload) async {
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
  final response = await http.post(
      Uri.parse('$apiUrl/SampoornaApp/getBatchesofSchool/format/json/'),
      headers: {
        'Authorization': 'Bearer $token',
        // 'Content-type': 'application/json'
      },
      body: payload);
  return response;
}

//API TO POST LOGIN
Future parentLogin(data) async {
  final prefs = await SharedPreferences.getInstance();
  final response = await http.post(
    Uri.parse('$parentApiUrl/SampoornaParent/parentLogin/format/json/'),
    body: data,
  );
  if (response.statusCode == 200) {
    final token = jsonDecode(response.body);
    await prefs.setString('token', token['token']);
    await prefs.setString('user_id', token['user_id']);
    await prefs.setString('user_type', token['user_type']);

    var tokenData = parseJwtAndSave(token['token']);

    await prefs.setString('childDetails', json.encode(tokenData['data']));
  } else {}
  return response;
}

//API TO POST LOGIN
Future sendOTP(data) async {
  final prefs = await SharedPreferences.getInstance();
  final response = await http.post(
      Uri.parse('$parentApiUrl/SampoornaParent/authenticateOTP/format/json/'),
      body: data);
  if (response.statusCode == 200) {
  } else {}
  return response;
}

//API TO POST LOGIN
Future validateOTP(data, token) async {
  // final prefs = await SharedPreferences.getInstance();
  final response = await http.post(
    Uri.parse('$parentApiUrl/SampoornaParent/OTPValidation/format/json/'),
    body: data,
    headers: {
      'Authorization': 'Bearer $token',
      // 'Content-type': 'application/json'
    },
  );
  if (response.statusCode == 200) {
  } else {}
  return response;
}

//API TO POST LOGIN
Future parentRegistration(data, token) async {
  // final prefs = await SharedPreferences.getInstance();
  final response = await http.post(
    Uri.parse('$parentApiUrl/SampoornaParent/ParentRegistration/format/json/'),
    body: data,
    headers: {
      'Authorization': 'Bearer $token',
      // 'Content-type': 'application/json'
    },
  );
  if (response.statusCode == 200) {
  } else {}
  return response;
}

//API TO POST LOGIN
Future lastWeekAttendance(data) async {
  final prefs = await SharedPreferences.getInstance();
  var token = await prefs.getString('token');
  final response = await http.post(
    Uri.parse(
        '$parentApiUrl/SampoornaParent/parentLastWeekAttendence/format/json/'),
    body: data,
    headers: {
      'authorization': 'Bearer $token',
      // 'Content-type': 'application/json'
    },
  );
  return response;
}

//API TO POST LOGIN
Future individualAttendanceForStudent(data, token) async {
  // final prefs = await SharedPreferences.getInstance();
  final response = await http.post(
    Uri.parse(
        '$parentApiUrl/SampoornaParent/parentStudentAbsenteeIndividual/format/json/'),
    body: data,
    headers: {
      'authorization': 'Bearer $token',
      // 'Content-type': 'application/json'
    },
  );
  if (response.statusCode == 200) {
  } else {}
  return response;
}

//API TO UPLOAD IMAGE
// Future uploadPhoto(payload) async {
//   final prefs = await SharedPreferences.getInstance();
//   var token = await prefs.getString('token');
//   debugPrint(
//       "**************Image upload function called************************");

//   final response = await http.post(
//       Uri.parse('$apiUrl/SampoornaApp/upload_image_sampoorna/format/json/'),
//       headers: {
//         'Authorization': 'Bearer $token',
//         'Content-type': 'application/json'
//       },
//       body: json.encode(payload));
//   return response;
// }

// Future uploadPhoto(List<int> imageBytes, String studentCode) async {
//   final prefs = await SharedPreferences.getInstance();
//   var token = await prefs.getString('token');
//   var mimeType = 'image/jpeg';
//   try {
//     var request = http.MultipartRequest('POST',
//         Uri.parse('$apiUrl/SampoornaApp/upload_image_sampoorna/format/json/'));

//     request.headers.addAll({"Authorization": 'Bearer $token'});
//     ByteData byteData =
//         await rootBundle.load('assets/images/photo_2023-05-03_16-18-01.jpg');
//     List<int> imageData = byteData.buffer.asUint8List();
//     request.files.add(
//       http.MultipartFile.fromBytes('image_data', imageData,
//           contentType: MediaType.parse(mimeType), filename: 'myImage.png'),
//     );

//     request.fields['student_code'] = studentCode;

//     final response = await request.send();
//     return response;
//   } catch (e) {
//     debugPrint("************exception*********");
//     debugPrint(e.toString());
//   }
// }
Future uploadPhoto(File imageFile, String studentCode) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
debugPrint("**uploadPhoto API ***");
  http.MultipartRequest request = http.MultipartRequest("POST", Uri.parse('$apiUrl/SampoornaApp/upload_image_sampoorna/format/json/'));

  Map<String, String> headers = {
    'Content-Type': 'multipart/form-data',
    'Authorization': 'Bearer $token'
  };

   var stream = http.ByteStream(imageFile.openRead());
  stream.cast();

  var length = await imageFile.length();
debugPrint("**API image Length*** $length");
debugPrint("**API image image format*** ${imageFile.path.split('/').last}");
  var multipartFile = http.MultipartFile(
    'image_data', 
    stream, 
    length,
    filename: imageFile.path.split('/').last);

  request.files.add(multipartFile);

  request.headers.addAll(headers);

  request.fields['student_code'] = studentCode.toString();

  final streamedResponse = await request.send();

  var response = await http.Response.fromStream(streamedResponse);
  return response;
}


Future getWebViewURL() async {
  final response = await http.post(
      Uri.parse('$apiUrl/SampoornaApp/getwebviewURL/format/json/'),
      headers: {},
      body: {});

  return response;
}

Future getWebView(link) async {
  final prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  final response = await http.get(Uri.parse('$link'), headers: {
    'Authorization': 'Bearer $token',
  });
  return response;
}
