//Search Notes based on title or both body and title maybe

import 'package:flutter/material.dart';
import 'my_notes.dart';
import 'others.dart';
import '../shared_methods.dart';

class NotesSearch extends StatefulWidget {
  const NotesSearch({super.key});

  @override
  NotesSearchState createState() => NotesSearchState();
}

class NotesSearchState extends State<NotesSearch> {
  bool _showMyNotes = true; // Toggle state
  String _searchQuery = ""; // Tracks the current search query
  Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
  Color secColor = const Color.fromRGBO(33, 133, 176, 0.3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Search Field
          TextField(
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              textInputAction: TextInputAction.search,
              decoration: textInputDecoration.copyWith(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search notes",
              )),
          const SizedBox(height: 20),
          // Toggle Menu
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              toggleButton(
                isSelected: _showMyNotes,
                text: "My Notes",
                showNotes: true,
              ),
              toggleButton(
                isSelected: !_showMyNotes,
                text: "Others",
                showNotes: false,
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Render MyNotes or OtherNotes based on toggle
          Expanded(
            child: _showMyNotes
                ? MyNotes(searchQuery: _searchQuery)
                : OtherNotes(searchQuery: _searchQuery),
          ),
        ],
      ),
    );
  }

  /// Reusable Toggle Button Widget
  Widget toggleButton({
    required bool isSelected,
    required String text,
    required bool showNotes,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _showMyNotes = showNotes),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor : Colors.grey[200],
            borderRadius: const BorderRadius.all(Radius.circular(10)),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
