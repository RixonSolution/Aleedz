import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseLanguageState {
  final String selectedLanguage;
  final bool isLoading;

  ChooseLanguageState({this.selectedLanguage = '', this.isLoading = false});

  ChooseLanguageState copyWith({String? selectedLanguage, bool? isLoading}) {
    return ChooseLanguageState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChooseLanguageViewModel extends StateNotifier<ChooseLanguageState> {
  ChooseLanguageViewModel() : super(ChooseLanguageState());

  void selectLanguage(String language) {
    state = state.copyWith(selectedLanguage: language);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }
}

final chooseLanguageProvider =
    StateNotifierProvider<ChooseLanguageViewModel, ChooseLanguageState>(
      (ref) => ChooseLanguageViewModel(),
    );
