import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Assuming you're using Riverpod
import 'package:notesync/screen/Home/Header/menu.dart';
import 'package:notesync/screen/Home/Header/title.dart';

import 'search.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
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
                child: NotesSearch(
                  notes: [
                    "Meeting notes",
                    "Shopping list",
                    "Flutter tutorial ideas",
                    "Holiday plans",
                    "Workout schedule",
                  ],
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
