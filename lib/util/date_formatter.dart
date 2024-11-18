import 'package:intl/intl.dart';

String formatTimestamp(DateTime timestamp) {
  return DateFormat('dd MMM yyyy, HH:mm').format(timestamp);
}
