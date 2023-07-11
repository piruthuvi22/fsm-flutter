import 'package:firebase_core/firebase_core.dart';
import 'package:fsm_agent/screens/Profile.dart';
import 'package:fsm_agent/screens/Signin.dart';
import 'package:fsm_agent/utils/functions.dart';
import 'firebase_options.dart';

import 'package:flutter/material.dart';
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
      title: 'FSM',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: TokenManager.isTokenValid(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final bool isLoggedIn = snapshot.data!;
            return isLoggedIn ? const Dashboard() : const Signin();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return const CircularProgressIndicator();
        },
      ),
      routes: {
        "/dashboard": (context) => const Dashboard(),
        "/jobs": (context) => const Jobs(),
        "/my-jobs": (context) => const MyJobs(),
        "/chats": (context) => const Chats(),
        "/profile": (context) => const Profile(),
      },
    );
  }
}

class TokenManager {
  static Future<String?> getToken() async {
    return await loadToken();
  }

  static Future<bool> isTokenValid() async {
    final token = await getToken();
    // Add your token validation logic here
    return token != null;
  }
}
