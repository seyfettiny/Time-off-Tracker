// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timeofftracker/app/enums/user_type.dart';
import 'package:timeofftracker/app/extensions/toast_ext.dart';

import 'package:timeofftracker/services/auth_service.dart';
import 'package:timeofftracker/services/firestore_service.dart';
import 'package:timeofftracker/ui/view/error_view.dart';
import 'package:timeofftracker/ui/view/login_view.dart';
import 'package:timeofftracker/ui/view/timeoff_request_view.dart';
import 'package:timeofftracker/ui/widgets/timeoff_request_section.dart';
import 'package:timeofftracker/ui/widgets/timeoff_request_tile.dart';
import 'package:timeofftracker/viewmodel/homeview_viewmodel.dart';

class HomeView extends ConsumerWidget {
  const HomeView({super.key});

  static const routeName = '/homeView';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timeOffRequestListAsyncValue =
        ref.watch(timeOffRequestListByCurrentUserProvider);
    final currentUserAsyncValue = ref.watch(currentUserProvider);

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
      body: timeOffRequestListAsyncValue.when(
        skipError: true,
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
                      TimeOffRequestSection(data: data),

                      Container(
                        padding: const EdgeInsets.only(top: 24.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Bekleyen Talepler',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      
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
                      currentUserAsyncValue.when(
                          data: (user) {
                            return SizedBox(
                              height: data.length * 108,
                              child: ListView.builder(
                                itemCount: data.length,
                                physics: const ClampingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  data.sort((a, b) =>
                                      b.requestedAt.compareTo(a.requestedAt));
                                  return TimeOffRequestTile(
                                    timeoffRequest: data[index],
                                    user: user,
                                  );
                                },
                              ),
                            );
                          },
                          error: ((error, stackTrace) => const ErrorView()),
                          loading: () {
                            //TODO: Skeleton loading of items
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          })
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
