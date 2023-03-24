import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  // final String title;
  final String title;
  final String value;

  const ProfileDetails({Key? key, required this.title, required this.value})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        // ignore: prefer_const_literals_to_create_immutables
        children: <Widget>[
          const Spacer(),
          SizedBox(
            width: size.width * 0.40,
            child: Text(title,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                )),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: size.width * 0.40,
            child: Text(value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black45,
                  fontWeight: FontWeight.w500,
                )),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
