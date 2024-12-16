//profile page
//private page
//logout page

import 'package:flutter/material.dart';
import 'package:notesync/screen/Home/Header/logout.dart';
import 'package:notesync/screen/Home/Header/profile.dart';
import 'package:notesync/screen/Home/private.dart';

Widget menu(BuildContext context, ref) {
  Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
  return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'profile') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Profile()),
          );
        } else if (value == 'private') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PrivatePage()),
          );
        } else if (value == 'logout') {
          showLogoutConfirmationDialog(context, ref);
        }
      },
      icon: GestureDetector(
        child: ClipOval(
          child: Image.asset(
            'assets/signin/googe.png', // Replace with dynamic path
            width: 50,
            height: 50,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to an icon if image loading fails
              return Icon(
                Icons.person,
                size: 50,
                color: primaryColor,
              );
            },
          ),
        ),
      ),
      itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'profile',
              child: Text('Profile'),
            ),
            const PopupMenuItem(
              value: 'private',
              child: Text('Private'),
            ),
            const PopupMenuItem(
              value: 'logout',
              child: Text('Logout'),
            ),
          ]);
}
