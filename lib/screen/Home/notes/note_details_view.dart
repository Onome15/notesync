import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../../database/firestore.dart';
import '../../../services/auth.dart';
import '../../../shared/toast.dart';
import '../Header/menu.dart';
import '../add_notes.dart';
import '../shared_methods.dart';

class NoteDetailView extends StatelessWidget {
  final DocumentSnapshot noteData;
  final bool showSlider;
  final double fontSize;
  final ValueChanged<bool> onSliderVisibilityChanged;
  final ValueChanged<double> onFontSizeChanged;
  final String date;
  final String noteId;

  const NoteDetailView({
    super.key,
    required this.noteData,
    required this.showSlider,
    required this.fontSize,
    required this.onSliderVisibilityChanged,
    required this.onFontSizeChanged,
    required this.date,
    required this.noteId,
  });

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
    FirestoreService firestoreService = FirestoreService();
    final String? currentUserId = AuthService().currentUser?.uid;

    String title = noteData['title'];
    String body = noteData['body'] ?? 'No content available';
    String ownerId = noteData['userId'];
    bool isPublic = noteData['isPublic'] ?? false;
    bool isPrivate = noteData['isPrivate'] ?? false;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Note Details"),
        backgroundColor: primaryColor,
        bottom: showSlider
            ? PreferredSize(
                preferredSize: const Size.fromHeight(60.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  height: 60.0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          if (fontSize > 12.0) {
                            onFontSizeChanged(fontSize - 1);
                          }
                        },
                        color: fontSize > 12.0
                            ? Colors.grey[900]
                            : Colors.grey[600],
                      ),
                      const SizedBox(width: 50),
                      Container(
                        width: 60,
                        alignment: Alignment.center,
                        child: Text(
                          '${fontSize.round()}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      const SizedBox(width: 50),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          if (fontSize < 22.0) {
                            onFontSizeChanged(fontSize + 1);
                          }
                        },
                        color: fontSize < 22.0
                            ? Colors.grey[900]
                            : Colors.grey[600],
                      ),
                    ],
                  ),
                ),
              )
            : null,
        actions: [
          IconButton(
            icon:
                Icon(showSlider ? Icons.arrow_drop_up : Icons.arrow_drop_down),
            onPressed: () => onSliderVisibilityChanged(!showSlider),
          ),
          if (currentUserId == ownerId) ...[
            buildCustomMenu(
              context: context,
              menuIcon: Icons.more_vert,
              iconColor: Colors.black45,
              menuItems: getNoteDetailMenuItems(
                  isPrivate: isPrivate,
                  isPublic: isPublic,
                  context: context,
                  onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddNotes(
                            title: title,
                            body: body,
                            id: noteId,
                            isPrivate: isPrivate,
                            isPublic: isPublic,
                          ),
                        ),
                      ),
                  onDelete: () async {
                    showAlert(
                      context: context,
                      title: "Delete Note",
                      content:
                          "Are you sure you want to delete this note? This action cannot be undone.",
                      onConfirm: () {
                        firestoreService.deleteNote(noteId);
                        showToast(message: "Deleted Successfully");
                        Navigator.pop(context);
                      },
                      confirmText: "Delete",
                    );
                  },
                  noteSection: () async {
                    if (isPrivate == true) {
                      showAlert(
                        context: context,
                        title: "Remove from Private",
                        content:
                            "This note will be removed from private notes. Are you sure?",
                        onConfirm: () {
                          firestoreService.updateToPrivate(noteId, false);
                          showToast(message: "Note removed from private");
                          Navigator.pop(context);
                        },
                        confirmText: "Remove",
                      );
                    } else if (isPublic == true) {
                      showAlert(
                        context: context,
                        title: "Remove from Others",
                        content:
                            "This note will no longer be public. Are you sure?",
                        onConfirm: () {
                          firestoreService.updateToPublic(noteId, false);
                          showToast(message: "Note removed from public");
                          Navigator.pop(context);
                        },
                        confirmText: "Remove",
                      );
                    } else {
                      showAlert(
                        context: context,
                        title: "Add Note To Private",
                        content:
                            "Private notes can only be accessed with your pin. Are you sure?",
                        onConfirm: () {
                          firestoreService.updateToPrivate(noteId, true);
                          showToast(message: "Note is now private");
                          Navigator.pop(context);
                        },
                        confirmText: "Continue",
                      );
                    }
                  }),
            )
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
                  fontSize: fontSize + 2,
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
                style: TextStyle(
                  fontSize: fontSize,
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
  }

  List<MenuItemData> getNoteDetailMenuItems({
    required BuildContext context,
    required Function() onDelete,
    required Function() onEdit,
    required Function() noteSection,
    required bool isPublic,
    required bool isPrivate,
  }) {
    return [
      MenuItemData(
        value: 'edit',
        text: 'Edit Note',
        onSelected: onEdit,
      ),
      MenuItemData(
        value: 'delete',
        text: 'Delete Note',
        onSelected: onDelete,
      ),
      MenuItemData(
        value: 'section',
        text: isPrivate
            ? 'Remove from Private'
            : isPublic
                ? 'Remove from Others'
                : 'Add to Private',
        onSelected: noteSection,
      ),
    ];
  }
}
