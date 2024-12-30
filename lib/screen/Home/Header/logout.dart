import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesync/screen/wrapper.dart';
import 'package:notesync/shared/toast.dart';
import '../../../services/auth.dart';
import '../shared_methods.dart';

Future<void> showLogoutConfirmationDialog(
    BuildContext context, WidgetRef ref) async {
  final authService = ref.read(authServiceProvider.notifier);

  await showAlert(
    context: context,
    title: 'Logout Confirmation',
    content: 'Are you sure you want to logout?',
    onConfirm: () async {
      try {
        await authService.signOut();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const Wrapper(showSignIn: true)),
        );
        showToast(message: "Logout successful");
      } catch (e) {
        showToast(message: "Logout failed");
      }
    },
    confirmText: 'Logout',
  );
}
