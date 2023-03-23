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
      'timeOffRequests': userModel.timeOffRequests,
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
    //TODO: Throw exception if timeOffBalance is less than timeOffRequest
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

  Stream<QuerySnapshot> getAllTimeOffRequests() {
    final querySnapshot = _timeOffCollectionReference.snapshots();
    return querySnapshot;
  }

  Future<List<QueryDocumentSnapshot>> getUsersWithTimeOffRequests() async {
    final querySnapshot = await _usersCollectionReference
        .where('timeOffRequests', isNotEqualTo: []).get();
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
    //TODO: Add logic to add back time off days to user's balance
    //TODO: Check if request startDate is in the past
    await _timeOffCollectionReference.doc(requestId).delete();
    await _usersCollectionReference
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'timeOffRequests': FieldValue.arrayRemove([requestId])
    });
  }

  Future<void> approveTimeOffRequest(String requestId, String userId) async {
    final timeOffRequest =
        (await _timeOffCollectionReference.doc(requestId).get()).data()
            as Map<String, dynamic>;

    if (timeOffRequest['timeOffType'] == 'annual') {
      //TODO: Throw exception if timeOffBalance is less than timeOffRequest
      await _usersCollectionReference.doc(userId).update({
        'timeOffBalance': FieldValue.increment(
            -DateTime.parse(timeOffRequest['endDate'])
                .difference(DateTime.parse(timeOffRequest['startDate']))
                .inDays),
      });
    }
    await _timeOffCollectionReference
        .doc(requestId)
        .update({'timeOffStatus': 'Approved'});
  }
}
