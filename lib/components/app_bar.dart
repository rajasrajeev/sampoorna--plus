import 'package:flutter/material.dart';

class ApplicationBar extends StatelessWidget {
  final Function onClick;
  final String title;
  const ApplicationBar({Key? key, required this.onClick, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(color: Colors.black),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      leading: IconButton(
       icon: const Icon(Icons.short_text_rounded),
        onPressed: () => onClick(),
      ),
      elevation: 0,
      iconTheme: const IconThemeData(color: Color.fromARGB(221, 133, 133, 133)),
      actions: const <Widget>[],
    );
  }
}
