// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/app/enums/user_type.dart';

import 'package:timeofftracker/services/auth_service.dart';
import 'package:timeofftracker/ui/view/error_view.dart';
import 'package:timeofftracker/ui/view/login_view.dart';
import 'package:timeofftracker/ui/view/timeoff_request_view.dart';
import 'package:timeofftracker/ui/widgets/timeoff_request_section.dart';
import 'package:timeofftracker/ui/widgets/timeoff_request_tile.dart';
import 'package:timeofftracker/viewmodel/homeview_viewmodel.dart';

class HomeView extends ConsumerWidget {
  var user;

  static const routeName = '/homeView';

  HomeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: Image.asset(
          'assets/images/logo_icon.png',
          scale: 8,
        ),
        title: Image.asset(
          'assets/images/logo_pepteam.png',
          scale: 3,
        ),
        titleSpacing: -10,
        actions: [
          GestureDetector(
            onTap: () {
              ref.read(authServiceProvider).signOut().then((value) {
                context.go(LoginView.routeName);
              });
            },
            child: Image.asset(
              'assets/images/profile_picture.png',
              scale: 2,
            ),
          ),
        ],
      ),
      body: ref.watch(currentUserProvider).when(
        data: (data) {
          user = data;
          return user.userType == UserType.employee
              ? _buildforEmployee(context, ref)
              : _buildforManager(context, ref);
        },
        error: (error, stackTrace) {
          debugPrint(error.toString() + stackTrace.toString());
          return const ErrorView();
        },
        loading: () {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  List<Widget> _buildFilterSection(BuildContext context) {
    return [
      Container(
        padding: const EdgeInsets.only(top: 24.0),
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              'Bekleyen Talepler',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Stack(
              children: [
                SizedBox(
                  child: GestureDetector(
                    onTapDown: (details) {
                      final RenderBox referenceBox =
                          context.findRenderObject() as RenderBox;
                      final tapPosition =
                          referenceBox.globalToLocal(details.globalPosition);
                      final RenderObject? overlay =
                          Overlay.of(context).context.findRenderObject();
                      showMenu(
                        context: context,
                        position: RelativeRect.fromRect(
                          Rect.fromLTWH(
                            tapPosition.dx,
                            tapPosition.dy,
                            350,
                            30,
                          ),
                          Rect.fromLTWH(
                            0,
                            0,
                            overlay!.paintBounds.size.width,
                            overlay.paintBounds.size.height,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        items: [
                          PopupMenuItem(
                            padding: const EdgeInsets.all(0),
                            value: 'sortByRecent',
                            onTap: () {},
                            child: Container(
                              color: Theme.of(context).colorScheme.background,
                              width: 350,
                              height: kMinInteractiveDimension,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Sort by recent'),
                                  Icon(Icons.check)
                                ],
                              ),
                            ),
                          ),
                          const PopupMenuItem(
                            value: 'sortByOldest',
                            child: Text('Sort by oldest'),
                          ),
                          const PopupMenuItem(
                            value: 'sortByLeastLeaveDays',
                            child: Text('Sort by least leave days'),
                          ),
                          const PopupMenuItem(
                            value: 'sortByMostLeaveDays',
                            child: Text('Sort by most leave days'),
                          ),
                          PopupMenuItem(
                            value: 'showOnlyPending',
                            child: CheckboxListTile(
                              value: false,
                              onChanged: (value) {},
                              contentPadding: const EdgeInsets.all(0),
                              title: const SizedBox(
                                width: 350,
                                child: Text('Show only pending'),
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'completedRequests',
                            child: CheckboxListTile(
                              value: true,
                              onChanged: (value) {},
                              contentPadding: const EdgeInsets.all(0),
                              title: const SizedBox(
                                width: 350,
                                child: Text('Completed requests'),
                              ),
                            ),
                          ),
                          PopupMenuItem(
                            value: 'highPriorityFirst',
                            child: CheckboxListTile(
                              value: true,
                              onChanged: (value) {},
                              contentPadding: const EdgeInsets.all(0),
                              title: const SizedBox(
                                width: 350,
                                child: Text('High priority first'),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                    child: const Icon(Icons.filter_list_rounded),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      const SizedBox(
        height: 10,
      ),
    ];
  }

  Widget _buildforManager(BuildContext context, WidgetRef ref) {
    final timeOffRequestListAsyncValue =
        ref.watch(allTimeOffRequestListProvider);
    return timeOffRequestListAsyncValue.when(
      error: (error, stackTrace) {
        debugPrint(error.toString() + stackTrace.toString());
        return const ErrorView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      data: (data) {
        return RefreshIndicator(
          onRefresh: () {
            return Future.wait([
              ref.refresh(currentUserProvider.future),
              ref.refresh(allTimeOffRequestListProvider.future)
            ]);
          },
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                childAnimationBuilder: (widget) => SlideAnimation(
                  verticalOffset: 60,
                  duration: const Duration(milliseconds: 400),
                  delay: const Duration(milliseconds: 100),
                  child: FadeInAnimation(child: widget),
                ),
                children: [
                  TimeOffRequestSection(
                    user: user,
                    requestList: data,
                  ),
                  ..._buildFilterSection(context),
                  SizedBox(
                    height: data.length * 108,
                    child: ListView.builder(
                      itemCount: data.length,
                      physics: const ClampingScrollPhysics(),
                      itemBuilder: (context, index) {
                        data.sort(
                            (a, b) => b.requestedAt.compareTo(a.requestedAt));
                        return ref
                            .watch(userByIdProvider(data[index].userId))
                            .when(
                          data: (userItem) {
                            return TimeOffRequestTile(
                              timeoffRequest: data[index],
                              userItem: userItem,
                              currentUserType: user.userType,
                            );
                          },
                          error: ((error, stackTrace) {
                            debugPrint(
                                error.toString() + stackTrace.toString());
                            return const ErrorView();
                          }),
                          loading: () {
                            return const SizedBox(
                              height: 100,
                              child: Center(child: CircularProgressIndicator()),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )),
        );
      },
    );
  }

  Widget _buildforEmployee(BuildContext context, WidgetRef ref) {
    final timeOffRequestListAsyncValue =
        ref.watch(timeOffRequestListByCurrentUserProvider);
    return timeOffRequestListAsyncValue.when(
      error: (error, stackTrace) {
        debugPrint(error.toString() + stackTrace.toString());
        return const ErrorView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      data: (data) {
        return RefreshIndicator(
          onRefresh: () {
            return Future.wait([
              ref.refresh(currentUserProvider.future),
              ref.refresh(timeOffRequestListByCurrentUserProvider.future)
            ]);
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: AnimationConfiguration.toStaggeredList(
                  childAnimationBuilder: (widget) => SlideAnimation(
                    verticalOffset: 60,
                    duration: const Duration(milliseconds: 400),
                    delay: const Duration(milliseconds: 100),
                    child: FadeInAnimation(child: widget),
                  ),
                  children: [
                    TimeOffRequestSection(
                      requestList: data,
                      user: user,
                    ),
                    ..._buildFilterSection(context),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 16),
                      child: GestureDetector(
                        onTap: () {
                          context.push(TimeOffRequestView.routeName);
                        },
                        child: DottedBorder(
                          color: Theme.of(context).colorScheme.onSurface,
                          borderType: BorderType.RRect,
                          dashPattern: const [6, 4],
                          strokeWidth: 2,
                          radius: const Radius.circular(8),
                          child: SizedBox(
                            height: 44,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.add),
                                Text(
                                  'Yeni İzin Talebi',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: data.length * 108,
                      child: ListView.builder(
                        itemCount: data.length,
                        physics: const ClampingScrollPhysics(),
                        itemBuilder: (context, index) {
                          data.sort(
                              (a, b) => b.requestedAt.compareTo(a.requestedAt));
                          return TimeOffRequestTile(
                            timeoffRequest: data[index],
                            userItem: user,
                            currentUserType: user.userType,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
