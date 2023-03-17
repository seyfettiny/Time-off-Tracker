import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/app/enums/user_type.dart';
import 'package:timeofftracker/models/timeoff_request_model.dart';

final firestoreServiceProvider = Provider<FireStoreService>((ref) {
  return FireStoreService();
});

class FireStoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference _timeOffCollectionReference =
      FirebaseFirestore.instance.collection('TimeOffRequests');

  Future<void> createUser(
      String uid, UserType userType, int timeOffBalance) async {
    await _usersCollectionReference.doc(uid).set({
      'userType': userType.name.toString(),
      'timeOffBalance': timeOffBalance,
      'timeOffRequests': [],
    });
  }

  Future<DocumentSnapshot> getUserById(String uid) async {
    return await _usersCollectionReference.doc(uid).get();
  }

  Future<void> updateTimeOffBalance(int timeOffBalance) async {
    await _usersCollectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'timeOffBalance': timeOffBalance});
  }

  Future<void> createTimeOffRequest(
      TimeOffRequestModel timeOffRequestModel) async {
    await _timeOffCollectionReference.add({
      'uid': FirebaseAuth.instance.currentUser!.uid,
      'startDate': timeOffRequestModel.startDate,
      'endDate': timeOffRequestModel.endDate,
      'requestedAt': timeOffRequestModel.requestedAt,
      'reason': timeOffRequestModel.reason,
      'userId': timeOffRequestModel.userId,
      'timeOffStatus': timeOffRequestModel.timeOffStatus.name,
      'timeOffType': timeOffRequestModel.timeOffType.name,
      //'numberOfDays': timeOffRequestModel.numberOfDays,
    });
  }

  Future<List<QueryDocumentSnapshot>> getAllTimeOffRequests() async {
    final querySnapshot = await _timeOffCollectionReference.get();
    return querySnapshot.docs;
  }

  Stream<QuerySnapshot> getTimeOffRequestsByUserId(String userId) {
    return _timeOffCollectionReference
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> updateTimeOffRequestStatus(
      String requestId, String newStatus) async {
    await _timeOffCollectionReference
        .doc(requestId)
        .update({'timeOffStatus': newStatus});
  }
}
