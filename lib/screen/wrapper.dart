import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:notesync/screen/authenticate/authenticate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth.dart';

import 'Home/home_page.dart';

class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService =
        ref.read(authServiceProvider.notifier); // Access AuthService

    return StreamBuilder<User?>(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomePage(); // Replace with your authenticated screen
        } else {
          return const Authenticate(); // Replace with your login screen
        }
      },
    );
  }
}
