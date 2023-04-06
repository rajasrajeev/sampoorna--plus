import 'dart:io';

import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

class ProfileHeaderImageFile extends StatefulWidget {
  final File imageUrl;
  final String name;
  final String grade;

  const ProfileHeaderImageFile(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.grade});

  @override
  State<ProfileHeaderImageFile> createState() => _ProfileHeaderImageFileState();
}

class _ProfileHeaderImageFileState extends State<ProfileHeaderImageFile> {
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
                    child: Image.file(
                      widget.imageUrl,
                      fit: BoxFit.fill,
                      height:size.height*0.4,
                      width:size.width*0.4,
                    ),
                  ),
                // Image.asset(widget.imageUrl)
                ),
                SizedBox(height:10),
            Text(widget.name),
            Text(widget.grade)
          ],
        ));
  }
}
