import 'package:aleedz/viewmodel/login_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loginViewModelProvider = ChangeNotifierProvider<LoginViewModel>((ref) {
  return LoginViewModel();
});
