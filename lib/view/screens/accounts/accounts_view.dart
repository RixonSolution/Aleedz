import 'package:aleedz/viewmodel/accounts_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsView extends ConsumerWidget {
  const AccountsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(accountsProvider);
    final viewModel = ref.read(accountsProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Account Status: ${state.accountStatus}'),
            Text('Balance: \$${state.balance}'),
            ElevatedButton(
              onPressed: () => viewModel.updateBalance(1000.0),
              child: const Text('Add Balance'),
            ),
            ElevatedButton(
              onPressed: () => viewModel.updateAccountStatus('Inactive'),
              child: const Text('Deactivate Account'),
            ),
          ],
        ),
      ),
    );
  }
}
