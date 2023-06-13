import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fsm_agent/Models/Job.dart';
import 'package:fsm_agent/components/JobSearchHeader.dart';
import 'package:fsm_agent/services/api_service.dart';
import 'package:http/http.dart' as http;

import 'package:fsm_agent/components/Drawer.dart';
import 'package:fsm_agent/components/JobCard.dart';
import 'package:fsm_agent/views/JobDetails.dart';

class Jobs extends StatefulWidget {
  const Jobs({super.key});

  @override
  State<Jobs> createState() => _JobsState();
}

class _JobsState extends State<Jobs> {
  late FocusNode focusNode;
  final ApiService apiService = ApiService();
  bool isLoading = true;
  List<Job> jobsList = [];
  List<Job> filteredJobs = [];
  String? searchText = "";
  String? searchItem = "new";
  bool isFiltered = false;

  Future<void> fetchJobs() async {
    setState(() {
      isLoading = true;
      searchText = "";
    });
    apiService.getAssignedJobs().then((responseData) {
      setState(() {
        jobsList = responseData;
        filteredJobs = responseData;
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
    });
  }

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
    fetchJobs();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  void handleJobDetailsNavigation(int jobID) {
    // find job details from job id and pass it to job details page
    final findJob = jobsList.firstWhere((element) => element.id == jobID);
    String? location = ModalRoute.of(context)?.settings.name;

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => JobDetails(
                location: location,
                job: findJob,
              )),
    ).then((value) {
      print(value);
      if (value == true) {
        fetchJobs();
      }
    });
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                JobSearchHeader(focusNode, searchText, searchItem, handleFilter)
              ],
            ),
          ),
        );
      },
    );
  }

  void handleFilter(String? searchVal, String? selectedMenu) {
    setState(() {
      searchText = searchVal;
      // isFiltered = true;
    });
    Navigator.pop(context);
    List<Job> filter =
        jobsList.where((job) => job.title.contains(searchVal!)).toList();
    setState(() {
      filteredJobs = filter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Color.fromRGBO(239, 239, 239, 1),
        appBar: AppBar(
          shadowColor: Colors.transparent,
          title: const Text("Jobs"),
          actions: [
            IconButton(
                onPressed: () => {print("notifications button")},
                icon: const Icon(Icons.notifications))
          ],
        ),
        body: Container(
          // color: Colors.grey.shade200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (isLoading)
                const LinearProgressIndicator(
                  color: Colors.blue,
                  backgroundColor: Colors.white,
                ),
              IconButton(
                  onPressed: () {
                    openBottomSheet();
                  },
                  icon: Icon(Icons.filter_list)),
              if (!isLoading)
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: fetchJobs,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                    child: ListView(
                        padding: EdgeInsets.zero,
                        children: filteredJobs
                            .map((job) => JobCard(
                                job: job, callback: handleJobDetailsNavigation))
                            .toList()),
                  ),
                ))
            ],
          ),
        ),
        drawer: const DrawerPanel(
          name: "Piruthuvi",
          username: "piru",
        ),
      ),
    );
  }
}
