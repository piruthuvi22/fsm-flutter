import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fsm_agent/components/Drawer.dart';
import 'package:fsm_agent/views/ImageUpdate.dart';
import 'package:fsm_agent/views/CompletedJobTab.dart';
import 'package:fsm_agent/views/Noteupdate.dart';
import 'package:fsm_agent/views/ProgressJobTab.dart';

class JobUpdates extends StatefulWidget {
  final int jobId;
  const JobUpdates({super.key, required this.jobId});

  @override
  State<JobUpdates> createState() => _JobUpdatesState();
}

class _JobUpdatesState extends State<JobUpdates> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    // print(isLoading);
  }

  void handleIsLoading(bool loading) {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        isLoading = loading;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(239, 239, 239, 1),
        appBar: AppBar(
          shadowColor: Colors.transparent,
          title: Text("Job Updates"),
          actions: [
            IconButton(
                onPressed: () => {print("notifications button")},
                icon: const Icon(Icons.notifications))
          ],
        ),
        body: Column(
          children: [
            if (isLoading)
              const LinearProgressIndicator(
                color: Colors.blue,
                backgroundColor: Colors.white,
              ),
            Material(
              color: Colors.blue,
              child: TabBar(
                // automaticIndicatorColorAdjustment: true,
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Notes"),
                        Badge.count(
                          count: 3,
                          backgroundColor: Color.fromRGBO(102, 192, 204, 1),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Images"),
                        Badge.count(
                          count: 3,
                          backgroundColor: Color.fromRGBO(102, 192, 204, 1),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Audio"),
                        Badge.count(
                          count: 3,
                          backgroundColor: Color.fromRGBO(102, 192, 204, 1),
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  JobNotes(
                    jobID: widget.jobId,
                  ),
                  ImageUpdate(
                    jobId: widget.jobId,
                  ),
                  JobNotes(
                    jobID: widget.jobId,
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
