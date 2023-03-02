import 'package:flutter/material.dart';
import 'package:student_management/components/bezier_clipper.dart';
import 'package:student_management/constants.dart';

class CommonBanner extends StatefulWidget {
  final String imageUrl;
  final String name;
  final String grade;

  const CommonBanner(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.grade});

  @override
  State<CommonBanner> createState() => _CommonBannerState();
}

class _CommonBannerState extends State<CommonBanner> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height * 0.15;
    return ClipPath(
      clipper: BezierClipper(1),
      child: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  primaryColor,
                  primaryColor,
                  secondaryColor,
                ],
              )),
              height: height,
              child: Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(width: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100.0),
                    child: Image.asset(
                      widget.imageUrl,
                      fit: BoxFit.fill,
                      height: 75,
                      width: 75,
                    ),
                  ),
                  const Spacer(),
                  // ignore: prefer_const_constructors
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        widget.grade,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.black87,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                ],
              )),
        ],
      ),
    );
  }
}
