import 'package:notesync/screen/authenticate/sign_in_screen.dart';

import 'package:flutter/material.dart';

import 'register_screen.dart';

class Authenticate extends StatefulWidget {
  bool showSignIn;
  Authenticate({super.key, required this.showSignIn});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  void toggleView() {
    setState(() {
      widget.showSignIn = !widget.showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.showSignIn
        ? SignInScreen(onToggleView: toggleView)
        : RegisterScreen(onToggleView: toggleView);
  }
}
