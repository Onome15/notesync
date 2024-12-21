import 'package:intl/intl.dart'; // Import the intl package
import 'package:flutter/material.dart';
import 'package:notesync/shared/loading.dart';
import '../../../database/firestore.dart';
import 'note_detail_page.dart'; // Ensure you import the NoteDetailPage

class MyNotes extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();
  final String searchQuery;

  MyNotes({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: firestoreService.fetchMyNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Loading());
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No notes found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Filter notes based on the search query (search in title)
        final notes = snapshot.data!
            .where((note) =>
                note['title']
                    ?.toLowerCase()
                    .contains(searchQuery.toLowerCase()) ??
                false)
            .toList();

        if (notes.isEmpty) {
          return const Center(
            child: Text(
              "No matching notes found.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return ListView.builder(
          itemCount: notes.length,
          itemBuilder: (context, index) {
            final note = notes[index];
            final title = note['title'] ?? "Untitled";
            final body = note['body'] ?? "No content";
            final id = note['id'];
            final date = note['date']?.toDate();
            final formattedDate = date != null
                ? DateFormat('yyyy-MM-dd   HH:mm').format(date)
                : "Unknown Date";

            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: primaryColor),
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: primaryColor,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              formattedDate,
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteDetailPage(
                                id: id,
                                date: formattedDate,
                              ),
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                          side: BorderSide(color: primaryColor),
                        ),
                        child: const Text("View"),
                      ),
                    ],
                  ),
                  Text(
                    body,
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // Truncate to 2 lines
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
