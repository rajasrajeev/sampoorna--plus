import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/broadcast/broadcast_detail.dart';
import 'package:student_management/screens/parents/dashboard/parents_dashboard_screen.dart';
import 'package:student_management/services/api_services.dart';
import 'package:student_management/services/jwt_token_parser.dart';

class ChatDetail extends StatefulWidget {
  final String? studentCode;
  final String? studentName;
  final String? batchId;
  final String? fullName;
  const ChatDetail(
      {required this.studentCode,
      required this.studentName,
      required this.batchId,
      required this.fullName,
      super.key});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
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

class _ChatDetailState extends State<ChatDetail> {
  List<ChatMessage> messages = [];
  String? userType = "";
  String? userId = "";
  bool _loading = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getToken();
    getMessages();
  }

  getToken() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userType = prefs.getString('user_type');
      userId = prefs.getString('user_id');
    });
  }

  getMessages() async {
    setState(() {
      _loading = true;
    });
    final res = await getPersonalMessage(widget.studentCode);

    if (res.statusCode == 200) {
      setState(() {
        _loading = false;
        messages = [];
      });
      final responseData = jsonDecode(res.body);

      // Navigator.of(context).pop();
      var data = parseJwtAndSave(responseData['broadcast']);
      for (var i = 0; i < data['token'].length; i++) {
        setState(() {
          messages.add(ChatMessage(
              messageContent: data['token'][i]['message_text'],
              messageType: userId == data['token'][i]['sender_id']
                  ? 'sender'
                  : 'receiver',
              timeOfMessage:changeDateFormat(data['token'][i]['created_at'])));
        });
      }
      print("======================> $messages <==========================");
    } else {
      setState(() {
        _loading = false;
        messages = [];
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
changeDateFormat(String date){
final List<String> splitDate = date.split(RegExp(r"[-\s:]"));
  return '${splitDate[2]}-${splitDate[1]}-${splitDate[0]} ${splitDate[3]}:${splitDate[4]}:${splitDate[5]}';
}
  postMessages() async {
    final res = await sendMessage(searchController.text, widget.studentCode);

    if (res.statusCode == 200) {
       //final responseData = jsonDecode(res.body);
      setState(() {
        _loading = false;
      });
      searchController.clear();
      getMessages();
    } else {
       final responseData = jsonDecode(res.body);
      setState(() {
        _loading = false;
      });
      // Navigator.of(context).pop();
      Fluttertoast.showToast(
        msg: responseData["message"],
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
                  backgroundImage: AssetImage("assets/images/boy.png"),
                  maxRadius: 20,
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
                      const SizedBox(
                        height: 6,
                      ),
                      /* Text(
                        "sampoorna",
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 13),
                      ), */
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
          messages.isNotEmpty
              ? SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: SingleChildScrollView(
                    child: ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Container(
                            padding: const EdgeInsets.only(
                                left: 14, right: 14, top: 10, bottom: 10),
                            child: Align(
                                alignment:
                                    (messages[index].messageType == "receiver"
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (messages[index].messageType ==
                                            "receiver"
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
                                              ? const Color.fromARGB(
                                                  255, 0, 0, 0)
                                              : const Color.fromARGB(
                                                  255, 255, 255, 255)),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        messages[index].timeOfMessage,
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 180, 180, 180),
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                )));
                      },
                    ),
                  ),
                )
              : SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
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
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    heroTag: 'btn1',
                    onPressed: () {
                       String value = searchController.text.trim();
                             if(searchController.text.isNotEmpty && !(RegExp(r'^\s*$').hasMatch(value))) {
                               postMessages();
                             }
                     
                    },
                    backgroundColor: primaryColor,
                    elevation: 0,
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      /* floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: userType == 'PARENT'
          ? FloatingActionButton.extended(
              heroTag: 'btn2',
              backgroundColor: primaryColor,
              label: const Text("Broadcast"),
              icon: const Icon(Icons.sync),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BroadcastDetail(
                          studentName: widget.fullName,
                          studentCode: widget.batchId //Class List from dropdown
                          )),
                );
              },
            )
          : Container(), */
    );
  }
}
