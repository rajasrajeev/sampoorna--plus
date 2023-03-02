import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

class CustomDropDown extends StatelessWidget {
    final String label;
  final String? value;
  final dynamic data;
  final Function(String) onChange;
   const CustomDropDown({
    Key? key,
    this.value,
    required this.data,
    required this.onChange,
    required this.label,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.0),
        border: Border.all(
          style: BorderStyle.solid,
          width: 2.0,
          color: primaryColor,
        ),
      ),
      child: DropdownButton<String>(
        
        isExpanded: true,
        hint: Center(child: Text(label)),
        value: value == "" || value!.isEmpty ? null : value,
        alignment: Alignment.bottomCenter,
        dropdownColor: Colors.white,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down_sharp),
        elevation: 16,
        style: const TextStyle(color: Colors.black87),
        onChanged: (val) => onChange(val!),
        items: data!.map<DropdownMenuItem<String>>((item) {
          return DropdownMenuItem<String>(
            value: item["id"].toString(),
            child: Text(item["name"].toString()),
          );
        }).toList(),
      ),
    );
  }
}