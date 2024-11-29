import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesync/provider/theme_provider.dart';
import 'package:notesync/shared/constants.dart';
import 'package:notesync/shared/loading.dart';
import '../../services/auth.dart';

class Register extends ConsumerStatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primaryContainer,
                    theme.colorScheme.surface
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
              ),
              padding: const EdgeInsets.only(top: 100, left: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: Row(
                      children: [
                        const Text(
                          "Welcome,\nRegister",
                          style: TextStyle(
                            fontSize: 30,
                          ),
                        ),
                        const Spacer(),
                        switchButton(themeMode, themeNotifier),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(80),
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(
                          vertical: 40.0, horizontal: 50),
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: userNameController,
                                decoration: textInputDecoration.copyWith(
                                  prefixIcon: const Icon(Icons.person),
                                  hintText: 'Enter your Username',
                                  labelText: 'Username',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your Username';
                                  }
                                  return null;
                                },
                              ),
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
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: confirmPasswordController,
                                decoration: textInputDecoration.copyWith(
                                  prefixIcon: const Icon(Icons.lock),
                                  hintText: 'Re-enter your password',
                                  labelText: 'Confirm Password',
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if (value != passwordController.text) {
                                    return 'Passwords do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await authService
                                          .registerWithEmailAndPassword(
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                        userNameController.text.trim(),
                                      );
                                    }
                                  },
                                  child: const Text('Register'),
                                ),
                              ),
                              const SizedBox(height: 10),
                              continueWith(
                                facebook: authService.signInAnon,
                                google: authService.signInWithGoogle,
                                toggle: widget.toggleView,
                                regOrLogin: "SIGN IN",
                                alreadyOrDont: "Already",
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
    userNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
