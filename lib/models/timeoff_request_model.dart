import 'package:timeofftracker/app/enums/timeoff_status.dart';
import 'package:timeofftracker/app/enums/timeoff_type.dart';

class TimeOffRequestModel {
  DateTime startDate;
  DateTime endDate;
  DateTime requestedAt;
  int numberOfDays;
  String userId;
  TimeOffType timeOffType;
  TimeOffStatus timeOffStatus;
  String? reason;

  TimeOffRequestModel({
    required this.startDate,
    required this.endDate,
    required this.requestedAt,
    required this.numberOfDays,
    required this.userId,
    required this.timeOffType,
    required this.timeOffStatus,
    this.reason,
  });
}
