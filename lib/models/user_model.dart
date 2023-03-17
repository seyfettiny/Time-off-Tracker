import 'package:timeofftracker/app/enums/user_type.dart';

class User {
  final String uid;
  final String name;
  final String email;
  final String? photoURL;
  final int? timeOffBalance;
  final UserType userType;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.userType,
    this.photoURL,
    this.timeOffBalance = 28,
  });
}
