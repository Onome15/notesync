import 'package:flutter/material.dart';

class MyNotes extends StatelessWidget {
  final String searchQuery; // Accepts the search query

  const MyNotes({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Example notes list
    final notes = [
      "Meeting notes",
      "Shopping list",
      "Flutter tutorial ideas",
      "Holiday plans",
      "Workout schedule",
    ];

    // Filter notes based on the search query
    final filteredNotes = notes
        .where((note) => note.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return filteredNotes.isNotEmpty
        ? ListView.builder(
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(filteredNotes[index]),
              );
            },
          )
        : const Center(
            child: Text(
              "No notes found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
  }
}
