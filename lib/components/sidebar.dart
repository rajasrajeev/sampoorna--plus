import 'package:flutter/material.dart';
import 'package:student_management/constants.dart';
import 'package:student_management/screens/login_screen/login_screen.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // ignore: prefer_const_constructors
          DrawerHeader(
            decoration: const BoxDecoration(
              color: primaryColor,
            ),
            child: const Center(child: Text("Nothing")),
          ),
          ListTile(
            title: const Text('Popular', style: TextStyle(fontSize: 16)),
            leading: const Icon(Icons.newspaper_outlined),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Contact us', style: TextStyle(fontSize: 16)),
            leading: const Icon(Icons.contact_phone_outlined),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('About us', style: TextStyle(fontSize: 16)),
            leading: const Icon(Icons.error_outline_outlined),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: const Text('Logout', style: TextStyle(fontSize: 16)),
            leading: const Icon(Icons.logout_outlined),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
