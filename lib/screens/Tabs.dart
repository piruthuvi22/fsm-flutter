import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fsm_agent/components/Drawer.dart';
import 'package:fsm_agent/screens/CompletedJobTab.dart';
import 'package:fsm_agent/screens/Jobs.dart';
import 'package:fsm_agent/screens/ProgressJobTab.dart';

class MyJobs2 extends StatefulWidget {
  const MyJobs2({super.key});

  @override
  State<MyJobs2> createState() => _MyJobs2State();
}

class _MyJobs2State extends State<MyJobs2> {
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
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
      length: 2,
      child: Scaffold(
        backgroundColor: Color.fromRGBO(239, 239, 239, 1),
        appBar: AppBar(
          shadowColor: Colors.transparent,
          title: Text("My Jobs"),
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
                        Text("Ongoing"),
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
                        Text("Compelted"),
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
                  ProgressJobTab(isLoading, handleIsLoading),
                  CompletedJobTab(isLoading, handleIsLoading)
                ],
              ),
            ),
          ],
        ),
        drawer: const DrawerPanel(
          name: "Piruthuvi",
          username: "piru",
        ),
      ),
    );
  }
}
