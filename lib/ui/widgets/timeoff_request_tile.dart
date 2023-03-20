import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:timeofftracker/app/enums/timeoff_status.dart';
import 'package:timeofftracker/models/timeoff_request_model.dart';

class TimeOffRequestTile extends StatelessWidget {
  final TimeOffRequestModel timeoffRequest;
  const TimeOffRequestTile({
    required this.timeoffRequest,
    super.key,
  });

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return const SizedBox(
              height: 475,
              child: Center(
                child: Text('Talep Detayı'),
              ),
            );
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeoffRequest.timeOffType.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  formatDateTime(DateTime.parse(timeoffRequest.requestedAt)),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              formatRequestDates(
                DateTime.parse(timeoffRequest.startDate),
                DateTime.parse(timeoffRequest.endDate),
                calculateWorkDays(
                  DateTime.parse(timeoffRequest.startDate),
                  DateTime.parse(timeoffRequest.endDate),
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            if (timeoffRequest.timeOffStatus == TimeOffStatus.pending)
              const PendingChip(),
            if (timeoffRequest.timeOffStatus == TimeOffStatus.approved)
              const ApprovedChip(),
            if (timeoffRequest.timeOffStatus == TimeOffStatus.rejected)
              const RejectedChip(),
          ],
        ),
      ),
    );
  }
}

class PendingChip extends StatelessWidget {
  const PendingChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24,
      child: Chip(
        label: Text('Bekliyor'),
        labelStyle: TextStyle(color: Color(0xff026AA2)),
        backgroundColor: Color(0xffF0F9FF),
        padding: EdgeInsets.only(bottom: 8),
      ),
    );
  }
}

class ApprovedChip extends StatelessWidget {
  const ApprovedChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24,
      child: Chip(
        label: Text('Onaylandı'),
        labelStyle: TextStyle(color: Color(0xff027A48)),
        backgroundColor: Color(0xffECFDF3),
        padding: EdgeInsets.only(bottom: 8),
      ),
    );
  }
}

class RejectedChip extends StatelessWidget {
  const RejectedChip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 24,
      child: Chip(
        label: Text('Reddedildi'),
        labelStyle: TextStyle(color: Color(0xffC01048)),
        backgroundColor: Color(0xffFFF1F3),
        padding: EdgeInsets.only(bottom: 8),
      ),
    );
  }
}
