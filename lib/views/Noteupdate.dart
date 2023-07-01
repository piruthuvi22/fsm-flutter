import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fsm_agent/Models/JobUpdate.dart';
import 'package:fsm_agent/enums/JobUpdateType.dart';
import 'package:fsm_agent/services/api_service.dart';
import 'package:intl/intl.dart';

class JobNotes extends StatefulWidget {
  final int jobId;
  const JobNotes({super.key, required this.jobId});

  @override
  State<JobNotes> createState() => _JobNotesState();
}

class _JobNotesState extends State<JobNotes> {
  final ApiService apiService = ApiService();
  List<JobUpdate> jobUpdateNotes = [];
  String text = "";
  bool isPressed = false;
  bool isLoading = true;

  Future<void> fetechJobUpdate() async {
    setState(() {
      isLoading = true;
    });
    apiService
        .getJobUpdates(widget.jobId, JobUpdateType.TEXT)
        .then((responseData) {
      setState(() {
        jobUpdateNotes = responseData;
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    fetechJobUpdate();
    super.initState();
  }

  void openBottomSheet() {
    showModalBottomSheet(
      context: context,
      // barrierColor: Colors.red,
      enableDrag: true,
      isDismissible: false,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextField(
                    minLines: 5,
                    maxLines: 10,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Type note..',
                    ),
                    onChanged: (value) {
                      setState(() {
                        text = value;
                      });
                    },
                  ),
                  TextButton.icon(
                      icon: Icon(Icons.done),
                      onPressed: isPressed ? null : handleAddNote,
                      label: Text("Submit"))
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void handleAddNote() async {
    final navigator = Navigator.of(context);
    setState(() {
      isPressed = true;
    });

    Map<String, dynamic> jobNote = {
      "taskId": widget.jobId,
      "data": text,
      "date": DateTime.now(),
      "type": JobUpdateType.TEXT,
    };
    apiService.addJobUpdate(jobNote).then((responseData) async {
      fetechJobUpdate();
      navigator.pop();
      setState(() {
        isPressed = false;
      });
      await Flushbar(
              forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              barBlur: 3,
              flushbarPosition: FlushbarPosition.TOP,
              // title: 'Hey Ninja',
              duration: Duration(seconds: 3),
              message: "Job note added successfully")
          .show(context);
    }).catchError((error) async {
      setState(() {
        isPressed = false;
      });
      await Flushbar(
              forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              barBlur: 3,
              flushbarPosition: FlushbarPosition.TOP,
              // title: 'Hey Ninja',
              duration: Duration(seconds: 3),
              message: "Job note added failed")
          .show(context);
    });
  }

  void handleDelete(int updateId) {
    // print(updateId);
    apiService.deleteJobUpdate(updateId).then((value) async {
      Flushbar(
              forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
              icon: Icon(
                Icons.info_outline,
                size: 28.0,
                color: Colors.blue[300],
              ),
              barBlur: 3,
              flushbarPosition: FlushbarPosition.TOP,
              // title: 'Hey Ninja',
              duration: Duration(seconds: 3),
              message: value)
          .show(context);
      fetechJobUpdate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 239, 239, 1),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        child: Column(
          children: [
            if (isLoading)
              const LinearProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.white,
              ),
            if (!isLoading)
              Expanded(
                  child: RefreshIndicator(
                onRefresh: fetechJobUpdate,
                child: ListView(
                    padding: EdgeInsets.zero,
                    children: jobUpdateNotes
                        .map((note) => Column(
                              children: [
                                Card(
                                  child: ListTile(
                                      // contentPadding: EdgeInsets.zero,
                                      title: Text(note.data),
                                      subtitle: Text(note.date != null
                                          ? DateFormat.yMMMd().format(note.date)
                                          : ""),
                                      trailing: IconButton(
                                        icon: Icon(Icons.delete),
                                        onPressed: () => handleDelete(note.id),
                                      )),
                                ),
                                // Divider(height: 2)
                              ],
                            ))
                        .toList()),
              ))
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          child: const Icon(Icons.post_add),
          onPressed: openBottomSheet,
        ),
      ),
    );
  }
}


/**
 * 
 * 
 * 
 *  floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          child: const Icon(Icons.post_add),
          onPressed: openBottomSheet,
        ),
      ),
      
 */