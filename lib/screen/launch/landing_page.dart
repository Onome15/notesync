import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth.dart';
import '../../shared/constants.dart';
import '../../provider/theme_provider.dart';
import '../authenticate/authenticate.dart';
// import '../authenticate/register.dart';
// import '../authenticate/signin.dart';

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
    final authService = ref.read(authServiceProvider.notifier);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final themeMode = ref.watch(themeNotifierProvider);
    final accentColor = Theme.of(context).colorScheme.primary;
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                children: [
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                  ),
                  const Spacer(),
                  switchButton(themeMode, themeNotifier),
                ],
              ),
              const Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Login or signup to continue",
                    style: TextStyle(fontSize: 15),
                  )),
              const SizedBox(height: 100),
              SvgPicture.asset(
                'assets/landing_page/writing.svg',
                colorFilter:
                    const ColorFilter.mode(Color(0xFF0057FF), BlendMode.srcIn),
                height: 250,
              ),
              const SizedBox(height: 20),
              headerWithIcon(),
              const Text(
                "Write, read, update and save your notes \n to the cloud without worries",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () =>
                      _navigateWithFade(context, const Authenticate()),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: accentColor,
                  ),
                  child: Text("Create an Account",
                      style: TextStyle(
                          color: surface, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () =>
                      _navigateWithFade(context, const Authenticate()),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: accentColor),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: Text(
                    "Already have an account",
                    style: TextStyle(
                        color: accentColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                  onPressed: authService.signInAnon,
                  child: const Text("Continue anonymously?"))
            ],
          ),
        ),
      ),
    );
  }
}
