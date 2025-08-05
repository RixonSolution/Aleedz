import 'package:aleedz/core/services/label_services.dart';
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
                  ? '${LabelService().getLabel(14)} at: ${state.checkInTime}'
                  : 'Not ${LabelService().getLabel(14)}',
            ),
            ElevatedButton(
              onPressed: state.isCheckedIn ? null : viewModel.checkIn,
              child: Text(LabelService().getLabel(14)),
            ),
            ElevatedButton(
              onPressed: !state.isCheckedIn ? null : viewModel.checkOut,
              child: Text(LabelService().getLabel(15)),
            ),
          ],
        ),
      ),
    );
  }
}
