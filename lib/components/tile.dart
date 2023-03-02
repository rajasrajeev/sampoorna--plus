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
        height: 130,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
          // ignore: prefer_const_literals_to_create_immutables
          boxShadow: [
            const BoxShadow(
              color: Color.fromARGB(166, 142, 138, 138),
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
                fit: BoxFit.cover,
                height: 75,
                width: 75,
              ),
            ),
            const Spacer(),
            // ignore: prefer_const_constructors
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Color.fromARGB(221, 43, 42, 42),
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
