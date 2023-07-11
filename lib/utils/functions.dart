import 'package:shared_preferences/shared_preferences.dart';

// Function to save the JWT token to SharedPreferences
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
  print('Token saved: $token');
}

// Function to load the JWT token from SharedPreferences
Future<String?> loadToken() async {
  final prefs = await SharedPreferences.getInstance();
  print("Token loaded");
  return prefs.getString('token');
}

// Function to remove the JWT token from SharedPreferences
Future<void> removeToken() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('token');
  print("Token removed");
}

// Function to save the agent id to SharedPreferences
Future<void> saveAgentId(int id) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('agentId', id);
  print('Agent id saved: $id');
}

// Function to get the agent id from SharedPreferences
Future<int?> loadAgentId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('agentId');
}

// Function to remove the agent id from SharedPreferences
Future<void> removeAgentId() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('agentId');
  print("Agent id removed");
}
