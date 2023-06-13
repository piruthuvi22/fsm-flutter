class JobNote {
  // final int id;
  final int taskId;
  final String message;
  final DateTime date;

  const JobNote({
    required this.taskId,
    required this.message,
    required this.date,
  });

  factory JobNote.fromJson(Map<String, dynamic> json) {
    return JobNote(
      taskId: json['taskId'],
      message: json['message'],
      date: DateTime.parse(json['date']),
    );
  }
}
