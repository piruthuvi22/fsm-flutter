import 'package:flutter/material.dart';
import 'package:fsm_agent/Models/Job.dart';
import 'package:fsm_agent/components/JobSearchHeader.dart';
import 'package:fsm_agent/services/api_service.dart';

import 'package:fsm_agent/components/JobCard.dart';
import 'package:fsm_agent/views/JobDetails.dart';

class CompletedJobTab extends StatefulWidget {
  final Function(bool) handleIsLoading;
  final bool isLoading;
  const CompletedJobTab(this.isLoading, this.handleIsLoading, {super.key});

  @override
  State<CompletedJobTab> createState() => _CompletedJobTabState();
}

class _CompletedJobTabState extends State<CompletedJobTab> {
  late FocusNode focusNode;
  final ApiService apiService = ApiService();
  List<Job> jobsList = [];
  List<Job> filteredJobs = [];
  String? searchText = "";
  String? searchItem = "new";
  bool isFiltered = false;

  Future<void> fetchJobs() async {
    setState(() {
      searchText = "";
    });
    widget.handleIsLoading(true);
    apiService.getCompletedJobs().then((responseData) {
      setState(() {
        jobsList = responseData;
        filteredJobs = responseData;
        // isLoading = false;
      });
      widget.handleIsLoading(false);
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
    location = location! + "/completed";
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => JobDetails(
                  location: location,
                  job: findJob,
                ))).then((value) {
      print(value);
      if (value == true) {
        // fetchJobs();
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
    print("Complete = $searchVal");
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
      child: Container(
        // color: Colors.grey.shade200,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            openBottomSheet();
                          },
                    icon: Icon(Icons.filter_list)),
              ],
            ),
            if (!widget.isLoading)
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
    );
  }
}
