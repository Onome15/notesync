import 'package:flutter/material.dart';

class MyNotes extends StatefulWidget {
  final String searchQuery; // Accepts the search query

  const MyNotes({super.key, required this.searchQuery});

  @override
  State<MyNotes> createState() => _MyNotesState();
}

class _MyNotesState extends State<MyNotes> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);

    // Example notes map (title as key, body as value)
    final Map<String, String> notes = {
      "Flutter tutorial ides": "Build a weather app, social media app, etc.",
      "Holiday plan": "Viit the beach, go hiking, book a hotel.",
      "Workout schedue": "Monday: Cardio, Tuesday: Strength, etc.",
      "Meeting notes": "Discuss project updates and deadlines.",
      "Shopping list": "Milk, Eggs, Bread, Butter, Fruits.",
      "Flutter tutorial ideas": "Build a weather app, social media app, etc.",
      "Holiday plans": "Visit the beach, go hiking, book a hotel.",
      "Workout schedule": "Monday: Cardio, Tuesday: Strength, etc.",
    };

    // Filter notes based on the search query (searching titles only)
    final filteredNotes = notes.entries
        .where((entry) =>
            entry.key.toLowerCase().contains(widget.searchQuery.toLowerCase()))
        .toList();

    return filteredNotes.isNotEmpty
        ? ListView.builder(
            itemCount: filteredNotes.length,
            itemBuilder: (context, index) {
              final title = filteredNotes[index].key;
              final body = filteredNotes[index].value;

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.only(
                    top: 5, bottom: 10, left: 10, right: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: primaryColor),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: primaryColor,
                          ),
                        ),
                        const Spacer(),
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            side: BorderSide(color: primaryColor),
                          ),
                          child: const Text("View"),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      body,
                      style:
                          const TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
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
