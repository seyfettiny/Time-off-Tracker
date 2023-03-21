import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeofftracker/app/enums/timeoff_status.dart';
import 'package:timeofftracker/app/enums/timeoff_type.dart';

part '../app/generated/timeoff_request_model.freezed.dart';
part '../app/generated/timeoff_request_model.g.dart';

@freezed
class TimeOffRequestModel with _$TimeOffRequestModel {
  const factory TimeOffRequestModel({
    String? id,
    required String startDate,
    required String endDate,
    required String requestedAt,
    required String userId,
    required TimeOffType timeOffType,
    required TimeOffStatus timeOffStatus,
    String? reason,
  }) = _TimeOffRequestModel;

  factory TimeOffRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TimeOffRequestModelFromJson(json);
}