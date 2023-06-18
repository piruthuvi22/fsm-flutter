import 'dart:ffi';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:fsm_agent/Models/Job.dart';
import 'package:fsm_agent/services/api_service.dart';
import 'package:fsm_agent/views/JobNotes.dart';

class JobDetails extends StatefulWidget {
  final Job job;
  final String? location;

  const JobDetails({
    super.key,
    required this.job,
    required this.location,
  });

  @override
  State<JobDetails> createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  final ApiService apiService = ApiService();
  bool isPressed = false;

  void handleReject(int jobId, BuildContext context) async {
    print("handleReject");
    final navigator = Navigator.of(context);
    navigator.pop();
    setState(() {
      isPressed = true;
    });

    apiService.rejectJob(jobId).then((responseData) async {
      if (responseData.status == "REJECTED") {
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
                message: "Job Rejected")
            .show(context);
        setState(() {
          isPressed = false;
        });
        navigator.pop(true);
      } else {
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
                message: "Job Rejected failed")
            .show(context);
        setState(() {
          isPressed = false;
        });
      }
      print("Rejecte job ${responseData.id}");
    }).catchError((error) {
      print(error);
    });
  }

  void handleAccept(int jobId, BuildContext context) async {
    print("handleAccept");
    final navigator = Navigator.of(context);
    navigator.pop();
    setState(() {
      isPressed = true;
    });

    apiService.acceptJob(jobId).then((responseData) async {
      if (responseData.status == "PROGRESS") {
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
                message: "Job Accepted")
            .show(context);
        setState(() {
          isPressed = false;
        });
        navigator.pop(true);
      } else {
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
                message: "Job Accepted failed")
            .show(context);
        setState(() {
          isPressed = false;
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  void handleComplete(int jobId, BuildContext context) async {
    print("handle complete");
    final navigator = Navigator.of(context);
    navigator.pop();
    setState(() {
      isPressed = true;
    });

    apiService.completeJob(jobId).then((responseData) async {
      if (responseData.status == "COMPLETED") {
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
                message: "Job marked as completed")
            .show(context);
        setState(() {
          isPressed = false;
        });
        navigator.pop(true);
      } else {
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
                message: "Marked as completed failed")
            .show(context);
        setState(() {
          isPressed = false;
        });
      }
    }).catchError((error) {
      print(error);
    });
  }

  void showConfirmBox(String msg, int jobId, BuildContext context) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Text(msg == "complete"
              ? "Are you sure you want to mark this job as completed?"
              : msg == "accept"
                  ? "Are you sure you want to accept this job?"
                  : "Are you sure you want to reject this job?"),
          actions: [
            OutlinedButton.icon(
                icon: Icon(Icons.close),
                style: ButtonStyle(
                    side: MaterialStateProperty.all(
                        BorderSide(color: Colors.blue))),
                onPressed: () => Navigator.of(context).pop(),
                label: Text("Cancel")),
            ElevatedButton.icon(
                icon: Icon(Icons.done),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red),
                ),
                label: Text(msg == "complete"
                    ? "Completed"
                    : msg == "accept"
                        ? "Accept"
                        : "Reject"),
                onPressed: msg == "complete"
                    ? () => handleComplete(jobId, context)
                    : msg == "accept"
                        ? () => handleAccept(jobId, context)
                        : () => handleReject(jobId, context))
          ],
        );
      },
    );
  }

  void handleJobNotes(int jobId) {
    print("handleJobNotes $jobId");
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => JobNotes(jobId)),
    ).then((value) {
      print(value);
      if (value == true) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(239, 239, 239, 1),
      appBar: AppBar(
        title: const Text("Job Details"),
        actions: [
          IconButton(
              onPressed: () => {print("notifications button")},
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: Stack(
        children: [
          Wrap(children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 8))
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.job.title,
                            style: const TextStyle(fontSize: 28),
                          ),
                          Text("#${widget.job.id.toString()}",
                              style: const TextStyle(fontSize: 18))
                        ],
                      ),
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => {print("chat button")},
                            icon: const Icon(Icons.chat),
                            color: Colors.blue,
                            tooltip: "Chat with supervisor",
                          ),
                          IconButton(
                            onPressed: () {
                              handleJobNotes(widget.job.id);
                            },
                            icon: const Icon(Icons.format_list_bulleted_add),
                            color: Colors.blue,
                            tooltip: "Chat with supervisor",
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(widget.job.description,
                      style: const TextStyle(fontSize: 18))
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    leading: Icon(Icons.support_agent),
                    subtitle: Text(widget.job.phoneNumber),
                    title: Text("Phone Number"),
                  )),
                  Expanded(
                      child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    leading: Icon(Icons.face),
                    subtitle: Text(widget.job.customerName),
                    title: Text("Customer Name"),
                  ))
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 100,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                      child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    leading: Icon(Icons.person_pin_circle),
                    subtitle: Text(widget.job.address),
                    title: Text("City"),
                  )),
                  Expanded(
                      child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    leading: Icon(Icons.schedule),
                    subtitle: Text(widget.job.date.toString()),
                    title: Text("Date"),
                  ))
                ],
              ),
            ),
          ]),
          if (widget.location != "/my-jobs/completed")
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                color: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (widget.location == "/my-jobs/progress")
                      SizedBox(
                          width: 120,
                          child: OutlinedButton(
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                      BorderSide(color: Colors.blue))),
                              onPressed: isPressed
                                  ? null
                                  : () => showConfirmBox(
                                      "complete", widget.job.id, context),
                              child: Text("Completed"))),
                    if (widget.location == "/jobs") ...[
                      SizedBox(
                          width: 120,
                          child: OutlinedButton(
                              style: ButtonStyle(
                                  side: MaterialStateProperty.all(
                                      BorderSide(color: Colors.blue))),
                              onPressed: isPressed
                                  ? null
                                  : () => showConfirmBox(
                                      "reject", widget.job.id, context),
                              child: Text("Reject"))),
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                          width: 120,
                          child: ElevatedButton(
                              onPressed: isPressed
                                  ? null
                                  : () => showConfirmBox(
                                      "accept", widget.job.id, context),
                              child: Text("Accept"))),
                    ]
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}


/**
 * 
 * 



           Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Colors.grey.shade300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                      width: 120,
                      child: OutlinedButton(
                          style: ButtonStyle(
                              side: MaterialStateProperty.all(
                                  BorderSide(color: Colors.blue))),
                          onPressed: isPressed
                              ? null
                              : () => handleReject(widget.job.id, context),
                          child: Text("Reject"))),
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                      width: 120,
                      child: ElevatedButton(
                          onPressed: isPressed
                              ? null
                              : () => handleAccept(widget.job.id, context),
                          child: Text("Accept"))),
                ],
              ),
            ),
          ),




 */