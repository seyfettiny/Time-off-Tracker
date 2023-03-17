import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TimeOffRequestView extends HookConsumerWidget {
  const TimeOffRequestView({super.key});

  static const routeName = '/timeoffrequest';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Yeni İzin Talebi',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),
        ),
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
      body: const Center(
        child: Text(routeName),
      ),
    );
  }
}
