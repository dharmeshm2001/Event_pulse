import 'package:demo/Controls/my_list_title.dart';
import 'package:flutter/material.dart';

class Codrawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  final void Function()? onCreateEvent;
  final void Function()? onDelete; // Add onDelete function

  const Codrawer({
    super.key,
    required this.onProfileTap,
    required this.onSignOut,
    required this.onCreateEvent,
    required this.onDelete, // Add onDelete to the constructor
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
              width: 200,
              height: 200,
            ),
          ),
          // Home list title
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
          ),
          // Add Event
          MyListTile(
            icon: Icons.add,
            text: 'A D D  E V E N T',
            onTap: onCreateEvent,
          ),
          // Profile
          MyListTile(
            icon: Icons.person,
            text: 'P R O F I L E',
            onTap: onProfileTap,
          ),
          // Logout
          MyListTile(
            icon: Icons.logout,
            text: 'L O G O U T',
            onTap: onSignOut,
          ),

          // Spacer to push the Delete option to the bottom
          const Spacer(),

          // Delete Account at the bottom
          MyListTile(
            icon: Icons.delete,
            text: 'D E L E T E  A C C O U N T',
            onTap: onDelete, // Execute the onDelete function
          ),
        ],
      ),
    );
  }
}
