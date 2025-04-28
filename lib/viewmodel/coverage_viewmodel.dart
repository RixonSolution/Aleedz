import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoverageState {
  final double coverageArea;
  final bool isOnline;

  CoverageState({this.coverageArea = 0.0, this.isOnline = false});

  CoverageState copyWith({double? coverageArea, bool? isOnline}) {
    return CoverageState(
      coverageArea: coverageArea ?? this.coverageArea,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

class CoverageViewModel extends StateNotifier<CoverageState> {
  CoverageViewModel() : super(CoverageState());

  void updateCoverage(double area) {
    state = state.copyWith(coverageArea: area);
  }

  void toggleOnlineStatus() {
    state = state.copyWith(isOnline: !state.isOnline);
  }
}

final coverageProvider =
    StateNotifierProvider<CoverageViewModel, CoverageState>(
      (ref) => CoverageViewModel(),
    );
