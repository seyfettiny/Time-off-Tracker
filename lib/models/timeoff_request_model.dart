import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeofftracker/app/enums/timeoff_status.dart';
import 'package:timeofftracker/app/enums/timeoff_type.dart';

part 'timeoff_request_model.freezed.dart';

@freezed
class TimeOffRequestModel with _$TimeOffRequestModel {
  const factory TimeOffRequestModel({
    required DateTime startDate,
    required DateTime endDate,
    required DateTime requestedAt,
    required int numberOfDays,
    required String userId,
    required TimeOffType timeOffType,
    required TimeOffStatus timeOffStatus,
    String? reason,
  }) = _TimeOffRequestModel;

  factory TimeOffRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TimeOffRequestModelFromJson(json);
}
