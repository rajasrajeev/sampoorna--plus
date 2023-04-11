import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

class ChatDetail extends StatefulWidget {
  final String? studentCode;
  final String? studentName;
  const ChatDetail({required this.studentCode,this.studentName, super.key});

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

//Model class for Chat
class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class _ChatDetailState extends State<ChatDetail> {
  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello,", messageType: "receiver"),
    ChatMessage(messageContent: "Have you recieved Marklist?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hey , I havent recieved",
        messageType: "sender"),
    ChatMessage(messageContent: "Marklist is updated ", messageType: "receiver"),
    ChatMessage(
        messageContent: "k Thank you will check now", messageType: "sender"),
  ];
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
                    Navigator.pop(context);
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
                      Text(
                        "Online",
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
                  padding:
                      const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
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
                        child: Text(messages[index].messageContent,
                        style: TextStyle(
                          color: (messages[index].messageType == "receiver"
                              ? const Color.fromARGB(255, 0, 0, 0)
                              : const Color.fromARGB(255, 255, 255, 255)
                              ),
                        ),
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
