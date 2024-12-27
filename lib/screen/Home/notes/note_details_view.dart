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
  final bool? isPublic;
  final bool? isPrivate;

  const NoteDetailView(
      {super.key,
      required this.noteData,
      required this.showSlider,
      required this.fontSize,
      required this.onSliderVisibilityChanged,
      required this.onFontSizeChanged,
      required this.date,
      required this.noteId,
      this.isPublic,
      this.isPrivate});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
    FirestoreService firestoreService = FirestoreService();
    final String? currentUserId = AuthService().currentUser?.uid;

    String title = noteData['title'] ?? 'Untitled';
    String body = noteData['body'] ?? 'No content available';
    String ownerId = noteData['userId'];

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
                    children: [
                      const Text('Text Size'),
                      Expanded(
                        child: SliderTheme(
                          data: SliderTheme.of(context).copyWith(
                            trackHeight: 2.0,
                            thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 6.0,
                            ),
                          ),
                          child: Slider(
                            value: fontSize,
                            activeColor: Colors.grey[400],
                            inactiveColor: Colors.white.withOpacity(0.5),
                            min: 12.0,
                            max: 22.0,
                            divisions: 20,
                            onChanged: onFontSizeChanged,
                          ),
                        ),
                      ),
                      Text('$fontSize'),
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
              iconColor: Colors.white,
              menuItems: getNoteDetailMenuItems(
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
                        title: "Remove from Public",
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
                        confirmText: "Private",
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
        text: isPrivate == true
            ? 'Remove from Private'
            : isPublic == true
                ? 'Remove from Public'
                : 'Add to Private',
        onSelected: noteSection,
      ),
    ];
  }
}
