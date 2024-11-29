import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:notesync/provider/theme_provider.dart';
import 'firebase_options.dart';
import 'screen/launch/splash_screen.dart'; // Import the SplashScreen
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    final themeMode = ref.watch(themeNotifierProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      // Start with SplashScreen
      home: const SplashScreen(),
    );
  }
}
