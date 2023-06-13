import 'dart:convert';

import 'package:fsm_agent/Models/AcceptReject.dart';
import 'package:fsm_agent/Models/JobNote.dart';
import 'package:fsm_agent/views/JobNotes.dart';
import 'package:http/http.dart' as http;
import 'package:fsm_agent/Models/Job.dart';

class ApiService {
  static const baseUrl = 'http://192.168.8.139:8080';

// fetch assigned jobs of agent
  Future<List<Job>> getAssignedJobs() async {
    var agentId = 2;
    final response = await http
        .get(Uri.parse('http://192.168.8.139:8080/get-assigned/$agentId'));
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
    final response = await http
        .get(Uri.parse('http://192.168.8.139:8080/get-progressed/$agentId'));
    if (response.statusCode == 200) {
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
    final response = await http
        .get(Uri.parse('http://192.168.8.139:8080/get-completed/$agentId'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => Job.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to get completed jobs');
    }
  }

  Future<AcceptReject> rejectJob(int jobId) async {
    final response = await http
        .put(Uri.parse('http://192.168.8.139:8080/task-reject/$jobId'));
    if (response.statusCode == 200) {
      return AcceptReject.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to reject jobs');
    }
  }

  Future<AcceptReject> acceptJob(int jobId) async {
    final response = await http
        .put(Uri.parse('http://192.168.8.139:8080/task-accept/$jobId'));
    if (response.statusCode == 200) {
      return AcceptReject.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to accept jobs');
    }
  }

  Future<AcceptReject> completeJob(int jobId) async {
    final response = await http
        .put(Uri.parse('http://192.168.8.139:8080/task-complete/$jobId'));
    if (response.statusCode == 200) {
      return AcceptReject.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to complete job');
    }
  }

// fetch jobs notes of task
  Future<List<JobNote>> getJobNotes(int jobId) async {
    final response = await http
        .get(Uri.parse('http://192.168.8.139:8080/get-task-notes/$jobId'));
    if (response.statusCode == 200) {
      return (jsonDecode(response.body) as List)
          .map((e) => JobNote.fromJson(e))
          .toList();
    } else {
      throw Exception('Failed to load job notes');
    }
  }

// post jobs notes of task
  Future<JobNote> addJobNote(JobNote jobNote) async {
    final response = await http.post(
      Uri.parse('http://192.168.8.139:8080/add-task-note'),
      body: jsonEncode(<String, dynamic>{
        'taskId': jobNote.taskId,
        'message': jobNote.message,
        'date': jobNote.date.toIso8601String(),
      }),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      return JobNote.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to post job note');
    }
  }

// update jobs notes of task
  Future<JobNote> updateJobNote() async {
    final response =
        await http.put(Uri.parse('http://192.168.8.139:8080/update-task-note'));
    if (response.statusCode == 200) {
      return JobNote.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to update job note');
    }
  }

  // post delete notes of task
  Future<JobNote> deleteJobNote(int jobId) async {
    final response = await http
        .delete(Uri.parse('http://192.168.8.139:8080/delete-task-note/$jobId'));
    if (response.statusCode == 200) {
      return JobNote.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to delete job note');
    }
  }
}
