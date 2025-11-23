import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_constants.dart';
import 'package:aleedz/core/constants/assets/app_images.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/view/screens/%20login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseLanguageView extends ConsumerStatefulWidget {
  @override
  _ChooseLanguageViewState createState() => _ChooseLanguageViewState();
}

class _ChooseLanguageViewState extends ConsumerState<ChooseLanguageView> {
  late int selectedLanguageId;
  TextEditingController controller = TextEditingController();

  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

  @override
  void initState() {
    super.initState();
    selectedLanguageId = 1; // Default language ID
    _bootstrapStoredValues();
  }

  // Fetch the app labels using the language ID

  // Handle language selection change
  void _onLanguageChanged(int languageId) {
    setState(() {
      selectedLanguageId = languageId;
    });
  }

  Future<void> _bootstrapStoredValues() async {
    await ApiConstants.initialize();
    final savedUrl = ApiConstants.persistedBaseUrl;
    if (!mounted) return;
    if (savedUrl != null && savedUrl.isNotEmpty) {
      controller.text = savedUrl;
    }
  }

  Future<void> saveBaseUrl(String url) async {
    await ApiConstants.updateBaseUrl(url);
  }

  InputDecoration _inputDecoration({String? hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppColors.blackColor.withOpacity(0.45),
        fontSize: 14,
      ),
      suffixIcon: suffix,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.primary, width: 1.8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginViewModelProvider);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: bottomInset + 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Area (Logo and Text)
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
              SizedBox(height: 145),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Base URL',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: controller,
                      decoration: _inputDecoration(hint: 'Enter Base URL'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Language',
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _selectedLanguage,
                      decoration: _inputDecoration(),
                      items:
                          _languages.map((String language) {
                            return DropdownMenuItem<String>(
                              value: language,
                              child: Text(
                                language,
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                      onChanged: (String? newValue) {
                        _selectedLanguage = newValue ?? '';
                      },
                    ),
                  ],
                ),
              ),
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
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 8,
                          shadowColor: AppColors.primary.withOpacity(0.3),
                          backgroundColor: AppColors.primary,
                        ).copyWith(
                          backgroundColor: MaterialStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(MaterialState.pressed)) {
                              return AppColors.primary.withOpacity(0.9);
                            }
                            return AppColors.primary;
                          }),
                        ),
                        onPressed: () async {
                          String inputUrl = controller.text.trim();
                          if (inputUrl.isNotEmpty) {
                            await saveBaseUrl(inputUrl);
                            viewModel.chooseLanguage('1');

                            // Maybe navigate to your Home screen
                          } else {
                            AppSnackBar.showError(
                              context,
                              'Please enter the base URL.',
                            );
                          }
                        },
                        child: Text(
                          AppConstants.next,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(AppConstants.copyright)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
