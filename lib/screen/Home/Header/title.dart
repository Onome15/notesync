//Title and subtitle

import 'package:flutter/material.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "NoteSync",
          style: TextStyle(
              fontSize: 35, fontWeight: FontWeight.bold, color: primaryColor),
        ),
        const Text(" Write and sync to cloud")
      ],
    );
  }
}
