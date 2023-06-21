import 'package:intl/intl.dart';

String dateTime() {
  DateTime dateObj = DateTime.now();
  String formattedDateTime = DateFormat('MMM d, yyyy, h:mm a').format(dateObj);
  return formattedDateTime;
}
