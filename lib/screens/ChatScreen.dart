import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fsm_agent/services/api_service.dart';
import 'package:fsm_agent/utils/dateTime.dart';
import 'package:stomp_dart_client/stomp.dart';
import 'package:stomp_dart_client/stomp_config.dart';
import 'package:stomp_dart_client/stomp_frame.dart';
import 'package:web_socket_channel/io.dart';

class ChatScreen extends StatefulWidget {
  final String userId;
  final String receiverId;
  const ChatScreen({super.key, required this.userId, required this.receiverId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController msgController = TextEditingController();
  final ScrollController scrollController = ScrollController();

  final socketUrl = 'http://192.168.8.139:8081/socket';
  ApiService apiService = ApiService();
  String userId = "agent_1";

  StompClient? stompClient;
  List messages = [];
  bool isLoading = true;

  Future<void> getPeople() async {
    setState(() {
      isLoading = true;
    });
    await apiService
        .getMessages(widget.userId, widget.receiverId)
        .then((responseData) {
      print(responseData.first);
      setState(() {
        messages = responseData;
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
    });
    // scrollDown();
  }

  @override
  void initState() {
    getPeople();
    super.initState();
    if (stompClient == null) {
      stompClient = StompClient(
          config: StompConfig.SockJS(
        url: socketUrl,
        onConnect: (_) => onConnect(stompClient!, _),
        onWebSocketError: (dynamic error) => print(error.toString()),
      ));
      stompClient!.activate();
    }
  }

  void onConnect(StompClient client, StompFrame frame) {
    print('Connected');
    client.subscribe(
        destination: "/user/$userId/private",
        callback: (StompFrame frame) {
          if (frame.body != null) {
            Map<String?, dynamic> obj = json.decode(frame.body!);
            setState(() {
              messages.add(obj);
              // scrollDown();
            });
            // scrollDown();
          }
        });

    // client.send(
    //     destination: "/app/private-message/" "A",
    //     body:
    //         {"senderId": "B", "receiverId": "A", "message": "Hello"} as String);
  }

  // void onReceived = (StompFrame frame) {
  //   if (frame.body != null) {
  //     Map<String?, dynamic> obj = json.decode(frame.body!);
  //   }
  // };

  @override
  void dispose() {
    stompClient!.deactivate();
    super.dispose();
  }

  void sendMessage() {
    stompClient!.send(
        destination: "/app/private-message/${widget.receiverId}",
        body: json.encode({
          "senderId": widget.userId,
          "receiverId": widget.receiverId,
          "message": msgController.text,
          "dateTime": dateTime()
        }));
    setState(() {
      messages.add({
        "senderId": widget.userId,
        "receiverId": widget.receiverId,
        "message": msgController.text,
        "dateTime": dateTime()
      });
      // scrollDown();
      msgController.clear();
    });
  }

  void scrollDown() {
    if (scrollController.hasClients) {
      SchedulerBinding.instance.addPostFrameCallback((_) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
  }

// Unsupported URL scheme 'http'
  @override
  Widget build(BuildContext context) {
    scrollDown();
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
              child: RefreshIndicator(
                onRefresh: getPeople,
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  controller: scrollController,
                  children: messages.isNotEmpty
                      ? messages
                          .map((message) => MessageBubble(
                                sender: message['senderId'],
                                message: message['message'],
                                date: message['dateTime'],
                                isMe: message['senderId'] == userId,
                              ))
                          .toList()
                      : [
                          // Placeholder or empty state widget when messages is empty
                          Text('No messages available'),
                        ],
                ),
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
                  Expanded(
                    child: TextField(
                      controller: msgController,
                      maxLines: 4,
                      decoration: const InputDecoration(
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
                    onPressed: sendMessage,
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
  final String date;
  final bool isMe;

  const MessageBubble(
      {super.key,
      required this.sender,
      required this.message,
      required this.date,
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
            "$date ${isMe ? " You" : sender}",
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
