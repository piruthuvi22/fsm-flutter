import 'package:flutter/material.dart';

class Chats extends StatelessWidget {
  const Chats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Chats"),
        actions: [
          IconButton(
              onPressed: () => {print("Icon button 1")},
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: Center(
        child: Text("Chats"),
      ),
      drawer: Drawer(
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
                  children: const [
                    Text(
                      "Piruthuvi",
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                    Text(
                      "@piruthuvi22",
                      style: TextStyle(fontSize: 16, color: Colors.white54),
                    ),
                  ],
                )
              ]),
            ),
            ListTile(
              title: const Text('Dashboard'),
              leading: const Icon(Icons.dashboard),
              onTap: () => Navigator.pushNamed(context, '/dashboard'),
            ),
            ListTile(
                title: const Text('Jobs'),
                leading: const Icon(Icons.task),
                onTap: () => Navigator.pushNamed(context, '/jobs')),
            ListTile(
                title: const Text('My Jobs'),
                leading: const Icon(Icons.task_alt),
                onTap: () => Navigator.pushNamed(context, "/my-jobs")),
            ListTile(
                title: const Text('Chats'),
                leading: const Icon(Icons.chat),
                onTap: () => Navigator.pushNamed(context, "/chats")),
            ListTile(
                title: const Text('Profile & Settings'),
                leading: const Icon(Icons.settings),
                onTap: () => Navigator.pushNamed(context, "/profile-settings")),
            ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.logout),
                onTap: () => Navigator.pushNamed(context, "/logout")),
          ],
        ),
      ),
    );
  }
}
