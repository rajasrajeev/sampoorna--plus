import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

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
                width: size.width*0.3,
                height: size.height*0.15,
                alignment: Alignment.center,
                child:
                    ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.fill,
                      height:100,
                      width:100,
                    ),
                  ),
                // Image.asset(widget.imageUrl)
                ),
                const SizedBox(height:10),
            Text(widget.name),
            
            Text(widget.grade)
          ],
        ));
  }
}
