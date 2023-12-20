import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

class ImageBase64 extends StatefulWidget {
  final String imageUrl;
  const ImageBase64({
    super.key,
    required this.imageUrl,
  });

  @override
  State<ImageBase64> createState() => _ImageBase64State();
}

class _ImageBase64State extends State<ImageBase64> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.3,
      height: size.height * 0.15,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.memory(
          widget.imageUrl as Uint8List,
          fit: BoxFit.fill,
          height: size.height * 0.4,
          width: size.width * 0.4,
        ),
      ),
      // Image.asset(widget.imageUrl)
    );
  }
}
