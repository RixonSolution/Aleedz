import 'package:aleedz/viewmodel/check_in_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckInView extends ConsumerWidget {
  const CheckInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(checkInProvider);
    final viewModel = ref.read(checkInProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Check-In')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.isCheckedIn
                  ? 'Checked In at: ${state.checkInTime}'
                  : 'Not Checked In',
            ),
            ElevatedButton(
              onPressed: state.isCheckedIn ? null : viewModel.checkIn,
              child: const Text('Check In'),
            ),
            ElevatedButton(
              onPressed: !state.isCheckedIn ? null : viewModel.checkOut,
              child: const Text('Check Out'),
            ),
          ],
        ),
      ),
    );
  }
}
