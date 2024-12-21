import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notesync/shared/toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService extends StateNotifier<bool> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '46828394961-h99g2u0ech8chnt5bhg12nknilvmi4dl.apps.googleusercontent.com.apps.googleusercontent.com',
  );

  AuthService() : super(false);

  /// Register a new user with email and password
  Future<User?> registerWithEmailAndPassword(
      String email, String password, String userName) async {
    state = true;
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      await user?.updateDisplayName(userName);
      await user?.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        showToast(message: "Email already exist");
      } else if (e.code == 'weak-password') {
        showToast(message: "The password provided is too weak.");
      } else if (e.code == 'invalid-email') {
        showToast(message: "Invalid email");
      } else {
        showToast(message: "An unknown error occurred.");
      }
    } finally {
      state = false; // Set loading to false after registration attempt
    }
    return null;
  }

  /// Sign in an existing user with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    state = true;
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(message: "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        showToast(message: "Incorrect password.");
      } else if (e.code == 'invalid-email') {
        showToast(message: "The email address is not valid.");
      } else {
        showToast(message: "An error occurred.");
      }
    } finally {
      state = false; // Set loading to false after registration attempt
    }
    return null;
  }

  Future<void> signInAnon() async {
    state = true; // Set loading to true
    try {
      await _firebaseAuth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      // Handle Firebase-specific errors
      showToast(message: "Error during anonymous sign-in: ${e.message}");
      state = false;
// Optionally rethrow to propagate the error further
    } catch (e) {
      // Handle other unexpected errors
      showToast(message: "Unexpected error during anonymous sign-in: $e");
      state = false;
    } finally {
      state = false; // Set loading to false, regardless of success or failure
    }
  }

  Future<User?> signInWithGoogle() async {
    state = true;
    try {
      // _setLoading(true); // Start loading
//
      // Trigger the Google authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        state = false;
        showToast(message: "Sign-in canceled by user.");
        return null; // User canceled the sign-in
      }

      // Obtain the Google Sign-In authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential for Firebase Authentication
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      state = false;
      showToast(message: "Signed in with Google successfully.");
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      state = false;

      if (e.code == 'account-exists-with-different-credential') {
        showToast(message: "Account exists with a different credential.");
      } else if (e.code == 'invalid-credential') {
        showToast(message: "Invalid Google credential.");
      } else {
        showToast(message: "An error occurred: ${e.message}");
      }
    } catch (e) {
      state = false;
      showToast(message: "An unknown error occurred: $e");
    }
    return null;
  }

  /// Send a password reset email
  Future<void> sendPasswordResetEmail(
      String email, BuildContext context) async {
    state = true;
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showToast(message: "Password reset email sent. Check your inbox.");
      // ignore: use_build_context_synchronously
      await Future.delayed(const Duration(seconds: 3));
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      state = false;
      if (e.code == 'invalid-email') {
        showToast(message: "Invalid email address.");
      } else if (e.code == 'user-not-found') {
        showToast(message: "No user found with that email.");
      } else {
        showToast(message: "An error occurred: ${e.message}");
      }
    } catch (e) {
      state = false;
      showToast(message: "An unknown error occurred: $e");
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    state = true;
    try {
      await _firebaseAuth.signOut();
    } finally {
      state = false; // Set loading to false
    }
  }

  /// Get the current logged-in user
  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  /// Listen for authentication state changes
  Stream<User?> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }
}

/// Provider for the AuthService
final authServiceProvider =
    StateNotifierProvider<AuthService, bool>((ref) => AuthService());
