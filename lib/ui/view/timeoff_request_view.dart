import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:timeofftracker/app/enums/timeoff_status.dart';
import 'package:timeofftracker/app/enums/timeoff_type.dart';
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

    final dropdownSelectedValue = useState(TimeOffType.unpaid);
    final startDateValue = useState(DateTime.now());
    final endDateValue = useState(DateTime.now());
    final reasonTextFieldController = useTextEditingController(text: '');
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
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
        body: SingleChildScrollView(
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
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          margin: const EdgeInsets.only(top: 8.0),
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                            border: Border.all(
                              color: const Color(0xffD0D5DD),
                            ),
                          ),
                          child: DropdownButton<TimeOffType>(
                            underline: const SizedBox(),
                            isExpanded: true,
                            value: dropdownSelectedValue.value,
                            icon:
                                const Icon(Icons.keyboard_arrow_down_outlined),
                            onChanged: (value) {
                              dropdownSelectedValue.value = value!;
                            },
                            items: [
                              DropdownMenuItem<TimeOffType>(
                                value: TimeOffType.unpaid,
                                child: Text(TimeOffType.unpaid.name),
                                onTap: () {
                                  dropdownSelectedValue.value =
                                      TimeOffType.unpaid;
                                },
                              ),
                              DropdownMenuItem<TimeOffType>(
                                value: TimeOffType.paid,
                                child: Text(TimeOffType.paid.name),
                                onTap: () {
                                  dropdownSelectedValue.value =
                                      TimeOffType.paid;
                                },
                              ),
                              DropdownMenuItem<TimeOffType>(
                                value: TimeOffType.annual,
                                child: Text(TimeOffType.annual.name),
                                onTap: () {
                                  dropdownSelectedValue.value =
                                      TimeOffType.annual;
                                },
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Çıkış Tarihi',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final DateTime pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                              currentDate: startDateValue.value,
                            ) as DateTime;
                            startDateValue.value = pickedDate;
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                color: const Color(0xffD0D5DD),
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 44,
                              child: Text(startDateValue.value
                                  .toString()
                                  .split(' ')[0]),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Başlama Tarihi',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            final DateTime pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate:
                                  DateTime.now().add(const Duration(days: 365)),
                              currentDate: endDateValue.value,
                            ) as DateTime;
                            endDateValue.value = pickedDate;
                          },
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
                              border: Border.all(
                                color: const Color(0xffD0D5DD),
                              ),
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              height: 44,
                              child: Text(
                                endDateValue.value.toString().split(' ')[0],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            'Açıklama (opsiyonel)',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 14.0),
                            margin: const EdgeInsets.only(top: 8.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8)),
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
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    onPressed: () {
                      //TODO: convert this to the form validation
                      assert(startDateValue.value.isBefore(endDateValue.value));
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
    );
  }
}
