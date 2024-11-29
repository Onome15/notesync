import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesync/provider/theme_provider.dart';
import 'package:notesync/screen/authenticate/forget_password.dart';
import 'package:notesync/shared/loading.dart';
import '../../services/auth.dart';
import '../../shared/constants.dart';

class SignIn extends ConsumerStatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  ConsumerState<SignIn> createState() => _SignInState();
}

class _SignInState extends ConsumerState<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = ref.read(authServiceProvider.notifier);
    final isLoading = ref.watch(authServiceProvider); // Watch the loading state
    final themeNotifier = ref.read(themeNotifierProvider.notifier);
    final themeMode = ref.watch(themeNotifierProvider);
    final theme = Theme.of(context);

    return isLoading
        ? const Loading()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.surface,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              padding: const EdgeInsets.only(top: 100, left: 10),
              child: Column(
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        const Text(
                          "Welcome Back,\nLogin",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        const Spacer(),
                        switchButton(themeMode, themeNotifier),
                      ],
                    ),
                  ),
                  // Content Section with border radius
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(80),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 50.0, horizontal: 50),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: emailController,
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
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: passwordController,
                                decoration: textInputDecoration.copyWith(
                                  prefixIcon: const Icon(Icons.lock),
                                  hintText: 'Enter your password',
                                  labelText: 'Password',
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                              ),
                              Align(
                                alignment: Alignment.topRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ForgotPasswordPage(),
                                      ),
                                    );
                                  },
                                  child: const Text("Forgot Password?"),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await authService
                                          .signInWithEmailAndPassword(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );
                                    }
                                  },
                                  child: const Text('Sign in'),
                                ),
                              ),
                              const SizedBox(height: 20),
                              continueWith(
                                facebook: authService.signInAnon,
                                google: authService.signInWithGoogle,
                                toggle: widget.toggleView,
                                regOrLogin: "REGISTER",
                                alreadyOrDont: "Don't",
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
