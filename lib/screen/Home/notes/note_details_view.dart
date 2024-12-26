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
                onEdit: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddNotes(
                      title: title,
                      body: body,
                      id: noteId,
                    ),
                  ),
                ),
                onMakePrivate: () =>
                    firestoreService.updateToPrivate(noteId, true),
              ),
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
    required Function() onMakePrivate,
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
        value: 'private',
        text: 'Add to Private',
        onSelected: onMakePrivate,
      ),
    ];
  }
}
