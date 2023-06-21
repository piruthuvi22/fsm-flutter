import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
import 'package:fsm_agent/components/Drawer.dart';
import 'package:fsm_agent/firebase_options.dart';
import 'package:fsm_agent/screens/Landing.dart';
import 'package:fsm_agent/screens/Tabs.dart';

import 'screens/Jobs.dart';
import 'screens/ProgressJobTab.dart';
import 'screens/Chats.dart';
import 'screens/ProfileSettings.dart';

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
      initialRoute: "/dashboard",
      routes: {
        // "/": (context) => const MyHomePage(),
        "/dashboard": (context) => const MyHomePage(),
        "/jobs": (context) => const Jobs(),
        "/my-jobs": (context) => const MyJobs2(),
        "/chats": (context) => const Chats(),
        "/profile-settings": (context) => const ProfileSettings()
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FSM App"),
        actions: [
          IconButton(
              onPressed: () => {print("Icon button 1")},
              icon: const Icon(Icons.notifications))
        ],
      ),
      body: const SafeArea(child: Landing()),
      drawer: const DrawerPanel(
        name: "Piruthuvi",
        username: "piru",
      ),
    );
  }
}
