import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notesync/screen/launch/splash_screen.dart';
import 'package:notesync/screen/wrapper.dart';
import 'firebase_options.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily:
            GoogleFonts.cantarell().fontFamily, // Set global font family
      ),
      home: const SplashScreen(),
    );
  }
}
