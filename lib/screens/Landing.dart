// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DashboardCard(),
          DashboardCard(),
          Container(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 5),
            // height: 10,
            child: Text(
              "On progress",
              style: TextStyle(fontSize: 24),
            ),
          ),
          Flexible(
            child: ListView(children: const [
              DashboardTodayCards(),
              DashboardTodayCards(),
              DashboardTodayCards(),
            ]),
          )
        ],
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  const DashboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey.shade300,
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        splashColor: Colors.grey.shade200,
        onTap: () {
          print('Card tapped');
        },
        child: Container(
          // width: 300,
          child: Stack(children: [
            Row(
              children: [
                Image.network(
                    "https://st3.depositphotos.com/10485246/13410/i/450/depositphotos_134108248-stock-photo-assigned-stamp-sign-green.jpg",
                    width: 100),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Assigned Jobs",
                        style: TextStyle(fontSize: 24),
                      ),
                      Text(
                        "Subtitle",
                        style: TextStyle(fontSize: 18),
                      ),
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
                label: const Text(
                  "12",
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class DashboardTodayCards extends StatelessWidget {
  const DashboardTodayCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        // splashColor: Colors.grey.shade200,
        onTap: () {
          print('Card tapped');
        },
        child: Container(
          height: 120,
          child: Stack(children: [
            Row(
              children: [
                Image.network(
                  "https://img.freepik.com/free-vector/men-success-laptop-relieve-work-from-home-computer-great_10045-646.jpg?w=2000",
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Assigned Jobs",
                            style: TextStyle(fontSize: 24),
                          ),
                          Text(
                            "Subtitle",
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      Container(
                        // color: Colors.amber,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: const [
                                Icon(
                                  Icons.circle,
                                  color: Colors.green,
                                  size: 10,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text("Active"),
                              ],
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text("Jaffna"),
                            SizedBox(
                              width: 5,
                            ),
                            Text("6 Days")
                          ],
                        ),
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
      ),
    );
  }
}
