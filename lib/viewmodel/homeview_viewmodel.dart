import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/models/timeoff_request_model.dart';
import 'package:timeofftracker/services/firestore_service.dart';

final homeViewVMProvider =
    StateNotifierProvider.autoDispose<HomeViewVM, bool>((ref) {
  return HomeViewVM(ref);
});

// final timeOffRequestListProvider = FutureProvider((ref) async {
//   return ref.read(homeViewVMProvider.notifier).getAllTimeOffRequests();
// });

// final timeOffRequestListProvider =
//     StreamProvider.autoDispose<List<TimeOffRequestModel>>((ref) async* {
//   final homeViewVM = ref.read(homeViewVMProvider.notifier);
//   await for (final timeOffRequestList in homeViewVM.getTimeOffRequestsById()) {
//     yield timeOffRequestList;
//   }
// });

final messageProvider =
    StreamProvider.autoDispose<List<TimeOffRequestModel>>((ref) async* {
  final vmRef = ref.watch(homeViewVMProvider.notifier);
  List<TimeOffRequestModel> allRequests = [];
  await for (TimeOffRequestModel value
      in vmRef.getTimeOffRequestsById().cast()) {
    allRequests = [...allRequests, value];
    yield allRequests;
  }
});

class HomeViewVM extends StateNotifier<bool> {
  final Ref _ref;

  HomeViewVM(this._ref) : super(false);

  bool get isLoading => state;

  Future<List<TimeOffRequestModel>> getAllTimeOffRequests() async {
    try {
      state = true;
      final fireStoreService = _ref.read(firestoreServiceProvider);
      final querySnapshot = await fireStoreService.getAllTimeOffRequests();

      final timeOffRequestList = querySnapshot.map((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        data['startDate'] = data['startDate'].toDate().toString();
        data['endDate'] = data['endDate'].toDate().toString();
        data['requestedAt'] = data['requestedAt'].toDate().toString();
        return TimeOffRequestModel.fromJson(data);
      }).toList();
      return timeOffRequestList;
    } finally {
      state = false;
    }
  }

  Stream<List<TimeOffRequestModel>> getTimeOffRequestsById() async* {
    final fireStoreService = _ref.read(firestoreServiceProvider);
    debugPrint(FirebaseAuth.instance.currentUser!.uid);
    final stream = fireStoreService
        .getTimeOffRequestsByUserId(FirebaseAuth.instance.currentUser!.uid);
    yield* stream.map((event) {
      final timeOffRequestList = event.docs.map((e) {
        Map<String, dynamic> data = e.data() as Map<String, dynamic>;
        data['startDate'] = data['startDate'].toDate().toString();
        data['endDate'] = data['endDate'].toDate().toString();
        data['requestedAt'] = data['requestedAt'].toDate().toString();
        return TimeOffRequestModel.fromJson(data);
      }).toList();
      return timeOffRequestList;
    });
  }
}
