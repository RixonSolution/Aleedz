import 'package:flutter_riverpod/flutter_riverpod.dart';

class AlertState {
  final String alertMessage;
  final bool hasNewAlert;

  AlertState({this.alertMessage = '', this.hasNewAlert = false});

  AlertState copyWith({String? alertMessage, bool? hasNewAlert}) {
    return AlertState(
      alertMessage: alertMessage ?? this.alertMessage,
      hasNewAlert: hasNewAlert ?? this.hasNewAlert,
    );
  }
}

class AlertViewModel extends StateNotifier<AlertState> {
  AlertViewModel() : super(AlertState());

  void showAlert(String message) {
    state = state.copyWith(alertMessage: message, hasNewAlert: true);
  }

  void clearAlert() {
    state = state.copyWith(alertMessage: '', hasNewAlert: false);
  }
}

final alertProvider = StateNotifierProvider<AlertViewModel, AlertState>(
  (ref) => AlertViewModel(),
);
