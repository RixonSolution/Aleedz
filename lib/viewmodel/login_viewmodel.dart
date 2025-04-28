import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginState {
  final String email;
  final String password;
  final bool isLoading;

  LoginState({this.email = '', this.password = '', this.isLoading = false});

  LoginState copyWith({String? email, String? password, bool? isLoading}) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginViewModel extends StateNotifier<LoginState> {
  LoginViewModel() : super(LoginState());

  void updateEmail(String email) {
    state = state.copyWith(email: email);
  }

  void updatePassword(String password) {
    state = state.copyWith(password: password);
  }

  void toggleLoading(bool isLoading) {
    state = state.copyWith(isLoading: isLoading);
  }
}

final loginProvider = StateNotifierProvider<LoginViewModel, LoginState>(
  (ref) => LoginViewModel(),
);
