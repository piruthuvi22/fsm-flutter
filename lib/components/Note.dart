import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fsm_agent/Models/JobUpdate.dart';

class Note extends StatefulWidget {
  final Function(int) callback;
  final JobUpdate jobNote;
  const Note({super.key, required this.callback, required this.jobNote});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.grey.shade300,
      onTap: () {
        // callback(jobNote.id);
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: 120,
        child: Stack(children: [
          Container(
            // color: Colors.green,
            child: Text(
              "message",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                tooltip: "Chat with supervisor",
                color: Colors.blue,
                icon: Icon(Icons.chat),
                onPressed: () {},
              )),
        ]),
      ),
    );
  }
}
