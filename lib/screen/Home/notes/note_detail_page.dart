import 'package:flutter/material.dart';
import '../add_notes.dart';
import 'package:notesync/database/firestore.dart';

class NoteDetailPage extends StatelessWidget {
  final String title;
  final String body;
  final String date;
  final String id; // Add the note's ID

  const NoteDetailPage(
      {super.key,
      required this.title,
      required this.body,
      required this.date,
      required this.id});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
    FirestoreService firestoreService = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Note Details"),
        backgroundColor: primaryColor,
        actions: [
          // Edit Icon
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to AddNotes page with pre-loaded data
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddNotes(
                    title: title,
                    body: body,
                    id: id, // Pass the note's id
                  ),
                ),
              );
            },
          ),
          // Delete Icon
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              // Delete the note
              await firestoreService.deleteNote(id);
              Navigator.pop(context); // Return to the previous screen
            },
          ),
        ],
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
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
                textAlign: TextAlign.justify,
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                body,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
