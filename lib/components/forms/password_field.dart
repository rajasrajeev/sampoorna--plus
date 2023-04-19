import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

class PasswordField extends StatefulWidget {
  final String? label;
  final int? minLine;
  final int? maxLine;
  final Function validator;
  final bool? enabled;

  final TextEditingController? controller;

  const PasswordField({
    Key? key,
    this.minLine,
    this.maxLine,
    required this.validator,
    this.label,
    this.controller,
    this.enabled,
  }) : super(key: key);

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        obscureText: obscureText,
        minLines: widget.minLine,
        maxLines: widget.maxLine,
        enabled: widget.enabled,
        cursorColor: Colors.black87,
        controller: widget.controller, 
        decoration: InputDecoration(
          suffixIcon: IconButton(
            icon: const Icon(
              Icons.visibility_off,
              color: primaryColor,
            ),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          hintText: widget.label,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
          filled: true,
          fillColor: widget.enabled == true ? Colors.white : Colors.grey[300],
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(30),
          ),
          disabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(30),
          ),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        validator: (value) {
          return widget.validator(value);
        },
      ),
    );
  }
}