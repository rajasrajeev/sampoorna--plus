import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

class TileLink extends StatelessWidget {
  final String label;
  final String image;
  final Function? onClick;

  const TileLink({
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
        width: size.width * 0.19,
        height: 70,
        // ignore: prefer_const_constructors
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(5)),
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
                height: 45,
                width: 45,
              ),
            ),
            //const Spacer(),
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 8,
                  color: Color.fromARGB(221, 43, 42, 42),
                  fontWeight: FontWeight.w600,
                ),
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
