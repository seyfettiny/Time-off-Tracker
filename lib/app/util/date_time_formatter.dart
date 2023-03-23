import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';

final dateTimeFormatterProvider = Provider((ref) => DateTimeFormatter());

class DateTimeFormatter {
  String formatDateTime(DateTime dateTime) {
    String formattedDateTime;
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));

    if (dateTime.isAfter(today)) {
      formattedDateTime = 'Today ${DateFormat('HH:mm').format(dateTime)}';
    } else if (dateTime.isAfter(yesterday)) {
      formattedDateTime = 'Yesterday ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      formattedDateTime = DateFormat('d MMM, y, HH:mm').format(dateTime);
    }

    return formattedDateTime;
  }

  String formatDateTimewithDots(DateTime dateTime) {
    String formattedDateTime = DateFormat('dd.MM.yyyy').format(dateTime);
    return formattedDateTime;
  }

  int calculateWorkDays(DateTime startDate, DateTime endDate) {
    int workDays = 0;
    DateTime date = startDate;

    while (date.isBefore(endDate) || date == endDate) {
      if (date.weekday != DateTime.saturday &&
          date.weekday != DateTime.sunday) {
        workDays++;
      }
      date = date.add(const Duration(days: 1));
    }
    
    return workDays;
  }

  String formatRequestDates(
      DateTime startDate, DateTime endDate, int workDays) {
    String formattedDates;

    String startDateString = DateFormat('dd.MM.yyyy').format(startDate);
    String endDateString = DateFormat('dd.MM.yyyy').format(endDate);

    if (workDays == 1) {
      formattedDates = '$startDateString - $endDateString (1 work day)';
    } else {
      formattedDates =
          '$startDateString - $endDateString ($workDays work days)';
    }

    return formattedDates;
  }
}
