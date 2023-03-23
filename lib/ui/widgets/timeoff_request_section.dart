import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/app/enums/timeoff_status.dart';
import 'package:timeofftracker/app/enums/user_type.dart';
import 'package:timeofftracker/models/timeoff_request_model.dart';
import 'package:timeofftracker/models/user_model.dart';
import 'package:timeofftracker/viewmodel/homeview_viewmodel.dart';

class TimeOffRequestSection extends ConsumerWidget {
  final List<TimeOffRequestModel> requestList;
  final UserModel user;
  const TimeOffRequestSection( {
    super.key,
    required this.user,
    required this.requestList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return user.userType == UserType.employee
        ? _buildforEmployee(context, ref)
        : _buildforManager(context, ref);
  }

  Widget _buildforManager(BuildContext context, WidgetRef ref) {
    return AnimationLimiter(
      child: Column(
        children: [
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Onay Bekleyen İzinler',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  // TODO: move this logic to viewmodel
                  requestList
                      .where((element) =>
                          element.timeOffStatus == TimeOffStatus.pending)
                      .length
                      .toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: const BoxDecoration(color: Colors.white),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Onaylanan İzinler',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  // TODO: move this logic to viewmodel
                  requestList
                      .where((element) =>
                          element.timeOffStatus == TimeOffStatus.approved)
                      .length
                      .toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: const BoxDecoration(color: Colors.white),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reddedilen İzinler',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  // TODO: move this logic to viewmodel
                  requestList
                      .where((element) =>
                          element.timeOffStatus == TimeOffStatus.rejected)
                      .length
                      .toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bugün İzinli Sayısı',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  // TODO: move this logic to viewmodel
                  // Users that have a timeoff request today
                  requestList
                      .where(
                        (element) {
                          final startDate = DateTime.parse(element.startDate);
                          final endDate = DateTime.parse(element.endDate);
                          return (element.timeOffStatus.name.toLowerCase() ==
                                  'approved' &&
                              startDate.isBefore(DateTime.now()) &&
                              endDate.isAfter(DateTime.now()));
                        },
                      )
                      .length
                      .toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildforEmployee(BuildContext context, WidgetRef ref) {
    final userAsyncValue = ref.watch(currentUserProvider);
    return AnimationLimiter(
      child: Column(
        children: [
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Onaylanan İzinlerim',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  // TODO: move this logic to viewmodel
                  requestList
                      .where((element) =>
                          element.timeOffStatus.name.toLowerCase() ==
                          'approved')
                      .length
                      .toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: const BoxDecoration(color: Colors.white),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reddedilen İzinlerim',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  // TODO: move this logic to viewmodel
                  requestList
                      .where((element) =>
                          element.timeOffStatus.name.toLowerCase() ==
                          'rejected')
                      .length
                      .toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 4),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: const BoxDecoration(color: Colors.white),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ücretsiz İzinlerim',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                Text(
                  // TODO: move this logic to viewmodel
                  requestList
                      .where((element) =>
                          element.timeOffType.name.toLowerCase() == 'unpaid')
                      .length
                      .toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 70,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yıllık İzin Hakkım',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.surface,
                  ),
                ),
                userAsyncValue.when(data: (data) {
                  return Text(
                    // TODO: move this logic to viewmodel
                    '${data.timeOffBalance.toString()} gün',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  );
                }, error: (error, stacktrace) {
                  throw error;
                }, loading: () {
                  return const Text('');
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
