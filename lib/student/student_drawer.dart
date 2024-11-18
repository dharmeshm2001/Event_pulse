import 'package:demo/Controls/my_list_title.dart';
import 'package:flutter/material.dart';

class StudentDrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;

  const StudentDrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          // Header
          DrawerHeader(
              child: Image.asset(
            'assets/images/logo.png', // Replace with your image path
            // Apply color if needed
            width: 200,
            height: 200,
          )),
          // Home list title
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
          ),
          MyListTile(
            icon: Icons.person,
            text: 'P R O F I L E',
            onTap: onProfileTap,
          ),
          MyListTile(
            icon: Icons.logout,
            text: 'L O G O U T',
            onTap: onSignOut,
          ),
        ],
      ),
    );
  }
}
