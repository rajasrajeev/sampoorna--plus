import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

import '../constants.dart';

class LiveTitle extends StatelessWidget {
  final String title;
  const LiveTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color:primaryColor),
          ),
        ),
        child: Row(
          children: <Widget>[
            Container(
              height: 25,
              width: MediaQuery.of(context).size.width * 0.18,
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                  child: Text('Now', style: TextStyle(color: Colors.white))),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Container(
                height: 30,
                padding: const EdgeInsets.only(top: 6),
                width: MediaQuery.of(context).size.width * 0.70,
                child: Marquee(
                  text: title,
                  scrollAxis: Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  blankSpace: 20,
                  velocity: 40,
                  showFadingOnlyWhenScrolling: true,
                  fadingEdgeStartFraction: 0.1,
                  fadingEdgeEndFraction: 0.1,
                  numberOfRounds: 100,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
