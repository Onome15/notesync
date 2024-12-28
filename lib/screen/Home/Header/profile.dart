//profile detail with name, mail, and photo
//name and photo could be update

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notesync/screen/Home/notes/others.dart';
import 'package:notesync/screen/authenticate/shared_methods.dart';
import 'package:notesync/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../database/firestore.dart';
import '../../../shared/loading.dart';
import '../home_page.dart';
import '../pin.dart';

class Profile extends ConsumerStatefulWidget {
  const Profile({super.key});

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: const Icon(
                Icons.person,
                size: 80,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            _buildUserInfo(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, WidgetRef ref) {
    final authService = ref.read(authServiceProvider.notifier);
    final firestoreService = FirestoreService();

    return FutureBuilder<User?>(
      future: authService.getCurrentUser(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) return const Loading();

        final user = userSnapshot.data!;

        return FutureBuilder<Map<String, int>>(
          future: firestoreService.getNotesCounts(user.uid),
          builder: (context, countSnapshot) {
            final counts =
                countSnapshot.data ?? {'myNotes': 0, 'private': 0, 'public': 0};

            return Column(
              children: [
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(
                          user.displayName != null
                              ? '${user.displayName![0].toUpperCase()}${user.displayName!.substring(1)}'
                              : 'Not available',
                          style: const TextStyle(fontSize: 18),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: Text(
                          user.email ?? 'Not available',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Joined'),
                        subtitle: Text(
                          DateFormat('MMMM dd, yyyy')
                              .format(user.metadata.creationTime!),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatsCard(
                      'My Notes',
                      counts['myNotes'].toString(),
                      Icons.note,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const HomePage()),
                      ),
                    ),
                    _buildStatsCard(
                      'Private',
                      counts['private'].toString(),
                      Icons.lock,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const PinScreen()),
                      ),
                    ),
                    _buildStatsCard(
                      'Public',
                      counts['public'].toString(),
                      Icons.public,
                      () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OtherNotes()),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildStatsCard(
    String title,
    String count,
    IconData icon,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16),
          width: 100,
          child: Column(
            children: [
              Icon(icon, color: primaryColor, size: 30),
              const SizedBox(height: 8),
              Text(
                count,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
