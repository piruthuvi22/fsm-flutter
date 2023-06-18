import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Container(
        color: Colors.grey.shade200,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: const [
                  MessageBubble(
                    sender: 'John',
                    message: 'Hey, how are you?',
                    isMe: false,
                  ),
                  MessageBubble(
                    sender: 'Me',
                    message: 'I\'m good. Thanks!',
                    isMe: true,
                  ),
                  // Add more message bubbles here
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      maxLines: 4,
                      decoration: InputDecoration(
                        // enabledBorder: OutlineInputBorder(
                        //     // borderRadius: BorderRadius.all(Radius.circular(20)),
                        //     ),
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      // Handle send button action
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String message;
  final bool isMe;

  const MessageBubble(
      {super.key,
      required this.sender,
      required this.message,
      required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft:
                  isMe ? const Radius.circular(20.0) : const Radius.circular(0),
              topRight:
                  isMe ? const Radius.circular(0) : const Radius.circular(20),
              bottomLeft: const Radius.circular(20.0),
              bottomRight: const Radius.circular(20),
            ),
            elevation: 5.0,
            color: isMe ? Colors.blue.shade800 : Colors.deepPurple.shade500,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
