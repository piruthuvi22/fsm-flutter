import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fsm_agent/Models/Job.dart';
import 'package:fsm_agent/views/JobDetails.dart';

class JobCard extends StatefulWidget {
  final Function(int) callback;
  final Job job;

  const JobCard({super.key, required this.job, required this.callback});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // String? location = ModalRoute.of(context)?.settings.name;
    // print(location);
    return InkWell(
      splashColor: Colors.grey.shade300,
      onTap: () {
        widget.callback(widget.job.id);
      },
      child: Container(
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        height: 120,
        child: Stack(children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  // color: Colors.blue.shade300,
                  gradient: LinearGradient(
                    tileMode: TileMode.repeated,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.blue.shade600,
                      Colors.blue.shade200,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5), // Shadow color
                      spreadRadius: 2, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset:
                          Offset(-3, -3), // Offset in the positive direction
                    ),
                  ],
                ),
                width: 120,
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.all(10),
                height: double.maxFinite,
                // color: Colors.blue,
                child: SvgPicture.asset(
                  "images/assigned.svg",
                  width: 100,
                  // height: 100,

                  alignment: Alignment.center,
                ),
              ),
              Container(
                // color: Colors.green,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.job.title,
                      style: TextStyle(fontSize: 24),
                    ),
                    // Text(
                    //   job.id.toString(),
                    //   style: TextStyle(fontSize: 18),
                    // ),
                    Row(
                      children: [
                        Icon(
                          Icons.person_pin_circle,
                          size: 20,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text(
                            "${widget.job.address}",
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          size: 20,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Text("${widget.job.date}"),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
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
