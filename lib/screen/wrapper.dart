import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesync/screen/authenticate/register_screen.dart';
import '../services/auth.dart';
import 'Home/home_page.dart';
import 'authenticate/sign_in_screen.dart';

class Wrapper extends ConsumerStatefulWidget {
  final bool showSignIn;

  const Wrapper({super.key, required this.showSignIn});
  @override
  ConsumerState<Wrapper> createState() => WrapperState();
}

class WrapperState extends ConsumerState<Wrapper> {
  late bool showSignIn;

  @override
  void initState() {
    super.initState();
    showSignIn = widget.showSignIn;
  }

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider.notifier);

    return StreamBuilder<User?>(
      stream: authService.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return const HomePage();
        } else {
          return showSignIn
              ? SignInScreen(onToggleView: toggleView)
              : RegisterScreen(onToggleView: toggleView);
        }
      },
    );
  }
}
