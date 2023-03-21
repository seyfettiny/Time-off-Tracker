import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/models/timeoff_request_model.dart';
import 'package:timeofftracker/models/user_model.dart';

final firestoreServiceProvider = Provider<FireStoreService>((ref) {
  return FireStoreService();
});

class FireStoreService {
  final CollectionReference _usersCollectionReference =
      FirebaseFirestore.instance.collection('Users');

  final CollectionReference _timeOffCollectionReference =
      FirebaseFirestore.instance.collection('TimeOffRequests');

  Future<void> createUser(UserModel userModel) async {
    await _usersCollectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'fullName': userModel.fullName,
      'userType': userModel.userType.name.toString(),
      'timeOffBalance': userModel.timeOffBalance,
      'timeOffRequests': userModel.timeOffRequestList,
    });
  }

  Future<DocumentSnapshot> getUserById(String uid) async {
    return await _usersCollectionReference.doc(uid).get();
  }

  Future<List<QueryDocumentSnapshot>> getAllUsers() async {
    final querySnapshot = await _usersCollectionReference.get();
    return querySnapshot.docs;
  }

  Future<void> updateTimeOffBalance(int timeOffBalance) async {
    await _usersCollectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'timeOffBalance': timeOffBalance});
  }

  Future<void> createTimeOffRequest(
      TimeOffRequestModel timeOffRequestModel) async {
    final doc = await _timeOffCollectionReference.add({
      'startDate': timeOffRequestModel.startDate,
      'endDate': timeOffRequestModel.endDate,
      'requestedAt': timeOffRequestModel.requestedAt,
      'reason': timeOffRequestModel.reason,
      'userId': timeOffRequestModel.userId,
      'timeOffStatus': timeOffRequestModel.timeOffStatus.name,
      'timeOffType': timeOffRequestModel.timeOffType.name,
    });
    await _usersCollectionReference.doc(timeOffRequestModel.userId).update({
      'timeOffRequests': FieldValue.arrayUnion([doc.id]),
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

  Future<void> cancelTimeOffRequest(String requestId) async {
    await _timeOffCollectionReference.doc(requestId).delete();
  }
}
