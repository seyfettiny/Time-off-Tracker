import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:timeofftracker/app/enums/user_type.dart';

part '../app/generated/user_model.freezed.dart';
part '../app/generated/user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required UserType userType,
    @Default(24) int timeOffBalance,
    required String fullName,
    List<String>? timeOffRequests,
    String? photoURL,
  }) = _User;

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
