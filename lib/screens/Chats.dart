import 'package:flutter/material.dart';
import 'package:fsm_agent/components/Drawer.dart';
import 'package:fsm_agent/screens/ChatScreen.dart';

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
        body: Container(
          color: Colors.grey.shade200,
          // padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          child: ListView(
            children: [
              ChatPeopleTile(
                name: 'John',
                message: 'Hey, how are you?',
                unreadCount: 2,
              ),
              ChatPeopleTile(
                name: 'Jane',
                message: 'What are you up to?',
                unreadCount: 0,
              ),
              // Add more chat people tiles here
            ],
          ),
        ),
        drawer: const DrawerPanel(
          name: "Piruthuvi",
          username: "piru",
        ));
  }
}

class ChatPeopleTile extends StatelessWidget {
  final String name;
  final String message;
  final int unreadCount;

  ChatPeopleTile(
      {required this.name, required this.message, required this.unreadCount});

  void openChatScreen(BuildContext context) {
    print("object");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()),
    ).then((value) {
      print(value);
      if (value == true) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(name[0]),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: unreadCount > 0
          ? CircleAvatar(
              backgroundColor: Colors.red,
              maxRadius: 10,
              child: Text(
                unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
            )
          : null,
      onTap: () {
        openChatScreen(context);
      },
    );
  }
}
