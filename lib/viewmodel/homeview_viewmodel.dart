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
    StreamProvider.autoDispose<List<TimeOffRequestModel>>((ref) async* {
  final vmRef = ref.watch(homeViewVMProvider.notifier);
  if (FirebaseAuth.instance.currentUser != null) {
    await for (final timeOffRequestList in vmRef
        .getTimeOffRequestsById(FirebaseAuth.instance.currentUser!.uid)) {
      yield timeOffRequestList;
    }
  }
});

final allTimeOffRequestListProvider =
    StreamProvider.autoDispose<List<TimeOffRequestModel>>((ref) async* {
  final vmRef = ref.watch(homeViewVMProvider.notifier);
  if (FirebaseAuth.instance.currentUser != null) {
    await for (final timeOffRequestList in vmRef.getAllTimeOffRequests()) {
      yield timeOffRequestList;
    }
  }
});

final userByIdProvider =
    FutureProvider.family<UserModel, String>((ref, id) async {
  final vmRef = ref.watch(homeViewVMProvider.notifier);
  final user = await vmRef.getUserById(id);
  return UserModel.fromJson(user.data() as Map<String, dynamic>);
});

final userListWithTimeoffRequestsProvider =
    FutureProvider.autoDispose<List<UserModel>>((ref) async {
  final vmRef = ref.watch(homeViewVMProvider.notifier);
  final users = await vmRef.getUsersWithTimeOffRequests();
  return users
      .map((e) => UserModel.fromJson(e.data() as Map<String, dynamic>))
      .toList();
});

final currentUserProvider = FutureProvider.autoDispose<UserModel>((ref) async {
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

  Stream<List<TimeOffRequestModel>> getAllTimeOffRequests() async* {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    final stream = fireStoreService.getAllTimeOffRequests();
    
    yield* stream.map((snapshot) {
      return state = snapshot.docs.map(parseResult).toList();
    });
  }

  Future<List<QueryDocumentSnapshot>> getAllUsers() async {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    final querySnapshot = await fireStoreService.getAllUsers();
    return querySnapshot;
  }

  Future<List<QueryDocumentSnapshot>> getUsersWithTimeOffRequests() async {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    final querySnapshot = await fireStoreService.getUsersWithTimeOffRequests();
    return querySnapshot;
  }

  Stream<List<TimeOffRequestModel>> getTimeOffRequestsById(String id) async* {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    final stream = fireStoreService.getTimeOffRequestsByUserId(id);

    yield* stream.map((snapshot) {
      return state = snapshot.docs.map(parseResult).toList();
    });
  }

  Future<void> approveTimeOffRequest(String requestId,String userId) async {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    await fireStoreService.approveTimeOffRequest(requestId,userId);
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
