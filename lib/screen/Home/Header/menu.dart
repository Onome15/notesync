import 'package:flutter/material.dart';
import 'package:notesync/screen/Home/Header/logout.dart';
import 'package:notesync/screen/Home/Header/profile.dart';
import 'package:notesync/screen/Home/pin.dart';

// Step 1: Menu Item Model
class MenuItemData {
  final String value;
  final String text;
  final VoidCallback onSelected;

  MenuItemData({
    required this.value,
    required this.text,
    required this.onSelected,
  });
}

List<MenuItemData> getMainMenuItems(BuildContext context, ref) {
  return [
    MenuItemData(
      value: 'profile',
      text: 'Profile',
      onSelected: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Profile()),
      ),
    ),
    MenuItemData(
      value: 'private',
      text: 'Private Notes',
      onSelected: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const PinScreen()),
      ),
    ),
    MenuItemData(
      value: 'logout',
      text: 'Logout',
      onSelected: () => showLogoutConfirmationDialog(context, ref),
    ),
  ];
}

// Step 4: Note Detail Menu Items
List<MenuItemData> getNoteDetailMenuItems({
  required BuildContext context,
  required Function() onDelete,
  required Function() onEdit,
  required Function() onMakePrivate,
}) {
  return [
    MenuItemData(
      value: 'edit',
      text: 'Edit Note',
      onSelected: onEdit,
    ),
    MenuItemData(
      value: 'delete',
      text: 'Delete Note',
      onSelected: onDelete,
    ),
    MenuItemData(
      value: 'private',
      text: 'Add to Private',
      onSelected: onMakePrivate,
    ),
  ];
}
