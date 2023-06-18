import 'package:intl/intl.dart';

class Job {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String address;
  final String customerName;
  final String phoneNumber;
  final String status;

  const Job({
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.address,
    required this.customerName,
    required this.phoneNumber,
    required this.status,
  });

  factory Job.fromJson(Map<String, dynamic> json) {
    final DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    final DateTime parsedDate = dateFormat.parse(json['date']);
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: parsedDate,
      address: json['address'],
      customerName: json['customerName'],
      phoneNumber: json['customerPhoneNumber'],
      status: json['status'],
    );
  }
}
/**
 * 
 *   private int id;
    private String title;
    private String description;
    private String date;
    private String address;
    private String customerName;

 */