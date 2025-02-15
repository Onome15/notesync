//shared methods in home page

import 'package:flutter/material.dart';

import 'Header/menu.dart';

Color primaryColor = const Color.fromRGBO(33, 133, 176, 1);
Color secColor = const Color.fromRGBO(33, 133, 176, 0.3);

final textInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: secColor, width: 2),
    borderRadius: BorderRadius.circular(10),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: primaryColor, width: 2),
    borderRadius: BorderRadius.circular(10),
  ),
);

Future<void> showAlert({
  required BuildContext context,
  required String title,
  required String content,
  required VoidCallback onConfirm,
  String confirmText = "Confirm",
}) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // Prevent dismissing by tapping outside
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Cancel",
              style: TextStyle(color: primaryColor),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onConfirm();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
            ),
            child: Text(
              confirmText,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      );
    },
  );
}

Widget buildCustomMenu({
  required BuildContext context,
  required IconData menuIcon,
  required Color iconColor,
  required List<MenuItemData> menuItems,
}) {
  return PopupMenuButton<String>(
    onSelected: (value) {
      final selectedItem = menuItems.firstWhere((item) => item.value == value);
      selectedItem.onSelected();
    },
    icon: Icon(
      menuIcon,
      size: 40,
      color: iconColor,
    ),
    itemBuilder: (context) => menuItems
        .map((item) => PopupMenuItem(
              value: item.value,
              child: Text(item.text),
            ))
        .toList(),
  );
}
