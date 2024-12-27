import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'note_details_view.dart';

class NoteDetailPage extends StatefulWidget {
  final String date;
  final String id;
  final bool? isPublic;
  final bool? isPrivate;

  const NoteDetailPage(
      {super.key,
      required this.id,
      required this.date,
      this.isPublic,
      this.isPrivate});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  bool _showSlider = false;
  double _fontSize = 16.0;

  @override
  Widget build(BuildContext context) {
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

        return NoteDetailView(
            noteData: snapshot.data!,
            showSlider: _showSlider,
            fontSize: _fontSize,
            onSliderVisibilityChanged: (show) {
              setState(() {
                _showSlider = show;
              });
            },
            onFontSizeChanged: (size) {
              setState(() {
                _fontSize = size;
              });
            },
            date: widget.date,
            noteId: widget.id,
            isPrivate: widget.isPrivate,
            isPublic: widget.isPublic);
      },
    );
  }
}
