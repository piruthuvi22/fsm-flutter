import 'package:flutter/material.dart';

class DrawerPanel extends StatefulWidget {
  const DrawerPanel({super.key, this.username = "user", this.name = "name"});
  final String username, name;

  @override
  State<DrawerPanel> createState() => _DrawerPanelState();
}

class _DrawerPanelState extends State<DrawerPanel> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.blue,
            ),
            child: Row(children: [
              const Image(
                  image: NetworkImage(
                      "https://cdn-icons-png.flaticon.com/512/149/149071.png"),
                  width: 80),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  Text(
                    "@${widget.username}",
                    style: const TextStyle(fontSize: 16, color: Colors.white54),
                  ),
                ],
              )
            ]),
          ),
          ListTile(
              title: const Text('Dashboard'),
              leading: const Icon(Icons.dashboard),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/dashboard');
              }),
          ListTile(
              title: const Text('Jobs'),
              leading: const Icon(Icons.task),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/jobs');
              }),
          ListTile(
              title: const Text('My Jobs'),
              leading: const Icon(Icons.task_alt),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, "/my-jobs");
              }),
          ListTile(
              title: const Text('Chats'),
              leading: const Icon(Icons.chat),
              onTap: () => Navigator.pushNamed(context, "/chats")),
          ListTile(
              title: const Text('Profile & Settings'),
              leading: const Icon(Icons.settings),
              onTap: () => Navigator.pushNamed(context, "/profile")),
          ListTile(
              title: const Text('Logout'),
              leading: const Icon(Icons.logout),
              onTap: () => Navigator.pushNamed(context, "/logout")),
        ],
      ),
    );
  }
}
