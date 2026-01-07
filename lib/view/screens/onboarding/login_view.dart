import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_constants.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/choose_language/choose_language_view.dart';
import 'package:aleedz/view/screens/dashboard/dashboard_view.dart';
import 'package:aleedz/view/screens/onboarding/auth_helper.dart';
import 'package:aleedz/view/screens/onboarding/login_provider.dart';
import 'package:aleedz/view/screens/onboarding/signup_view.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:aleedz/core/constants/assets/app_images.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _loadLabels();
    _loadBaseUrl();
    checkFingerprintAvailability();

    super.initState();
  }

  Future<void> _loadLabels() async {
    await LabelService().loadLabels();

    setState(() {}); // Trigger a rebuild after labels are loaded
  }

  Future<void> _loadBaseUrl() async {
    await ApiConstants.initialize();
    final persisted = ApiConstants.persistedBaseUrl;
    if (persisted == null || persisted.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationService.resetTo(ChooseLanguageView());
      });
    }
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
        backgroundColor: Colors.grey.shade100,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Logo + tagline
                Column(
                  children: [
                    Image.asset(
                      AppImages.logo1,
                      height: 140,
                      width: 200,
                      fit: BoxFit.contain,
                    ),
                    Text(
                      AppConstants.retailMarketing,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Card
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 420),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 28,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              // Text(
                              //   LabelService().getLabel(1),
                              //   style: TextStyle(
                              //     color: AppColors.blackColor,
                              //     fontSize: 22,
                              //     fontWeight: FontWeight.w800,
                              //   ),
                              // ),
                              // const SizedBox(height: 8),
                              // Text(
                              //   LabelService().getLabel(2),
                              //   style: TextStyle(
                              //     color: AppColors.blackColor.withOpacity(0.75),
                              //     fontSize: 15,
                              //     fontWeight: FontWeight.w600,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        // const SizedBox(height: 26),
                        Text(
                          LabelService().getLabel(3),
                          // 'Username',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _StyledField(
                          controller: viewModel.usernameController,
                          focusNode: viewModel.usernameFocusNode,
                          hint: 'Enter username',
                          // hint: LabelService().getLabel(3),
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? LabelService().getLabel(3)
                                      : null,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          LabelService().getLabel(4),
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _StyledField(
                          controller: viewModel.passwordController,
                          focusNode: viewModel.passwordFocusNode,
                          hint: LabelService().getLabel(328),
                          // hint: LabelService().getLabel(4),
                          obscureText: !viewModel.isPasswordVisible,
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? LabelService().getLabel(4)
                                      : null,
                          suffix: IconButton(
                            icon: Icon(
                              viewModel.isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.blackColor.withOpacity(0.75),
                            ),
                            onPressed: () {
                              viewModel.isPasswordVisible =
                                  !viewModel.isPasswordVisible;
                              viewModel.notifyListeners();
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        viewModel.loader
                            ? Center(
                              child: LoadingAnimationWidget.discreteCircle(
                                color: AppColors.secondary,
                                size: 32,
                              ),
                            )
                            : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 15,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 8,
                                  shadowColor: AppColors.primary.withOpacity(
                                    0.3,
                                  ),
                                  backgroundColor: AppColors.primary,
                                ).copyWith(
                                  backgroundColor:
                                      MaterialStateProperty.resolveWith((
                                        states,
                                      ) {
                                        if (states.contains(
                                          MaterialState.pressed,
                                        )) {
                                          return AppColors.primary.withOpacity(
                                            0.9,
                                          );
                                        }
                                        return AppColors.primary;
                                      }),
                                ),
                                onPressed: () async {
                                  if (!(_formKey.currentState?.validate() ??
                                      false)) {
                                    return;
                                  }
                                  final success = await viewModel.onLogin(
                                    context,
                                  );

                                  if (!success) return;

                                  viewModel.loader = true;
                                  viewModel.notifyListeners();

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
                                                    LabelService().getLabel(94),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: Text(
                                                    LabelService().getLabel(95),
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

                                  viewModel.loader = false;
                                  viewModel.notifyListeners();

                                  NavigationService.navigateTo(DashboardView());
                                },
                                child: Text(
                                  LabelService().getLabel(5),
                                  style: TextStyle(
                                    color: AppColors.whiteColor,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),

                        const SizedBox(height: 16),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                LabelService().getLabel(6),
                                style: TextStyle(
                                  color: AppColors.blackColor.withOpacity(0.65),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  NavigationService.navigateTo(
                                    const SignupView(),
                                  );
                                },
                                child: Text(
                                  LabelService().getLabel(248),
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (showFingerprint)
                          Center(
                            child: InkWell(
                              borderRadius: BorderRadius.circular(50),
                              onTap: () async {
                                final authSuccess =
                                    await AuthHelper.authenticateWithBiometrics();
                                if (authSuccess) {
                                  final creds =
                                      await AuthHelper.getCredentials();
                                  viewModel.usernameController.text =
                                      creds['email'] ?? '';
                                  viewModel.passwordController.text =
                                      creds['password'] ?? '';
                                  final loginSucceeded = await viewModel
                                      .onLogin(context);
                                  if (loginSucceeded) {
                                    NavigationService.navigateTo(
                                      DashboardView(),
                                    );
                                  }
                                }
                              },
                              child: Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [
                                      Color(0xFFFFEDD5),
                                      Color(0xFFFFFBEB),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                ),
                                child: Icon(
                                  Icons.fingerprint,
                                  size: 40,
                                  color: Color(0xFFEA580C),
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(height: 14),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              NavigationService.resetTo(ChooseLanguageView());
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.settings),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (!isKeyboardOpen) ...[
                  // const SizedBox(height: 24),
                  // Container(
                  //   padding: const EdgeInsets.symmetric(horizontal: 25),
                  //   child: Image.network(
                  //     '${ApiConstants.baseUrl}/AppImages/Footer_info.png',
                  //   ),
                  // ),
                  const SizedBox(height: 12),
                  Text(
                    LabelService().getLabel(249),
                    style: TextStyle(
                      color: AppColors.blackColor.withOpacity(0.55),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StyledField extends StatelessWidget {
  const _StyledField({
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.validator,
    this.obscureText = false,
    this.suffix,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      validator: validator,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: AppColors.blackColor.withOpacity(0.45),
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 1.8),
        ),
      ),
    );
  }
}
