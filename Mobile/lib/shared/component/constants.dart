import 'package:flutter/material.dart';

getAPIBaseUrl() {
  bool local = true;
  if (!local) {
    return 'https://app.fox4books.com/api/';
  } else {
    return 'http://127.0.0.1:8000/api/';
  }
}

String baseUrl = getAPIBaseUrl();

/* Theme Colors Colors */
bool darkMode = false;

Color primaryColor = Colors.blue;
Color secondaryColor = Colors.grey;
Color lightColor = Colors.white;

/* Font Sizes */
double headingFontSize = 30;
double largeFontSize = 24;
double paragraphFontSize = 16;

Decoration card = cardDecoration();
Decoration cardDecoration(){
  return BoxDecoration(
    color: Colors.white,
    borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(10),
        bottomRight: Radius.circular(10)),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.1),
        spreadRadius: 3,
        blurRadius: 7,
        offset: const Offset(0, 3), // changes position of shadow
      ),
    ],
  );
}