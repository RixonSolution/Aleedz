import 'package:flutter_riverpod/flutter_riverpod.dart';

class DashboardState {
  final String welcomeMessage;
  final int notificationCount;

  DashboardState({
    this.welcomeMessage = 'Welcome!',
    this.notificationCount = 0,
  });

  DashboardState copyWith({String? welcomeMessage, int? notificationCount}) {
    return DashboardState(
      welcomeMessage: welcomeMessage ?? this.welcomeMessage,
      notificationCount: notificationCount ?? this.notificationCount,
    );
  }
}

class DashboardViewModel extends StateNotifier<DashboardState> {
  DashboardViewModel() : super(DashboardState());

  void updateWelcomeMessage(String message) {
    state = state.copyWith(welcomeMessage: message);
  }

  void incrementNotification() {
    state = state.copyWith(notificationCount: state.notificationCount + 1);
  }
}

final dashboardProvider =
    StateNotifierProvider<DashboardViewModel, DashboardState>(
      (ref) => DashboardViewModel(),
    );
