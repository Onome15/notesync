import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:notesync/shared/constants.dart';

import '../../services/auth.dart';
import '../../shared/toast.dart'; // Replace with your service import

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Enter your email to reset your password:",
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                decoration: textInputDecoration.copyWith(
                  prefixIcon: const Icon(Icons.email),
                  hintText: 'Enter your email address',
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final email = _emailController.text.trim();
                  if (email.isNotEmpty) {
                    await authService.sendPasswordResetEmail(email, context);
                  } else {
                    showToast(message: "Please enter an email.");
                  }
                }
              },
              child: const Text("Send Reset Email"),
            ),
          ],
        ),
      ),
    );
  }
}
