// ignore_for_file: void_checks

import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

class CustomTextField extends StatelessWidget {
  final String? label;
  final int? minLine;
  final int? maxLine;
  final Function? validator;
  final bool? enabled;
  final TextEditingController? controller;
  final Function? onChanged;
  final bool numberEnabled;

  const CustomTextField(
      {Key? key,
      this.minLine,
      this.maxLine,
      this.validator,
      this.label,
      this.controller,
      this.enabled,
      this.numberEnabled = false,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: TextFormField(
        minLines: minLine,
        maxLines: maxLine,
        enabled: enabled,
        cursorColor: Colors.black87,
        controller: controller,
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          hintText: label,
          hintStyle: const TextStyle(
            fontSize: 12,
            color: Colors.black87,
          ),
          filled: true,
          fillColor: enabled == true ? Colors.white : Colors.grey[300],
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
          return validator!(value);
        },
        onChanged: (value) {
          return onChanged!(value);
        },
      ),
    );
  }
}
