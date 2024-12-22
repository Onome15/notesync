import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notesync/shared/toast.dart';
import '../../../services/auth.dart';
import '../add_notes.dart';
import 'package:notesync/database/firestore.dart';

import '../shared_methods.dart';

class NoteDetailPage extends StatefulWidget {
  // Change to StatefulWidget
  final String date;
  final String id;

  const NoteDetailPage({
    super.key,
    required this.id,
    required this.date,
  });

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool _showSlider = false;
  double _fontSize = 16.0; // Default font size

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
    FirestoreService firestoreService = FirestoreService();

    final String? currentUserId = AuthService().currentUser?.uid;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notes')
          .doc(widget.id)
          .snapshots(),
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
            bottom: _showSlider
                ? PreferredSize(
                    preferredSize: const Size.fromHeight(60.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      height: 60.0,
                      child: Row(
                        children: [
                          const Text(
                            'Text Size',
                          ),
                          Expanded(
                            child: Slider(
                              value: _fontSize,
                              activeColor: Colors.grey[400],
                              inactiveColor: Colors.white.withOpacity(0.5),
                              min: 12.0,
                              max: 32.0,
                              divisions: 10,
                              onChanged: (value) {
                                setState(() {
                                  _fontSize = value;
                                });
                              },
                            ),
                          ),
                          Text(
                            '$_fontSize',
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
            actions: [
              IconButton(
                icon: Icon(
                    _showSlider ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                onPressed: () {
                  setState(() {
                    _showSlider = !_showSlider;
                  });
                },
              ),
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
                          id: widget.id, // Pass the note's id
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
                        firestoreService.deleteNote(widget.id);
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
                      fontSize: _fontSize + 4, // Slightly larger than body text
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                  Text(
                    widget.date,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    body,
                    style: TextStyle(
                      fontSize: _fontSize,
                      color: Colors.black87,
                    ),
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
