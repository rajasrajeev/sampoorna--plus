import 'package:flutter/material.dart';

//app color details
const primaryColor = Color.fromARGB(255, 202, 24, 10);
const secondaryColor = Color.fromRGBO(231, 45, 12, 0.693);
//const backgroundColor = Color.fromARGB(57, 130, 132, 130);
const cardColor = Color(0xFFE6E6FA);

//base api
const apiUrl = "https://sampoornaapi.kite.kerala.gov.in/index.php";
const parentApiUrl = "https://sampoornaapi.kite.kerala.gov.in/index.php";
const shimmerGradient = LinearGradient(
  colors: [
    Color(0xFFEBEBF4),
    Color(0xFFF4F4F4),
    Color(0xFFEBEBF4),
  ],
  stops: [
    0.1,
    0.3,
    0.4,
  ],
  begin: Alignment(-1.0, -0.3),
  end: Alignment(1.0, 0.3),
  tileMode: TileMode.clamp,
);
