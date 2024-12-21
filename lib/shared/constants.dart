import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
  // fillColor: const Color.fromARGB(255, 228, 222, 220),
  filled: true,
  contentPadding: const EdgeInsets.all(10.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
        // color: Colors.white,
        width: 2.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(
        // color: Colors.brown[400]!,
        width: 2.0),
  ),
);

Widget switchButton(themeMode, themeNotifier) {
  return IconButton(
    icon: Icon(
      themeMode == ThemeMode.dark ? Icons.nights_stay : Icons.wb_sunny,
      color: themeMode == ThemeMode.dark ? Colors.white : Colors.black,
    ),
    onPressed: () {
      themeNotifier.toggleTheme();
    },
    tooltip: 'Toggle Theme',
  );
}

Widget headerWithIcon({
  double fontSize = 30,
  double sizedBoxWidth = 5,
  double iconSize = 35,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        'N O T E S Y N C',
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: const Color.fromRGBO(33, 133, 176, 1),
        ),
      ),
      SizedBox(width: sizedBoxWidth),
      Icon(
        Icons.menu_book_rounded,
        color: const Color.fromRGBO(33, 133, 176, 1),
        size: iconSize,
      ),
    ],
  );
}
