import 'package:flutter/material.dart';
import 'package:student_management/components/student_profile_card.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/exams/exams.dart';

class ChildCard extends StatefulWidget {
  final List day;
  final List date;
  final String fullName;
  final String grade;
  final String division;
  final String school;
  const ChildCard(
      {super.key,
      required this.day,
      required this.date,
      required this.fullName,
      required this.grade,
      required this.division,
      required this.school});

  @override
  State<ChildCard> createState() => _ChildCardState();
}

class _ChildCardState extends State<ChildCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        constraints: BoxConstraints(maxWidth: size.width * 0.9),
        margin: const EdgeInsets.fromLTRB(5, 5, 5, 5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(166, 142, 138, 138),
              spreadRadius: 1,
              blurRadius: 4,
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 150,
              child: Stack(
                children: [
                  ClipPath(
                    clipper: AvatarClipper(),
                    child: Container(
                      height: 100,
                      decoration: const BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 11,
                    top: 50,
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("assets/images/boy.png"),
                        ),
                        const SizedBox(width: 20),
                        SizedBox(
                          width: size.width * 0.5,
                          //height: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 50,
                                child: Text(
                                  widget.fullName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFFFFFFF),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "${widget.grade} ${widget.division}",
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 8)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, bottom: 8.0),
                      child: Column(
                        children: [
                          Text(
                            widget.school,
                            style: buildMontserrat(
                              const Color(0xFF000000),
                              fontWeight: FontWeight.normal,
                            ),
                            overflow: TextOverflow.clip,
                          ),
                        ],
                      ),
                    ),
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.blue),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.send_rounded,
                      ),
                      label: const Text(
                        'Messages',
                      ),
                    ),
                    /* TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.blue),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => {},
                      icon: const Icon(
                        Icons.send_rounded,
                      ),
                      label: const Text(
                        'Attendances',
                      ),
                    ), */
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        textStyle: const TextStyle(color: Colors.blue),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () => {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ExamsScreen()),
                        )
                      },
                      icon: const Icon(
                        Icons.send_rounded,
                      ),
                      label: const Text(
                        'Exams',
                      ),
                    ),
                  ],
                )),
            Container(
              height: 50,
              width: MediaQuery.of(context).size.width - 79,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.black, width: 0.5)),
              child: Row(children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    width: (MediaQuery.of(context).size.width - 80) / 7,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        // reverse: true,
                        itemCount: 7,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Container(
                            height: 50,
                            width: (MediaQuery.of(context).size.width - 80) / 7,
                            decoration: BoxDecoration(
                                border: Border(
                              right: (index != 6)
                                  ? const BorderSide(
                                      color: Color.fromARGB(255, 105, 25, 25),
                                      width: 0.5,
                                    )
                                  : BorderSide.none,
                            )),
                            child: Column(children: [
                              Container(
                                height: 24,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            width: 0.5, color: Colors.black))),
                                child: Center(
                                    child: Text(widget.day[index].toString())),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: index == 0
                                        ? Radius.circular(5)
                                        : Radius.zero,
                                    bottomRight: index == widget.day.length - 1
                                        ? Radius.circular(5)
                                        : Radius.zero,
                                  ),
                                ),
                                height: 25,
                                child: Center(
                                    child: Text(
                                  widget.date[index].toString(),
                                  style: TextStyle(color: Colors.white),
                                )),
                              )
                            ]),
                          );
                        }),
                  ),
                ),
              ]),
            )
          ],
        ));
  }

  TextStyle buildMontserrat(
    Color color, {
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: 12,
      color: color,
      fontWeight: fontWeight,
    );
  }
}
