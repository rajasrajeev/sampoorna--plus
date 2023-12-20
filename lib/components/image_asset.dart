import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

class ImageAssets extends StatefulWidget {
  final String imageUrl;
  const ImageAssets({
    super.key,
    required this.imageUrl,
  });

  @override
  State<ImageAssets> createState() => _ImageAssetsState();
}

class _ImageAssetsState extends State<ImageAssets> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.3,
      height: size.height * 0.15,
      alignment: Alignment.center,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Image.asset(
          widget.imageUrl,
          fit: BoxFit.fill,
          height: 100,
          width: 100,
        ),
      ),
      // Image.asset(widget.imageUrl)
    );
    ;
  }
}
