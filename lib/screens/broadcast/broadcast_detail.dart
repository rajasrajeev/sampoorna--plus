import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants.dart';
import '../main_screen/main_screen.dart';
import '../parents/dashboard/parents_dashboard_screen.dart';

class BroadcastDetail extends StatefulWidget {
  final String? studentCode;
  final String? studentName;
  const BroadcastDetail({required this.studentCode, this.studentName, super.key});

  @override
  State<BroadcastDetail> createState() => _BroadcastDetailState();
}
//Model class for Chat
class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}
class _BroadcastDetailState extends State<BroadcastDetail> {
    List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello,", messageType: "receiver"),
    ChatMessage(
        messageContent: "Have you recieved Marklist?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hey , I havent recieved", messageType: "sender"),
    ChatMessage(
        messageContent: "Marklist is updated ", messageType: "receiver"),
    ChatMessage(
        messageContent: "k Thank you will check now", messageType: "sender"),
  ];
    String? userType = "";

  @override
  void initState() {
    super.initState();
    getToken();
  }
    getToken() async {
    final prefs = await SharedPreferences.getInstance();
    userType = prefs.getString('user_type');
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
                   Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => userType == "PARENT"
                          ? const ParentsDashboardScreen()
                          : const MainScreen(),
                    ),
                  );
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
                        height: size.height*0.003,
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
                            const SizedBox(height: 10,),
                            const Text(
                              "1-2-23",
                              style: TextStyle(
                                  color: Color.fromARGB(255, 180, 180, 180), fontSize: 10),
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
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: "Write message...",
                          hintStyle: TextStyle(color: Colors.black54),
                          border: InputBorder.none),
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  FloatingActionButton(
                    onPressed: () {},
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
    );
  }
}