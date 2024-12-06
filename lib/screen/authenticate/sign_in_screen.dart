import 'package:flutter/material.dart';
import 'package:notesync/screen/authenticate/register_screen.dart';

import 'shared_methods.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
  Color secColor = const Color.fromRGBO(33, 133, 176, 0.3);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 40, 25, 5),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                      iconSize: 35,
                    ),
                    const Icon(Icons.dark_mode),
                  ],
                ),
                const SizedBox(height: 35),
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 21, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 3),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 3),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 3),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor, width: 3),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      color: primaryColor,
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Radio(
                          value: true,
                          groupValue: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value as bool;
                            });
                          },
                        ),
                        const Text('Remember Me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?'),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                buildButton("LOGIN", () {
                  if (_formKey.currentState!.validate()) {
                    // Perform registration action
                  }
                }),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                        child:
                            Divider(thickness: 3, color: Colors.grey.shade400)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text("OR", style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(
                        child:
                            Divider(thickness: 3, color: Colors.grey.shade400)),
                  ],
                ),
                const SizedBox(height: 40),
                buildButton('Continue Anonymously', () {},
                    color: secColor,
                    icon: Icons.person_outline,
                    textColor: Colors.black,
                    fontWeight: FontWeight.w400),
                const SizedBox(height: 20),
                buildButton('Continue with Google', () {},
                    color: secColor,
                    asset: 'assets/signin/google.png',
                    fontWeight: FontWeight.w400),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Don’t have an account?'),
                    TextButton(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
