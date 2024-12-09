import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notesync/screen/authenticate/authenticate.dart';
import 'package:notesync/screen/authenticate/sign_in_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../shared/constants.dart';
import '../authenticate/register_screen.dart';
import '../authenticate/shared_methods.dart';

class LandingPage extends ConsumerWidget {
  const LandingPage({super.key});

  Future<void> _navigateWithFade(
      BuildContext context, Widget destination) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenLandingPage', true);

    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => destination,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              headerWithIcon(),
              SvgPicture.asset(
                'assets/landing_page/vector_image.svg',
                height: 300,
              ),
              const Text(
                "Welcome!",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
              ),
              const Text(
                "Write, read, update and save your notes \n to the cloud without worries",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300,
                ),
                textAlign: TextAlign.center,
              ),
              buildButton("Get Started", () {
                _navigateWithFade(context, Authenticate(showSignIn: false));
              }),
            ],
          ),
        ),
      ),
    );
  }
}
