import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:timeofftracker/models/timeoff_request_model.dart';
import 'package:timeofftracker/services/firestore_service.dart';

part '../app/generated/timeoff_requestview_viewmodel.g.dart';

@riverpod
class TimeOffRequestVM extends _$TimeOffRequestVM {
  @override
  Future<void> build() async {}

  Future<void> createTimeOffRequest(
      TimeOffRequestModel timeOffRequestModel) async {
    final firestoreRef = ref.read(firestoreServiceProvider);

    state = const AsyncLoading();

    state = await AsyncValue.guard(() {
      return firestoreRef.createTimeOffRequest(timeOffRequestModel);
    });
  }
}
