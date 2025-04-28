import 'package:flutter_riverpod/flutter_riverpod.dart';

class CheckInState {
  final bool isCheckedIn;
  final DateTime checkInTime;

  CheckInState({this.isCheckedIn = false, DateTime? checkInTime})
    : checkInTime = checkInTime ?? DateTime.now();

  CheckInState copyWith({bool? isCheckedIn, DateTime? checkInTime}) {
    return CheckInState(
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      checkInTime: checkInTime ?? this.checkInTime,
    );
  }
}

class CheckInViewModel extends StateNotifier<CheckInState> {
  CheckInViewModel() : super(CheckInState());

  void checkIn() {
    state = state.copyWith(isCheckedIn: true, checkInTime: DateTime.now());
  }

  void checkOut() {
    state = state.copyWith(isCheckedIn: false);
  }
}

final checkInProvider = StateNotifierProvider<CheckInViewModel, CheckInState>(
  (ref) => CheckInViewModel(),
);
