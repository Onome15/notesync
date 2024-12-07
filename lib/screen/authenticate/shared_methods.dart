import 'package:flutter/material.dart';

Widget buildButton(
  String text,
  VoidCallback onPressed, {
  Color color = const Color.fromRGBO(33, 133, 176, 1),
  String? asset,
  IconData? icon,
  FontWeight fontWeight = FontWeight.w700,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: asset != null
        ? Image.asset(asset, height: 24, width: 24)
        : (icon != null
            ? Icon(icon, color: const Color.fromARGB(255, 2, 31, 56))
            : const SizedBox.shrink()),
    label: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontWeight: fontWeight,
      ),
    ),
    style: ElevatedButton.styleFrom(
      backgroundColor: color,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    ),
  );
}
