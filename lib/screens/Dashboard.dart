// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fsm_agent/Models/Job.dart';
import 'package:fsm_agent/components/Drawer.dart';
import 'package:fsm_agent/utils/functions.dart';
import 'package:fsm_agent/screens/Signin.dart';
import 'package:fsm_agent/services/api_service.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

enum Calendar { day, week, month, year }

class _DashboardState extends State<Dashboard> {
  Calendar calendarView = Calendar.day;

  final ApiService apiService = ApiService();
  int assignedJobs = 0;
  int progressJobs = 0;
  List<Job> jobsList = [];
  List<Job> filterList = [];

  Future<void> fetchJobs() async {
    apiService.getProgressedJobs().then((responseData) {
      setState(() {
        jobsList = responseData;
        filterList = responseData;
        progressJobs = responseData.length;
      });
    }).catchError((error) {
      print(error);
    });
    apiService.getAssignedJobs().then((responseData) {
      setState(() {
        assignedJobs = responseData.length;
      });
    }).catchError((error) {
      print(error);
    });
  }

  void filterTodayJob(String filterType) {
    if (filterType == "") {
      setState(() {
        filterList = jobsList;
      });
    }
    if (filterType == "today") {
      DateTime today = DateTime.now();
      List<Job> filteredTasks = jobsList
          .where((task) =>
              task.date.year == today.year &&
              task.date.month == today.month &&
              task.date.day == today.day)
          .toList();
      print(filteredTasks.length);
      setState(() {
        filterList = filteredTasks;
      });
    } else if (filterType == "yesterday") {
      DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
      List<Job> filteredTasks = jobsList
          .where((task) =>
              task.date.year == yesterday.year &&
              task.date.month == yesterday.month &&
              task.date.day == yesterday.day)
          .toList();
      print(filteredTasks.length);
      setState(() {
        filterList = filteredTasks;
      });
    } else if (filterType == "tomorrow") {
      DateTime tomorrow = DateTime.now().add(Duration(days: 1));
      List<Job> filteredTasks = jobsList
          .where((task) =>
              task.date.year == tomorrow.year &&
              task.date.month == tomorrow.month &&
              task.date.day == tomorrow.day)
          .toList();
      print(filteredTasks.length);
      setState(() {
        filterList = filteredTasks;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchJobs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 239, 239, 1),
      appBar: AppBar(
        title: const Text("FSM App"),
        actions: [
          IconButton(
              onPressed: () => {print("Icon button 1")},
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DashboardCard("assigned", assignedJobs),
            DashboardCard("progress", progressJobs),
            Container(
              margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: Text(
                "On progress",
                style: TextStyle(fontSize: 24),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      filterTodayJob("yesterday");
                    },
                    child: Text("Yesterday")),
                TextButton(
                    onPressed: () {
                      filterTodayJob("today");
                    },
                    child: Text("Today")),
                TextButton(
                    onPressed: () {
                      filterTodayJob("tomorrow");
                    },
                    child: Text("Tomorrow")),
                TextButton(
                    onPressed: () {
                      filterTodayJob("");
                    },
                    child: Text("All"))
              ],
            ),
            Flexible(
              child: RefreshIndicator(
                onRefresh: fetchJobs,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  child: ListView(
                      children: [...filterList.map((e) => TodayJob(e))]),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: const DrawerPanel(
        name: "Piruthuvi",
        username: "piru",
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final int? count;
  final String? type;
  const DashboardCard(this.type, this.count, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.grey.shade200,
        onTap: () {
          type == "assigned"
              ? Navigator.pushNamed(context, "/jobs")
              : Navigator.pushNamed(context, "/my-jobs");
        },
        child: Container(
          height: 100,
          padding: EdgeInsets.all(8),
          child: Stack(children: [
            Row(
              children: [
                SvgPicture.asset(
                  type == "assigned"
                      ? "images/assigned.svg"
                      : "images/progressing.svg",
                  width: 100,

                  // height: 100,
                  alignment: Alignment.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        type == "assigned"
                            ? "Assigned Jobs"
                            : "Progressed Jobs",
                        style: TextStyle(fontSize: 24),
                      ),
                      // Text(
                      //   "Subtitle",
                      //   style: TextStyle(fontSize: 18),
                      // ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              top: 5,
              right: 5,
              child: Badge(
                largeSize: 24,
                textStyle:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                backgroundColor: Colors.red.shade400,
                label: Text(
                  count.toString(),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class TodayJob extends StatefulWidget {
  final Job job;
  const TodayJob(this.job, {super.key});

  @override
  State<TodayJob> createState() => _TodayJobState();
}

class _TodayJobState extends State<TodayJob> {
  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.grey.shade200,
        onTap: () {
          print('Card tapped');
        },
        child: Container(
          height: 120,
          child: Stack(children: [
            Row(
              children: [
                SvgPicture.asset(
                  "images/today.svg",
                  width: 100,
                  // height: 100,
                  alignment: Alignment.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.job.title,
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            widget.job.phoneNumber,
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(widget.job.address),
                          Text(
                              DateFormat("dd-MMM-yyyy").format(widget.job.date))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
            // Positioned(
            //     top: 0,
            //     right: 0,
            //     child: IconButton(
            //       tooltip: "Chat with supervisor",
            //       color: Colors.blue,
            //       icon: Icon(Icons.chat),
            //       onPressed: () {},
            //     )),
          ]),
        ),
      ),
    );
  }
}
