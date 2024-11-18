import 'package:demo/Controls/my_list_title.dart';
import 'package:flutter/material.dart';

class volunteer_drawer extends StatelessWidget {
  final void Function()? onProfileTap;
  final void Function()? onSignOut;
  final void Function()? onCreateEvent;
  final void Function()? onDelete;

  const volunteer_drawer(
      {super.key,
      required this.onProfileTap,
      required this.onSignOut,
      required this.onCreateEvent,
      required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black,
      child: Column(
        children: [
          DrawerHeader(
              child: Image.asset(
            'assets/images/logo.png',
            width: 200,
            height: 200,
          )),
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            onTap: () => Navigator.pop(context),
          ),
          MyListTile(
            icon: Icons.add,
            text: 'A D D  E V E N T',
            onTap: onCreateEvent,
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
          const Spacer(),
          MyListTile(
            icon: Icons.delete,
            text: 'D E L E T E  A C C O U N T',
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
