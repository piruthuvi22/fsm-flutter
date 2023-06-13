class Job {
  final int id;
  final String title;
  final String description;
  final String date;
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
    return Job(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      address: json['address'],
      customerName: json['customerName'],
      phoneNumber: json['phoneNumber'],
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