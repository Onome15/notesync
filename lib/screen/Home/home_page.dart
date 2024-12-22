import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesync/screen/Home/Header/menu.dart';
import 'package:notesync/screen/Home/Header/title.dart';
import 'add_notes.dart';
import 'notes/search.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNotes()),
        ),
        tooltip: "Add notes",
        child: Icon(
          Icons.add,
          color: primaryColor,
          size: 50,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
        child: Column(
          children: [
            Row(
              children: [
                const Header(),
                const Spacer(),
                menu(context, ref),
              ],
            ),
            const SizedBox(height: 25),
            const Expanded(
              child: NotesSearch(),
            ),
          ],
        ),
      ),
    );
  }
}
