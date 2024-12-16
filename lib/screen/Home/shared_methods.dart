//shared methods in home page

import 'package:flutter/material.dart';

Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
Color secColor = const Color.fromRGBO(33, 133, 176, 0.3);

final textInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: secColor, width: 2),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 2),
    borderRadius: BorderRadius.circular(10),
  ),
);
