import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Assuming you're using Riverpod
import 'package:notesync/screen/Home/Header/menu.dart';
import 'package:notesync/screen/Home/Header/title.dart';

import 'add_notes.dart';
import 'notes/search.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
    Color secColor = const Color.fromRGBO(33, 133, 176, 0.3);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddNotes()),
        ),
        child: Icon(
          Icons.add,
          color: primaryColor,
          size: 50,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            children: [
              Row(
                children: [
                  const Header(),
                  const Spacer(), // Pushes the button to the opposite side
                  menu(context, ref),
                ],
              ),
              const SizedBox(height: 25),
              const SizedBox(
                height: 400,
                child: NotesSearch(),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
