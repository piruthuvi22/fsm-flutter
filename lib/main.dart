import 'package:firebase_core/firebase_core.dart';
import 'package:fsm_agent/screens/Profile.dart';
import 'package:fsm_agent/screens/Signin.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:fsm_agent/components/Drawer.dart';
import 'package:fsm_agent/screens/Dashboard.dart';
import 'package:fsm_agent/screens/MyJobs.dart';

import 'screens/Jobs.dart';
import 'screens/Chats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: "/signin",
      routes: {
        "/signin": (context) => const Signin(),
        "/dashboard": (context) => const Dashboard(),
        "/jobs": (context) => const Jobs(),
        "/my-jobs": (context) => const MyJobs(),
        "/chats": (context) => const Chats(),
        "/profile": (context) => const Profile()
      },
    );
  }
}
