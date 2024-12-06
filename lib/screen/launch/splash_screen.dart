import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import SpinKit
// import '../wrapper.dart';
import '../../shared/constants.dart';
import '../wrapper.dart';
import 'landing_page.dart'; // Ensure correct import

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
  @override
  void initState() {
    super.initState();

    // Delay for 3 seconds before navigating
    Future.delayed(const Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      final hasSeenLandingPage = prefs.getBool('hasSeenLandingPage') ?? false;

      if (!hasSeenLandingPage) {
        _navigateWithFade(const LandingPage());
      } else {
        _navigateWithFade(const LandingPage());
      }
    });
  }

  void _navigateWithFade(Widget destination) {
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
  Widget build(BuildContext context) {
    final themeColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child:
                headerWithIcon(fontSize: 40, sizedBoxWidth: 10, iconSize: 45),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: SpinKitThreeBounce(
                color: primaryColor, // Same color as the text
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
