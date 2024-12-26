import 'package:flutter/material.dart';
import 'package:notesync/screen/Home/Header/logout.dart';
import 'package:notesync/screen/Home/Header/profile.dart';
import 'package:notesync/screen/Home/pin.dart';

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
            MaterialPageRoute(builder: (context) => const PinScreen()),
          );
        } else if (value == 'logout') {
          showLogoutConfirmationDialog(context, ref);
        }
      },
      icon: GestureDetector(
          child: Icon(
        Icons.menu,
        size: 40,
        color: primaryColor,
      )),
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
