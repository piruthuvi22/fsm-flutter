// import 'package:another_flushbar/flushbar.dart';
// import 'package:flutter/material.dart';
// import 'package:fsm_agent/Models/JobUpdate.dart';
// import 'package:fsm_agent/enums/JobUpdateType.dart';
// import 'package:fsm_agent/services/api_service.dart';
// import 'package:intl/intl.dart';

// class JobNotes extends StatefulWidget {
//   final int jobID;
//   const JobNotes({super.key, required this.jobID});

//   @override
//   State<JobNotes> createState() => _JobNotesState();
// }

// class _JobNotesState extends State<JobNotes> {
//   final ApiService apiService = ApiService();
//   List<JobUpdate> jobupdateAudios = [];
//   String text = "";
//   bool isPressed = false;
//   bool isLoading = true;
//   @override
//   void initState() {
//     fetechJobNote();
//     super.initState();
//   }

//   void openBottomSheet() {
//     showModalBottomSheet(
//       context: context,
//       // barrierColor: Colors.red,
//       enableDrag: true,
//       isDismissible: false,
//       builder: (BuildContext context) {
//         return SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.only(
//               bottom: MediaQuery.of(context).viewInsets.bottom,
//             ),
//             child: Padding(
//               padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.end,
//                 children: [
//                   TextField(
//                     minLines: 5,
//                     maxLines: 10,
//                     decoration: InputDecoration(
//                       border: OutlineInputBorder(),
//                       hintText: 'Type note..',
//                     ),
//                     onChanged: (value) {
//                       setState(() {
//                         text = value;
//                       });
//                     },
//                   ),
//                   TextButton.icon(
//                       icon: Icon(Icons.done),
//                       onPressed: isPressed ? null : handleAddNote,
//                       label: Text("Submit"))
//                 ],
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   void handleAddNote() async {
//     final navigator = Navigator.of(context);
//     setState(() {
//       isPressed = true;
//     });

//     JobUpdate jobUpdate = JobUpdate(
//         taskId: widget.jobID,
//         data: text,
//         date: DateTime.now(),
//         type: JobUpdateType.TEXT);
//     apiService.addJobUpdate(jobUpdate).then((responseData) async {
//       fetechJobNote();
//       navigator.pop();
//       setState(() {
//         isPressed = false;
//       });
//       await Flushbar(
//               forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
//               icon: Icon(
//                 Icons.info_outline,
//                 size: 28.0,
//                 color: Colors.blue[300],
//               ),
//               barBlur: 3,
//               flushbarPosition: FlushbarPosition.TOP,
//               // title: 'Hey Ninja',
//               duration: Duration(seconds: 3),
//               message: "Job note added successfully")
//           .show(context);
//     }).catchError((error) async {
//       setState(() {
//         isPressed = false;
//       });
//       await Flushbar(
//               forwardAnimationCurve: Curves.fastLinearToSlowEaseIn,
//               icon: Icon(
//                 Icons.info_outline,
//                 size: 28.0,
//                 color: Colors.blue[300],
//               ),
//               barBlur: 3,
//               flushbarPosition: FlushbarPosition.TOP,
//               // title: 'Hey Ninja',
//               duration: Duration(seconds: 3),
//               message: "Job note added failed")
//           .show(context);
//     });
//   }

//   Future<void> fetechJobNote() async {
//     setState(() {
//       isLoading = true;
//     });
//     apiService.getJobNotes(widget.jobID).then((responseData) {
//       setState(() {
//         jobNotes = responseData;
//         isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromRGBO(239, 239, 239, 1),
//       body: Container(
//         padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
//         child: Column(
//           children: [
//             if (isLoading)
//               const LinearProgressIndicator(
//                 color: Colors.blue,
//                 backgroundColor: Colors.white,
//               ),
//             if (!isLoading)
//               Expanded(
//                   child: RefreshIndicator(
//                 onRefresh: fetechJobNote,
//                 child: ListView(
//                     padding: EdgeInsets.zero,
//                     children: jobNotes
//                         .map((job) => Card(
//                                 // margin: EdgeInsets.zero,

//                                 child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text(
//                                 job.message,
//                                 style: TextStyle(fontSize: 16),
//                               ),
//                             )))
//                         .toList()),
//               ))
//           ],
//         ),
//       ),
//       floatingActionButton: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FloatingActionButton(
//           child: const Icon(Icons.post_add),
//           onPressed: openBottomSheet,
//         ),
//       ),
//     );
//   }
// }


// /**
//  * 
//  * 
//  * 
//  *  floatingActionButton: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: FloatingActionButton(
//           child: const Icon(Icons.post_add),
//           onPressed: openBottomSheet,
//         ),
//       ),
      
//  */