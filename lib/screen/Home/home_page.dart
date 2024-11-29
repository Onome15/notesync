import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesync/provider/theme_provider.dart';
import 'package:notesync/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../shared/constants.dart';
import '../../shared/loading.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  /// Shows a confirmation dialog for logging out
  Future<void> _showLogoutConfirmationDialog(
      BuildContext context, WidgetRef ref) async {
    final authService = ref.read(authServiceProvider.notifier);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Logout Confirmation'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await authService.signOut();
                  const Text('Logged out successfully');
                } catch (e) {
                  Text('Error: $e');
                }
              },
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authServiceProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final themeMode =
        ref.watch(themeNotifierProvider); // Watch the loading state

    return isLoading
        ? const Loading()
        : Scaffold(
            appBar: AppBar(
              title: const Text('Home'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () => _showLogoutConfirmationDialog(context, ref),
                ),
                switchButton(themeMode, themeNotifier)
              ],
            ),
            body: Center(
              child: _buildUserInfo(context, ref),
            ),
          );
  }

  Widget _buildUserInfo(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider.notifier);
    return FutureBuilder<User?>(
      future: authService.getCurrentUser(), // Use the getCurrentUser method
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: Loading());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error fetching user data'));
        } else if (snapshot.data == null) {
          return const Center(child: Text('No user logged in'));
        }

        final User user = snapshot.data!;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Email: ${user.email ?? 'Not available'}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Text(
              'Name: ${user.displayName != null ? '${user.displayName![0].toUpperCase()}${user.displayName!.substring(1)}' : 'Not available'}',
              style: const TextStyle(fontSize: 18),
            ),
          ],
        );
      },
    );
  }
}
