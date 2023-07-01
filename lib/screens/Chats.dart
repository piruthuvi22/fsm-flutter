import 'package:flutter/material.dart';
import 'package:fsm_agent/components/Drawer.dart';
import 'package:fsm_agent/screens/ChatScreen.dart';
import 'package:fsm_agent/services/api_service.dart';

class Chats extends StatefulWidget {
  const Chats({super.key});

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  ApiService apiService = ApiService();
  String userId = "agent_1";
  bool isLoading = true;
  List peopleList = [];

  Future<void> fetchPeople() async {
    setState(() {
      isLoading = true;
    });
    apiService.getPeoples(userId).then((responseData) {
      print(responseData.first);
      setState(() {
        peopleList = responseData;
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchPeople();
  }

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
        body: RefreshIndicator(
          onRefresh: fetchPeople,
          child: Container(
            color: Colors.grey.shade200,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: ListView(
                padding: EdgeInsets.zero,
                children: peopleList
                    .map(
                      (receiverId) => ChatPeopleTile(
                        receiverId: receiverId,
                        message: '',
                        unreadCount: 2,
                      ),
                    )
                    .toList()),
          ),
        ),
        drawer: const DrawerPanel(
          name: "Piruthuvi",
          username: "piru",
        ));
  }
}

class ChatPeopleTile extends StatelessWidget {
  final String receiverId;
  final String message;
  final int unreadCount;
  String userId = "agent_1";

  ChatPeopleTile(
      {super.key,
      required this.receiverId,
      required this.message,
      required this.unreadCount});

  void openChatScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ChatScreen(userId: userId, receiverId: receiverId)),
    ).then((value) {
      if (value == true) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(receiverId[0]),
      ),
      title: Text(
        receiverId,
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
