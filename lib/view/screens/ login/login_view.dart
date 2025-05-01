import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_constants.dart';
import 'package:aleedz/core/constants/assets/app_images.dart';
import 'package:aleedz/view/screens/%20login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginViewModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 16),
            child: Form(
              key: viewModel.formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 60),
                  Image.asset(AppImages.logo1, height: 110, width: 200),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      AppConstants.retailMarketing,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          '@1 Title of company',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 25),
                    child: Text(
                      '@2 Login',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: viewModel.usernameController,
                      focusNode: viewModel.usernameFocusNode,
                      decoration: InputDecoration(
                        hintText: '@3 username',
                        hintStyle: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                        ),
                      ),
                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Username is required'
                                  : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: TextFormField(
                      controller: viewModel.passwordController,
                      focusNode: viewModel.passwordFocusNode,
                      obscureText: !viewModel.isPasswordVisible,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            viewModel.isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: AppColors.blackColor,
                          ),
                          onPressed: () {
                            viewModel.isPasswordVisible =
                                !viewModel.isPasswordVisible;
                            viewModel
                                .notifyListeners(); // Assuming you're using ChangeNotifier
                          },
                        ),
                        hintText: '@4 password',
                        hintStyle: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                        ),
                      ),

                      validator:
                          (value) =>
                              value == null || value.isEmpty
                                  ? 'Password is required'
                                  : null,
                    ),
                  ),

                  SizedBox(height: 20),
                  viewModel.loader
                      ? CircularProgressIndicator(
                        color: AppColors.secondary,
                        strokeWidth: 2,
                      )
                      : Padding(
                        padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          top: 20,
                        ),
                        child: InkWell(
                          onTap: () async {
                            await viewModel.onLogin(context);
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 15),
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                              border: Border(
                                bottom: BorderSide(
                                  color: AppColors.primary,
                                  width: 4.0,
                                ),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '@5 Login',
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                  SizedBox(height: 10),
                  Center(
                    child: Text(
                      '@6 Forgot Password ?',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(child: Text(AppConstants.copyright)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
