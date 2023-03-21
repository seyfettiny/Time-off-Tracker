import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:timeofftracker/app/enums/timeoff_status.dart';
import 'package:timeofftracker/app/enums/timeoff_type.dart';
import 'package:timeofftracker/app/util/date_time_formatter.dart';
import 'package:timeofftracker/models/timeoff_request_model.dart';
import 'package:timeofftracker/ui/view/result_view.dart';
import 'package:timeofftracker/ui/widgets/custom_button.dart';
import 'package:timeofftracker/viewmodel/timeoff_requestview_viewmodel.dart';

class TimeOffRequestView extends HookConsumerWidget {
  const TimeOffRequestView({super.key});

  static const routeName = '/timeoffrequest';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeoffRequestVM = ref.watch(timeOffRequestVMProvider.notifier);
    final dateTimeFormatter = ref.watch(dateTimeFormatterProvider);

    final dropdownSelectedValue = useState(TimeOffType.unpaid);
    final isVisible = useState(false);
    final startDateValue = useState(DateTime.now());
    final endDateValue = useState(DateTime.now());
    final reasonTextFieldController = useTextEditingController(text: '');

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
        isVisible.value = false;
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            'Yeni İzin Talebi',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.85,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          alignment: Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'İzin Türü',
                                style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  isVisible.value = !isVisible.value;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0),
                                  margin: const EdgeInsets.only(top: 8.0),
                                  height: 44,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    border: Border.all(
                                      color: const Color(0xffD0D5DD),
                                    ),
                                  ),
                                  child: Text(dropdownSelectedValue.value.name),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Çıkış Tarihi',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  //TODO: only allow available as annual leave day amount
                                  final DateTime pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                    currentDate: startDateValue.value,
                                  ) as DateTime;
                                  startDateValue.value = pickedDate;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0),
                                  margin: const EdgeInsets.only(top: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    border: Border.all(
                                      color: const Color(0xffD0D5DD),
                                    ),
                                  ),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 44,
                                    child: Text(dateTimeFormatter
                                        .formatDateTimewithDots(
                                            startDateValue.value)
                                        .split(' ')[0]),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Başlama Tarihi',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final DateTime pickedDate =
                                      await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now()
                                        .add(const Duration(days: 365)),
                                    currentDate: endDateValue.value,
                                  ) as DateTime;
                                  endDateValue.value = pickedDate;
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14.0),
                                  margin: const EdgeInsets.only(top: 8.0),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(8)),
                                    border: Border.all(
                                      color: const Color(0xffD0D5DD),
                                    ),
                                  ),
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    height: 44,
                                    child: Text(
                                      dateTimeFormatter
                                          .formatDateTimewithDots(
                                              endDateValue.value)
                                          .split(' ')[0],
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  'Açıklama (opsiyonel)',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onSurface,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14.0),
                                margin: const EdgeInsets.only(top: 8.0),
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(8)),
                                  border: Border.all(
                                    color: const Color(0xffD0D5DD),
                                  ),
                                ),
                                child: TextField(
                                  maxLines: 7,
                                  controller: reasonTextFieldController,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Açıklama',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        CustomButton(
                          onPressed: () {
                            //TODO: convert this to the form validation
                            assert(startDateValue.value
                                .isBefore(endDateValue.value));
                            timeoffRequestVM
                                .createTimeOffRequest(
                              TimeOffRequestModel(
                                startDate: startDateValue.value.toString(),
                                endDate: endDateValue.value.toString(),
                                requestedAt: DateTime.now().toString(),
                                userId: FirebaseAuth.instance.currentUser!.uid,
                                timeOffType: dropdownSelectedValue.value,
                                timeOffStatus: TimeOffStatus.pending,
                                reason: reasonTextFieldController.text,
                              ),
                            )
                                .then((value) {
                              context.go(ResultView.routeName);
                            });
                          },
                          title: 'Talep Gönder',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _buildDropDownMenuPopUp(isVisible, dropdownSelectedValue, context),
          ],
        ),
      ),
    );
  }

  Positioned _buildDropDownMenuPopUp(ValueNotifier<bool> isVisible,
      ValueNotifier<TimeOffType> dropdownSelectedValue, BuildContext context) {
    return Positioned(
      right: 20,
      top: 20,
      child: Visibility(
        visible: isVisible.value,
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
          ),
          height: 140,
          width: 340,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    isVisible.value = false;
                    dropdownSelectedValue.value = TimeOffType.annual;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: dropdownSelectedValue.value == TimeOffType.annual
                          ? const Color(0xffF9FAFB)
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Yıllık İzin ',
                          style: TextStyle(fontSize: 16),
                        ),
                        dropdownSelectedValue.value == TimeOffType.annual
                            ? Icon(Icons.done,
                                color: Theme.of(context).colorScheme.primary)
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    isVisible.value = false;
                    dropdownSelectedValue.value = TimeOffType.unpaid;
                  },
                  child: Container(
                    color: dropdownSelectedValue.value == TimeOffType.unpaid
                        ? const Color(0xffF9FAFB)
                        : Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ücretsiz İzin ',
                          style: TextStyle(fontSize: 16),
                        ),
                        dropdownSelectedValue.value == TimeOffType.unpaid
                            ? Icon(Icons.done,
                                color: Theme.of(context).colorScheme.primary)
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    isVisible.value = false;
                    dropdownSelectedValue.value = TimeOffType.paid;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: dropdownSelectedValue.value == TimeOffType.paid
                          ? const Color(0xffF9FAFB)
                          : Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Ücretli İzin ',
                          style: TextStyle(fontSize: 16),
                        ),
                        dropdownSelectedValue.value == TimeOffType.paid
                            ? Icon(Icons.done,
                                color: Theme.of(context).colorScheme.primary)
                            : const SizedBox()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
