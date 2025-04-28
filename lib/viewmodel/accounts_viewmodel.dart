import 'package:flutter_riverpod/flutter_riverpod.dart';

class AccountsState {
  final String accountStatus;
  final double balance;

  AccountsState({this.accountStatus = 'Active', this.balance = 0.0});

  AccountsState copyWith({String? accountStatus, double? balance}) {
    return AccountsState(
      accountStatus: accountStatus ?? this.accountStatus,
      balance: balance ?? this.balance,
    );
  }
}

class AccountsViewModel extends StateNotifier<AccountsState> {
  AccountsViewModel() : super(AccountsState());

  void updateAccountStatus(String status) {
    state = state.copyWith(accountStatus: status);
  }

  void updateBalance(double newBalance) {
    state = state.copyWith(balance: newBalance);
  }
}

final accountsProvider =
    StateNotifierProvider<AccountsViewModel, AccountsState>(
      (ref) => AccountsViewModel(),
    );
