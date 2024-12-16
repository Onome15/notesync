//my personal private notes
//set a pin for first time user
//enter the pin to open anytime user opens that screen
//pin could be changed from the private page
//there should be a toggle eye icon which is set to strike depicting privacy
//could also be removed from private with the toggle
//could be edited
//could be deleted

import 'package:flutter/material.dart';

class Private extends StatefulWidget {
  const Private({super.key});

  @override
  State<Private> createState() => _PrivateState();
}

class _PrivateState extends State<Private> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
          const Text("Hello World, I am Private"),
        ],
      ),
    );
  }
}
