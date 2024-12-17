import 'package:flutter/material.dart';

class NoteDetailPage extends StatelessWidget {
  final String title;
  final String body;

  const NoteDetailPage({super.key, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Note Details"),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
