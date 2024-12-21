import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesync/shared/toast.dart';
import '../../../services/auth.dart';
import '../add_notes.dart';
import 'package:notesync/database/firestore.dart';

import '../shared_methods.dart';

class NoteDetailPage extends StatelessWidget {
  final String date;
  final String id; // The note's ID

  const NoteDetailPage({
    super.key,
    required this.id,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
    FirestoreService firestoreService = FirestoreService();

    final String? currentUserId = AuthService().currentUser?.uid;

    // Fetch the note data once as a stream
    Stream<DocumentSnapshot> noteStream =
        FirebaseFirestore.instance.collection('notes').doc(id).snapshots();

    return StreamBuilder<DocumentSnapshot>(
      stream: noteStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Scaffold(
            body: Center(child: Text("Note not found.")),
          );
        }

        var noteData = snapshot.data!;
        String title = noteData['title'] ?? 'Untitled';
        String body = noteData['body'] ?? 'No content available';
        String ownerId =
            noteData['userId']; // Fetch the ownerId from the note document

        return Scaffold(
          appBar: AppBar(
            title: const Text("Note Details"),
            backgroundColor: primaryColor,
            actions: [
              if (currentUserId == ownerId) ...[
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
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
                    showAlert(
                      context: context,
                      title: "Delete Note",
                      content:
                          "Are you sure you want to delete this note? This action cannot be undone.",
                      onConfirm: () {
                        // Delete logic here
                        firestoreService.deleteNote(id);
                        showToast(message: "Deleted Succesfully");
                        Navigator.pop(context); // Return to the previous screen
                      },
                      confirmText: "Delete",
                    );
                  },
                ),
              ]
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    body,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
