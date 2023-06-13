class AcceptReject {
  final int id;
  final String message;
  final String status;

  const AcceptReject(
      {required this.id, required this.message, required this.status});

  factory AcceptReject.fromJson(Map<String, dynamic> json) {
    return AcceptReject(
        id: json['id'], message: json['message'], status: json['status']);
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