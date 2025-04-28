import 'package:aleedz/viewmodel/alert_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertView extends ConsumerWidget {
  const AlertView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(alertProvider);
    final viewModel = ref.read(alertProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Alerts')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            state.hasNewAlert
                ? Text('New Alert: ${state.alertMessage}')
                : const Text('No New Alerts'),
            ElevatedButton(
              onPressed:
                  () => viewModel.showAlert('New system update available!'),
              child: const Text('Trigger Alert'),
            ),
            ElevatedButton(
              onPressed: viewModel.clearAlert,
              child: const Text('Clear Alert'),
            ),
          ],
        ),
      ),
    );
  }
}
