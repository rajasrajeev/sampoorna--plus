import 'package:flutter/material.dart';

class ProfileHeader extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String grade;

  const ProfileHeader(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.grade});

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
        height: MediaQuery.of(context).size.height / 2.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
                width: 130,
                height: 130,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(15)),
                alignment: Alignment.center,
                child:
                    ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                      height:size.height*0.25,
                      width:size.width*0.25,
                    ),
                  ),
                // Image.asset(widget.imageUrl)
                ),
            Text(widget.name),
            Text(widget.grade)
          ],
        ));
  }
}
