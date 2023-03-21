import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:rive/rive.dart';
import 'package:timeofftracker/app/enums/timeoff_status.dart';
import 'package:timeofftracker/app/enums/user_type.dart';
import 'package:timeofftracker/app/util/date_time_formatter.dart';
import 'package:timeofftracker/models/timeoff_request_model.dart';
import 'package:timeofftracker/models/user_model.dart';
import 'package:timeofftracker/services/firestore_service.dart';
import 'package:timeofftracker/ui/view/error_view.dart';
import 'package:timeofftracker/ui/widgets/custom_chip.dart';
import 'package:timeofftracker/ui/widgets/custom_button.dart';
import 'package:timeofftracker/viewmodel/homeview_viewmodel.dart';

class TimeOffRequestTile extends ConsumerWidget {
  final UserModel user;
  final TimeOffRequestModel timeoffRequest;
  const TimeOffRequestTile({
    required this.user,
    required this.timeoffRequest,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateTimeFormatter = ref.read(dateTimeFormatterProvider);
    return GestureDetector(
      onTap: () {
        requestModalBottomSheet(context, ref, user);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.all(10),
        height: 100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timeoffRequest.timeOffType.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  dateTimeFormatter.formatDateTime(
                      DateTime.parse(timeoffRequest.requestedAt)),
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              dateTimeFormatter.formatRequestDates(
                DateTime.parse(timeoffRequest.startDate),
                DateTime.parse(timeoffRequest.endDate),
                dateTimeFormatter.calculateWorkDays(
                  DateTime.parse(timeoffRequest.startDate),
                  DateTime.parse(timeoffRequest.endDate),
                ),
              ),
              style: TextStyle(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            _buildChipType(ref, timeoffRequest.timeOffStatus, user),
          ],
        ),
      ),
    );
  }

  Widget _buildChipType(
      WidgetRef ref, TimeOffStatus timeOffStatus, UserModel user) {
    if (user.userType == UserType.employee) {
      switch (timeOffStatus) {
        case TimeOffStatus.pending:
          return const CustomChip.pending();
        case TimeOffStatus.rejected:
          return const CustomChip.rejected();
        case TimeOffStatus.approved:
          return const CustomChip.approved();
        default:
          return const CustomChip.pending();
      }
    } else {
      //final userName = ref.read(homeViewVMProvider.notifier).getUserById(timeoffRequest.userId);
      return CustomChip.user(
        text: FirebaseAuth.instance.currentUser!.displayName!,
      );
    }
  }

  Future<dynamic> requestModalBottomSheet(
      BuildContext context, WidgetRef ref, UserModel user) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(8),
        ),
      ),
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: user.userType == UserType.employee
            ? MediaQuery.of(context).size.height * .6
            : MediaQuery.of(context).size.height * .7,
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(8),
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    height: 4,
                    width: 36,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Talep Detayları',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 50,
                left: 0,
                right: 0,
                
                bottom: timeoffRequest.timeOffStatus == TimeOffStatus.rejected
                    ? 0
                    // TODO: change this 50 for manager userType
                    : 50,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatusColumn(
                            context,
                            timeoffRequest.timeOffStatus,
                          ),
                          _modalSheetContentRow(
                            title: 'İzin Türü',
                            value: timeoffRequest.timeOffType.name,
                          ),
                          _modalSheetContentRow(
                            title: 'İzne Çıkış',
                            value: ref
                                .read(dateTimeFormatterProvider)
                                .formatDateTimewithDots(
                                    DateTime.parse(timeoffRequest.startDate))
                                .toString()
                                .split(' ')[0],
                          ),
                          _modalSheetContentRow(
                            title: 'İşe Başlama',
                            value: ref
                                .read(dateTimeFormatterProvider)
                                .formatDateTimewithDots(
                                    DateTime.parse(timeoffRequest.endDate).add(
                                  const Duration(days: 1),
                                ))
                                .toString()
                                .split(' ')[0],
                          ),
                          _modalSheetContentRow(
                            title: 'İzinli Gün Toplamı',
                            value: ref
                                .read(dateTimeFormatterProvider)
                                .calculateWorkDays(
                                    DateTime.parse(timeoffRequest.startDate),
                                    DateTime.parse(timeoffRequest.endDate))
                                .toString(),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(bottom: 10),
                                alignment: Alignment.centerLeft,
                                child: const Text('Açıklama'),
                              ),
                              Text(
                                timeoffRequest.reason ?? '',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              timeoffRequest.timeOffStatus == TimeOffStatus.rejected
                  ? const SizedBox()
                  : Positioned(
                      bottom: 0,
                      right: 0,
                      left: 0,
                      child: Container(
                        color: Colors.white,
                        child: Column(
                          children: [
                            //CustomButton(onPressed: () {}, title: 'Kabul Et'),
                            CustomButton.cancelStyle(
                              onPressed: () {
                                showCancelConfirmationDialog(context, ref);
                              },
                              title: 'Talebi İptal Et',
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          ),
        );
      },
    );
  }

  Future<Object?> showCancelConfirmationDialog(
      BuildContext context, WidgetRef ref) {
    return showGeneralDialog(
      context: context,
      pageBuilder: (context, animation, secondaryAnimation) {
        return AlertDialog(
          title: const Text('Talebi İptal Et'),
          content: const Text('Talebi iptal etmek istediğinize emin misiniz?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(homeViewVMProvider.notifier)
                    .cancelTimeOffRequest(timeoffRequest.id!)
                    .then((value) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                });
              },
              child: const Text('Evet'),
            ),
          ],
        );
      },
    );
  }

  Container _modalSheetContentRow(
      {required String title, required String value}) {
    return Container(
      height: 24,
      margin: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusColumn(BuildContext context, TimeOffStatus status) {
    switch (status) {
      case TimeOffStatus.pending:
        return const SizedBox(
          height: 40,
        );
      case TimeOffStatus.approved:
        return SizedBox(
          height: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              SizedBox.square(
                dimension: 64,
                child: RiveAnimation.asset('assets/rive/success.riv'),
              ),
              Text(
                'Talep Onaylandı',
                style:
                    TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      case TimeOffStatus.rejected:
        return SizedBox(
          height: 140,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              SizedBox.square(
                dimension: 72,
                child: RiveAnimation.asset(
                  'assets/rive/error.riv',
                  animations: [],
                ),
              ),
              Text(
                'Talebin Onaylanmadı',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      default:
        return const SizedBox(
          height: 40,
        );
    }
  }
}
