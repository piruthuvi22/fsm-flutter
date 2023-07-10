import 'dart:convert';
import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fsm_agent/Models/JobUpdate.dart';
import 'package:fsm_agent/enums/JobUpdateType.dart';
import 'package:fsm_agent/services/api_service.dart';
import 'package:fsm_agent/views/photo_view_page.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpdate extends StatefulWidget {
  final int jobId;
  const ImageUpdate({super.key, required this.jobId});

  @override
  State<ImageUpdate> createState() => _ImageUpdateState();
}

class _ImageUpdateState extends State<ImageUpdate> {
  ApiService apiService = ApiService();
  late File file;
  String imageUrl = "";
  String taskId = "1";
  bool isLoading = false;
  List<JobUpdate> jobUpdates = [];

  @override
  void initState() {
    // TODO: implement initState
    getImages();
  }

  Future pickImage(ImageSource source) async {
    final XFile? pickedFile =
        await ImagePicker().pickImage(source: source, imageQuality: 50);
    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        imageUrl = pickedFile.path;
        uploadFile(pickedFile.name);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(String name) async {
    final ref = FirebaseStorage.instance.ref("$taskId/images/$name");
    UploadTask task = ref.putFile(file);
    task.snapshotEvents.listen((taskSnapshot) async {
      switch (taskSnapshot.state) {
        case TaskState.running:
          setState(() {
            isLoading = true;
          });
          print("Uploading...");
          break;

        case TaskState.success:
          print("Success....");
          setState(() {
            isLoading = true;
          });
          String imageUrl = await ref.getDownloadURL();
          await saveImage(imageUrl);
          break;
        default:
          print("Default...");
      }
    });
  }

  void openBottomSheet() {
    showModalBottomSheet(
      context: context,
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
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text("Open Camera"),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text("Open Gallery"),
                  onTap: () {
                    Navigator.pop(context);
                    pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Cancel"),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> getImages() async {
    setState(() {
      isLoading = true;
    });
    await apiService
        .getJobUpdates(widget.jobId, JobUpdateType.IMAGE)
        .then((responseData) {
      setState(() {
        jobUpdates = responseData;
        isLoading = false;
      });
    }).catchError((error) {
      print(error);
    });
    // scrollDown();
  }

  Future<void> saveImage(String url) async {
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> jobImage = {
      "taskId": widget.jobId,
      "data": url,
      "date": DateTime.now(),
      "type": JobUpdateType.IMAGE,
    };

    apiService.addJobUpdate(jobImage).then((responseData) async {
      setState(() {
        jobUpdates.insert(0, responseData);
        isLoading = false;
      });
    }).catchError((error) async {
      setState(() {
        isLoading = false;
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
              message: "Image upload failed")
          .show(context);
    });
  }

  Future deleteFile(int id) async {
    // delete from database
    print(id);
    setState(() {
      isLoading = true;
    });
    await apiService.deleteJobUpdate(id).then((value) {
      getImages();
    }).catchError((error) {
      print(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(239, 239, 239, 1),
      body: isLoading
          ? const LoadingImage()
          : GridView.builder(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              padding: const EdgeInsets.all(1),
              itemCount: jobUpdates.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              itemBuilder: ((context, index) {
                return Container(
                  padding: const EdgeInsets.all(0.5),
                  child: InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            PhotoViewPage(photos: jobUpdates, index: index),
                      ),
                    ).then((id) => deleteFile(id)),
                    child: Hero(
                      tag: jobUpdates[index],
                      child: CachedNetworkImage(
                        imageUrl: jobUpdates[index].data,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            Container(color: Colors.grey),
                        errorWidget: (context, url, error) => Container(
                          color: Colors.red.shade400,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: openBottomSheet,
        child: const Icon(Icons.photo_camera),
      ),
    );
  }
}

class LoadingImage extends StatelessWidget {
  const LoadingImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.5),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(
              height: 10,
            ),
            // Text("Loading Images...")
          ],
        ),
      ),
    );
    ;
  }
}


/**
 * 
 * 
 * Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            imageUrl != ""
                ? CircleAvatar(
                    maxRadius: 10,
                    radius: 10,
                    backgroundImage: FileImage(File(imageUrl)),
                  )
                : CircleAvatar(
                    radius: 100,
                    backgroundImage: const NetworkImage(
                        "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_1280.png"),
                  ),
            const Text(
              'Profile & Settings',
              style: TextStyle(fontSize: 28),
            ),
            ElevatedButton(
                onPressed: openBottomSheet, child: const Text("Pick Image"))
          ],
        ),
      ),
    );

 */