//a textformfield for title
//a large text field to type notes
//a checkbox to ask if notes should be made public
//a cancel and a save button with different colors
//then a formatting slide to format the text, like text sizes, color, text backgound etc.
// add an ai feature that generates a title if empty based on the body entered,
//it should alert "do you want a title generated for you?"

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notesync/database/firestore.dart';
import '../../shared/toast.dart';
import 'shared_methods.dart';

class AddNotes extends StatefulWidget {
  final String? title;
  final String? body;
  final String? id; // ID is optional and used for editing an existing note

  const AddNotes({super.key, this.title, this.body, this.id});

  @override
  AddNotesState createState() => AddNotesState();
}

class AddNotesState extends State<AddNotes> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  bool _isPublic = false; // Checkbox state

  @override
  void initState() {
    super.initState();

    // Initialize the text controllers with existing data if available
    if (widget.title != null && widget.body != null) {
      _titleController.text = widget.title!;
      _notesController.text = widget.body!;
    }

    // Adding a listener to the notes controller to track text changes
    _notesController.addListener(_updateCharacterCountAndSaveState);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // Function to update UI and handle character count and enabling/disabling the save button
  void _updateCharacterCountAndSaveState() {
    setState(() {
      // Trigger UI update whenever the body field changes
    });
  }

  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
    Color secColor = const Color.fromRGBO(33, 133, 176, 0.3);

    String formattedDate = DateFormat('yMMMd').add_jm().format(DateTime.now());
    int characterCount = _notesController.text.length;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.id == null ? "Add Notes" : "Edit Notes"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _titleController,
              decoration: textInputDecoration.copyWith(
                labelText: "Title (optional)",
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Date: $formattedDate"),
                Text("$characterCount characters"),
              ],
            ),
            const SizedBox(height: 40),
            // Notes Field
            TextFormField(
              controller: _notesController,
              maxLines: 6,
              decoration: textInputDecoration.copyWith(
                labelText: "Type your notes here...",
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Checkbox(
                  value: _isPublic,
                  onChanged: (value) {
                    setState(() {
                      _isPublic = value ?? false;
                    });
                  },
                  side: BorderSide(color: secColor),
                  activeColor: primaryColor,
                ),
                const Text("Make this note public (Others will see it)"),
              ],
            ),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Cancel Button
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.white,
                    side: BorderSide(color: primaryColor),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(color: primaryColor),
                  ),
                ),
                const SizedBox(width: 10),

                // Save Button
                ElevatedButton(
                  onPressed: _notesController.text.trim().isNotEmpty
                      ? () async {
                          String body = _notesController.text.trim();
                          String title = _titleController.text.trim();

                          if (title.isEmpty) {
                            title = "No Title, Update"; // Default title
                          }

                          if (widget.id == null) {
                            // Add a new note
                            firestoreService.addNote(
                                title: title, body: body, isPublic: _isPublic);
                            showToast(message: "Note added successfully!");
                          } else {
                            // Edit an existing note
                            firestoreService.updateNote(
                                widget.id!, title, body, _isPublic);
                            showToast(message: "Note updated successfully!");
                          }

                          await Future.delayed(const Duration(seconds: 1));
                          Navigator.pop(context);
                        }
                      : null, // Disable if no text in the body
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
