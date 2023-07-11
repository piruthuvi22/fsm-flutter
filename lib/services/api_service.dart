import 'package:fsm_agent/utils/functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fsm_agent/Models/AcceptReject.dart';
import 'package:fsm_agent/Models/JobUpdate.dart';
import 'package:fsm_agent/enums/JobUpdateType.dart';
import 'package:fsm_agent/views/Noteupdate.dart';
import 'package:fsm_agent/Models/Job.dart';

class ApiService {
  // static const baseUrl = 'http://10.10.23.243:8080'; // UoM Wireless
  static const baseUrl = 'http://192.168.8.139:8080'; // WiFi
  // static const baseUrl = 'http://192.168.143.104:8080'; // hotspot

  // static const baseSocketUrl = 'http://10.10.23.243:8081'; // UoM Wireless
  static const baseSocketUrl = 'http://192.168.8.139:8081'; // WiFi
  // static const baseSocketUrl = 'http://192.168.143.104:8081'; // hotspot

  // Get agent id by email and store in shared preferences
  Future<int> getAgentIdByEmail(String email) async {
    final response =
        await http.get(Uri.parse('$baseUrl/user/get-user-id-by-email/$email'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body)['id'];
    } else {
      throw Exception('Failed to load agent id');
    }
  }

// fetch assigned jobs of agent
  Future<List<Job>> getAssignedJobs() async {
    int? agentId = await loadAgentId();

    final response = await http.get(Uri.parse('$baseUrl/get-assigned/2'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Job.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  //  fetch jobs in progress of agent
  Future<List<Job>> getProgressedJobs() async {
    var agentId = 2;
    final response =
        await http.get(Uri.parse('$baseUrl/get-progressed/$agentId'));
    if (response.statusCode == 200) {
      // print(response.body.toString());
      return (jsonDecode(response.body) as List)
          .map((e) => Job.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  //  fetch completed jobs of agent
  Future<List<Job>> getCompletedJobs() async {
    var agentId = 2;
    final response =
        await http.get(Uri.parse('$baseUrl/get-completed/$agentId'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Job.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to get completed jobs');
    }
  }

  Future<AcceptReject> rejectJob(int jobId) async {
    final response = await http.put(Uri.parse('$baseUrl/task-reject/$jobId'));
    if (response.statusCode == 200) {
      return AcceptReject.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to reject jobs');
    }
  }

  Future<AcceptReject> acceptJob(int jobId) async {
    final response = await http.put(Uri.parse('$baseUrl/task-accept/$jobId'));
    if (response.statusCode == 200) {
      return AcceptReject.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to accept jobs');
    }
  }

  Future<AcceptReject> completeJob(int jobId) async {
    final response = await http.put(Uri.parse('$baseUrl/task-complete/$jobId'));
    if (response.statusCode == 200) {
      return AcceptReject.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to complete job');
    }
  }

// fetch jobs notes of task
  Future<List<JobUpdate>> getJobUpdates(int jobId, JobUpdateType type) async {
    String typeString = type.toString().split('.').last;
    final response =
        await http.get(Uri.parse('$baseUrl/get-task-notes/$jobId/$typeString'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => JobUpdate.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load job notes');
    }
  }

// post jobs notes of task
  Future<JobUpdate> addJobUpdate(Map<String, dynamic> jobUpdate) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add-task-note'),
      body: jsonEncode(<String, dynamic>{
        'taskId': jobUpdate["taskId"],
        'data': jobUpdate["data"],
        'date': jobUpdate["date"].toIso8601String(),
        'type': jobUpdate["type"].toString().split('.').last,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return JobUpdate.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post job note');
    }
  }

  //  delete notes of task
  Future<dynamic> deleteJobUpdate(int jobId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/delete-task-note/$jobId'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to delete job note');
    }
  }

// fetch people list
  Future<List> getPeoples(String userId) async {
    final response =
        await http.get(Uri.parse('$baseSocketUrl/chatted-people/$userId'));
    if (response.statusCode == 200) {
      // print(response.body);
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load messages notes');
    }
  }

// fetch people list
  Future<List> getMessages(String userId, String receiverId) async {
    final response = await http
        .get(Uri.parse('$baseSocketUrl/messages/$userId/$receiverId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List;
    } else {
      throw Exception('Failed to load messages notes');
    }
  }

  Future<String> saveImage(String url) async {
    return url;
  }
}



//  const sendPrivateMessage = (e) => {
//     if (stompClient) {
//       let chatMsg = {
//         senderId: userData.username,
//         receiverId: userData.receiverId,
//         message: userData.message,
//       };

//       setMessages((prev) => ({
//         user: userData.receiverId,
//         message: [...prev.message, chatMsg],
//       }));

//       stompClient.send(
//         "/app/private-message/" + userData.receiverId,
//         {},
//         JSON.stringify(chatMsg)
//       );
//       setUserData((prev) => ({ ...prev, message: "" }));
//     }
//   };