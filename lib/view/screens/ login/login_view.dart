import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_constants.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/%20login/auth_helper.dart';
import 'package:aleedz/view/screens/%20login/login_provider.dart';
import 'package:aleedz/view/screens/choose_language/choose_language_view.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  @override
  void initState() {
    _loadLabels();
    checkFingerprintAvailability();

    super.initState();
  }

  Future<void> _loadLabels() async {
    await LabelService().loadLabels();

    setState(() {}); // Trigger a rebuild after labels are loaded
  }

  bool showFingerprint = false;

  void checkFingerprintAvailability() async {
    final creds = await AuthHelper.getCredentials();
    setState(() {
      showFingerprint = creds['email'] != null && creds['password'] != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginViewModelProvider);
    final storeViewModel = ref.watch(storeModelProvider);
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Stack(
          fit: StackFit.expand, // Makes image fill the screen

          children: [
            // Background Image
            Image.network(
              '${ApiConstants.baseUrl}/AppImages/background.png', // Replace with your image path
              fit: BoxFit.cover,
            ),

            Center(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Form(
                        key: viewModel.formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 60),
                            Container(
                              // color: Colors.red,
                              child: Image.network(
                                '${ApiConstants.baseUrl}/AppImages/Client_logo.png',
                                height: 150,
                                width: 200,
                              ),
                            ),
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  LabelService().getLabel(1),
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50),
                            Padding(
                              padding: const EdgeInsets.only(left: 25),
                              child: Text(
                                LabelService().getLabel(2),
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 25,
                              ),
                              child: TextFormField(
                                controller: viewModel.usernameController,
                                focusNode: viewModel.usernameFocusNode,
                                decoration: InputDecoration(
                                  hintText: LabelService().getLabel(3),

                                  hintStyle: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14,
                                  ),
                                ),
                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? LabelService().getLabel(3)
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
                                  hintText: LabelService().getLabel(4),

                                  hintStyle: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14,
                                  ),
                                ),

                                validator:
                                    (value) =>
                                        value == null || value.isEmpty
                                            ? LabelService().getLabel(4)
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
                                      final success = await viewModel.onLogin(
                                        context,
                                      );

                                      if (!success)
                                        return; // ❌ Stop here on invalid credentials

                                      await storeViewModel.getROSLabels();

                                      final enableFingerprint =
                                          await showDialog<bool>(
                                            context: context,
                                            builder:
                                                (context) => AlertDialog(
                                                  title: Text(
                                                    LabelService().getLabel(96),
                                                  ),
                                                  content: Text(
                                                    LabelService().getLabel(97),
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                            false,
                                                          ),
                                                      child: Text(
                                                        LabelService().getLabel(
                                                          94,
                                                        ),
                                                      ),
                                                    ),
                                                    TextButton(
                                                      onPressed:
                                                          () => Navigator.pop(
                                                            context,
                                                            true,
                                                          ),
                                                      child: Text(
                                                        LabelService().getLabel(
                                                          95,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                          );

                                      if (enableFingerprint == true) {
                                        await AuthHelper.saveCredentials(
                                          viewModel.usernameController.text,
                                          viewModel.passwordController.text,
                                        );
                                      }

                                      NavigationService.navigateTo(
                                        DashboardView(),
                                      );
                                    },

                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
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
                                          LabelService().getLabel(5),
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
                                LabelService().getLabel(6),
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),

                            if (showFingerprint)
                              IconButton(
                                icon: Icon(Icons.fingerprint, size: 40),
                                onPressed: () async {
                                  bool authSuccess =
                                      await AuthHelper.authenticateWithBiometrics();
                                  if (authSuccess) {
                                    final creds =
                                        await AuthHelper.getCredentials();
                                    viewModel.usernameController.text =
                                        creds['email'] ?? '';
                                    viewModel.passwordController.text =
                                        creds['password'] ?? '';
                                    await viewModel.onLogin(
                                      context,
                                    ); // auto-login
                                    NavigationService.navigateTo(
                                      DashboardView(),
                                    );
                                  }
                                },
                              ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                NavigationService.resetTo(ChooseLanguageView());
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Icon(Icons.settings),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  if (!isKeyboardOpen)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Image.network(
                        '${ApiConstants.baseUrl}/AppImages/Footer_info.png',
                        // height: 100,
                        // width: 200,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
