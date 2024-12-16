//profile detail with name, mail, and photo
//name and photo could be update

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesync/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../shared/loading.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(Icons.arrow_back),
            ),
            const Icon(
              Icons.person,
              size: 100,
            ),
            _buildUserInfo(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider.notifier);
    return FutureBuilder<User?>(
      future: authService.getCurrentUser(),
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
