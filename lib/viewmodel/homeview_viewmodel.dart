import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/models/timeoff_request_model.dart';
import 'package:timeofftracker/models/user_model.dart';
import 'package:timeofftracker/services/firestore_service.dart';

final homeViewVMProvider =
    StateNotifierProvider<HomeViewVM, List<TimeOffRequestModel>>((ref) {
  return HomeViewVM(ref);
});

final timeOffRequestListByCurrentUserProvider =
    StreamProvider<List<TimeOffRequestModel>>((ref) async* {
  final vmRef = ref.watch(homeViewVMProvider.notifier);

  await for (final timeOffRequestList in vmRef.getTimeOffRequestsById()) {
    yield timeOffRequestList;
  }
});

final allTimeOffRequestListProvider =
    FutureProvider<List<TimeOffRequestModel>>((ref) async {
  final vmRef = ref.watch(homeViewVMProvider.notifier);
  final timeOffRequestList = await vmRef.getAllTimeOffRequests();
  return timeOffRequestList;
});

final currentUserProvider = FutureProvider<UserModel>((ref) async {
  final vmRef = ref.watch(homeViewVMProvider.notifier);
  final user = await vmRef.getUserById(FirebaseAuth.instance.currentUser!.uid);
  return UserModel.fromJson(user.data() as Map<String, dynamic>);
});

final allUsersProvider = FutureProvider<List<UserModel>>((ref) async {
  final vmRef = ref.watch(homeViewVMProvider.notifier);
  final users = await vmRef.getAllUsers();
  return users
      .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
      .toList();
});

class HomeViewVM extends StateNotifier<List<TimeOffRequestModel>> {
  final Ref _ref;

  HomeViewVM(this._ref) : super([]);

  Future<List<TimeOffRequestModel>> getAllTimeOffRequests() async {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    final querySnapshot = await fireStoreService.getAllTimeOffRequests();
    return state = querySnapshot.map(parseResult).toList();
  }

  Future<List<QueryDocumentSnapshot>> getAllUsers() async {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    final querySnapshot = await fireStoreService.getAllUsers();
    return querySnapshot;
  }

  Stream<List<TimeOffRequestModel>> getTimeOffRequestsById() async* {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    final stream = fireStoreService
        .getTimeOffRequestsByUserId(FirebaseAuth.instance.currentUser!.uid);

    yield* stream.map((snapshot) {
      return state = snapshot.docs.map(parseResult).toList();
    });
  }

  Future<void> cancelTimeOffRequest(String id) async {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    await fireStoreService.cancelTimeOffRequest(id);
  }

  TimeOffRequestModel parseResult(QueryDocumentSnapshot querySnapshot) {
    Map<String, dynamic> data = querySnapshot.data() as Map<String, dynamic>;
    data['id'] = querySnapshot.id;
    data['startDate'] = data['startDate'].toString();
    data['endDate'] = data['endDate'].toString();
    data['requestedAt'] = data['requestedAt'].toString();
    data['timeOffStatus'] = data['timeOffStatus'].toString().toLowerCase();
    data['timeOffType'] = data['timeOffType'].toString().toLowerCase();

    return TimeOffRequestModel.fromJson(data);
  }

  Future<DocumentSnapshot> getUserById(String userId) async {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    final documentSnapshot = await fireStoreService.getUserById(userId);
    return documentSnapshot;
  }
}
