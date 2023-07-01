import 'package:fsm_agent/enums/JobUpdateType.dart';

class JobUpdate {
  final int id;
  final int taskId;
  final String data;
  final DateTime date;
  final JobUpdateType type;

  const JobUpdate({
    required this.id,
    required this.taskId,
    required this.data,
    required this.date,
    required this.type,
  });

  factory JobUpdate.fromJson(Map<String, dynamic> json) {
    return JobUpdate(
        id: json['id'],
        taskId: json['taskId'],
        data: json['data'],
        date: DateTime.parse(json['date']),
        // json['type'] == 'TEXT'? type: JobUpdateType.TEXT:type: JobUpdateType.IMAGE);
        type:
            json["type"] == "TEXT" ? JobUpdateType.TEXT : JobUpdateType.IMAGE);
    // type: JobUpdateType.values.firstWhere(
    //   (element) => element.toString() == json['type'],
    // ),
    // type: JobUpdateType.TEXT);
  }
}
