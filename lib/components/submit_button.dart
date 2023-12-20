import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String label;
  final Function onClick;
  final bool disabled;
  const SubmitButton(
      {super.key,
      required this.label,
      required this.onClick,
      this.disabled = false});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.03),
      child: ElevatedButton(
        onPressed: () => disabled ? null : onClick(),
        style: ElevatedButton.styleFrom(
          shape: const StadiumBorder(),
          padding: EdgeInsets.all(size.width * 0.03),
          minimumSize: const Size.fromHeight(54),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
