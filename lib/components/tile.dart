import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

class Tile extends StatelessWidget {
  final String label;
  final String image;
  final Function? onClick;

  const Tile({
    super.key,
    required this.label,
    required this.image,
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      child: Container(
        width: size.width * 0.29,
        height: 150,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            // BoxShadow(
            //   color: Colors.purple.shade300,
            //   spreadRadius: 1,
            //   blurRadius: 5,
            //   offset: const Offset(0, 5),
            // ),
            // BoxShadow(
            //   color: Colors.purple.shade300,
            //   offset: const Offset(-5, 0),
            // ),
            // BoxShadow(
            //   color: Colors.purple.shade300,
            //   offset: const Offset(5, 0),
            // ),
            const BoxShadow(
              color: primaryColor,
              spreadRadius: 1,
              blurRadius: 1,
            )
          ],
        ),
        child: Column(
          children: <Widget>[
            const Spacer(),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                image,
                fit: BoxFit.fill,
                // height: size.width * 0.35,
                // width: size.width * 0.35,
              ),
            ),
            const Spacer(),
            // ignore: prefer_const_constructors
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      onTap: () => onClick!(),
    );
  }
}
