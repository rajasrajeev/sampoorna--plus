// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

import '../../constants.dart';
import '../main_screen/main_screen.dart';
import '../parents/dashboard/parents_dashboard_screen.dart';

class BroadcastDetail extends StatefulWidget {
  final String? studentCode;
  final String? studentName;
  const BroadcastDetail(
      {required this.studentCode, this.studentName, super.key});

  @override
  State<BroadcastDetail> createState() => _BroadcastDetailState();
}

//Model class for Chat
class ChatMessage {
  String messageContent;
  String messageType;
  String timeOfMessage;
  ChatMessage(
      {required this.messageContent,
      required this.messageType,
      required this.timeOfMessage});
}

class _BroadcastDetailState extends State<BroadcastDetail> {
  List<ChatMessage> messages = [];
  String? userType = "";
  String? userId = "";
  bool _loading = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getToken();
    getBroadcastMessages();
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('user_type');
    userId = prefs.getString('user_id');
  }

  getBroadcastMessages() async {
    final res = await getBroadcastMessage(widget.studentCode);

    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      final responseData = jsonDecode(res.body);

      // Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['broadcast']);
      for (var i = 0; i < data['token'].length; i++) {
        setState(() {
          messages.add(ChatMessage(
              messageContent: data['token'][i]['body'],
              messageType:
                  userId == data['token'][i]['user_id'] ? 'sender' : 'receiver',
              timeOfMessage: data['token'][i]['created_at']));
        });
      }
    } else {
      setState(() {
        _loading = false;
      });
      // Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Unable to Sync Students List Now",
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 15.0,
      );
    }
  }

  postBroadcastMessages() async {
    final res = await sendBroadcastMessage(
        widget.studentCode, searchController.text, 'Broadcast');

    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
      });
      final responseData = jsonDecode(res.body);
      searchController.clear();
      // Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['broadcast']);
      debugPrint("individualAttendanceForStudent Data ********* $data");
      getBroadcastMessages();
      /* setState(() {
        attendanceDates = data['attendance_data'];
      }); */
    } else {
      setState(() {
        _loading = false;
      });
      // Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: "Unable to Sync Students List Now",
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
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    if (userType == "PARENT") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ParentsDashboardScreen()),
                      );
                    } else {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 2,
                ),
                const CircleAvatar(
                  backgroundColor: Colors.white38,
                  backgroundImage: AssetImage("assets/images/sampoorna.png"),
                  radius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "${widget.studentName.toString()} (${widget.studentCode.toString()})",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(
                        height: size.height * 0.003,
                      ),
                      Text(
                        "sampoorna",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                  padding: const EdgeInsets.only(
                      left: 14, right: 14, top: 10, bottom: 10),
                  child: Align(
                      alignment: (messages[index].messageType == "receiver"
                          ? Alignment.topLeft
                          : Alignment.topRight),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: (messages[index].messageType == "receiver"
                              ? Colors.grey.shade200
                              : primaryColor),
                        ),
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              messages[index].messageContent,
                              style: TextStyle(
                                color: (messages[index].messageType ==
                                        "receiver"
                                    ? const Color.fromARGB(255, 0, 0, 0)
                                    : const Color.fromARGB(255, 255, 255, 255)),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              messages[index].timeOfMessage,
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 180, 180, 180),
                                  fontSize: 10),
                            ),
                          ],
                        ),
                      )));
            },
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  // GestureDetector(
                  //   onTap: (){
                  //   },
                  //   child: Container(
                  //     height: 30,
                  //     width: 30,
                  //     decoration: BoxDecoration(
                  //       color:primaryColor,
                  //       borderRadius: BorderRadius.circular(30),
                  //     ),
                  //     child: Icon(Icons.add, color: Colors.white, size: 20, ),
                  //   ),
                  // ),
                  const SizedBox(
                    width: 15,
                  ),
                  userType != 'PARENT'
                      ? Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: const InputDecoration(
                                hintText: "Write message...",
                                hintStyle: TextStyle(color: Colors.black54),
                                border: InputBorder.none),
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                  const SizedBox(
                    width: 15,
                  ),
                  userType != 'PARENT'
                      ? FloatingActionButton(
                          onPressed: () {
                            postBroadcastMessages();
                          },
                          backgroundColor: primaryColor,
                          elevation: 0,
                          child: const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 18,
                          ),
                        )
                      : const SizedBox(
                          width: 0,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
