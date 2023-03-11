import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';

class CustomDropDown extends StatelessWidget {
  final String label;
  final String? value;
  final dynamic data;
  final Function(String) onChange;
  final String? Function(String?)? validator; // add validator parameter
  const CustomDropDown({
    Key? key,
    this.value,
    required this.data,
    required this.onChange,
    required this.label,
    this.validator, // add validator to constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 52,
     // width: double.infinity,
     // padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
      decoration: BoxDecoration(
       // color: Color.fromARGB(153, 236, 236, 236),
        borderRadius: BorderRadius.circular(40.0),
        // border: Border.all(
        //   style: BorderStyle.solid,
        //   width: 2.0,
        //   color: primaryColor,
        // ),
      ),
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        hint: Center(child: Text(label)),
        value: value == "" || value!.isEmpty ? null : value,
        alignment: Alignment.bottomCenter,
        dropdownColor: Colors.white,
        //underline: const SizedBox(),
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
        
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: secondaryColor, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: primaryColor, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        validator: validator, // pass validator to DropdownButtonFormField
      ),
    );
  }
}
