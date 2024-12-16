import 'package:flutter/material.dart';

class NotesSearch extends StatefulWidget {
  final List<String> notes; // Pass a list of notes to search

  const NotesSearch({super.key, required this.notes});

  @override
  NotesSearchState createState() => NotesSearchState();
}

class NotesSearchState extends State<NotesSearch> {
  List<String> _filteredNotes = []; // Stores the filtered search results

  @override
  void initState() {
    super.initState();
    // _filteredNotes = widget.notes; // Initially show all notes
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredNotes = []; // Reset the list when the search field is cleared
      } else {
        _filteredNotes = widget.notes
            .where((note) => note.toLowerCase().contains(query.toLowerCase()))
            .toList(); // Filter notes by query
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            onChanged: _onSearch,
            onSubmitted: _onSearch,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: "Search notes",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredNotes.isNotEmpty
                ? ListView.builder(
                    itemCount: _filteredNotes.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(_filteredNotes[index]),
                      );
                    },
                  )
                : const Center(
                    child: Text("No notes found."),
                  ),
          ),
        ],
      ),
    );
  }
}
