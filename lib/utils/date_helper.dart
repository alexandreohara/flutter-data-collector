import 'package:intl/intl.dart';

class DateHelper {
  // Method to create a timestamp formatted for file names
  static String createFileNameTimestamp() {
    final now = DateTime.now();
    final formatter =
        DateFormat('yyyyMMdd_HHmmss'); // Format: "20241201_193412"
    return formatter.format(now);
  }
}
