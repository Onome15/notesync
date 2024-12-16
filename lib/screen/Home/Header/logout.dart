//an alert confirmation to cancel or continue with logout

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/auth.dart';

Future<void> showLogoutConfirmationDialog(
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
