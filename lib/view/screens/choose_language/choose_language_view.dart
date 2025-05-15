import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_constants.dart';
import 'package:aleedz/core/constants/assets/app_images.dart';
import 'package:aleedz/view/screens/%20login/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseLanguageView extends ConsumerStatefulWidget {
  @override
  _ChooseLanguageViewState createState() => _ChooseLanguageViewState();
}

class _ChooseLanguageViewState extends ConsumerState<ChooseLanguageView> {
  late int selectedLanguageId;

  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

  @override
  void initState() {
    super.initState();
    selectedLanguageId = 1; // Default language ID
  }

  // Fetch the app labels using the language ID

  // Handle language selection change
  void _onLanguageChanged(int languageId) {
    setState(() {
      selectedLanguageId = languageId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(loginViewModelProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter Base URL',
                  hintStyle: TextStyle(
                    color: AppColors.blackColor,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25),
              child: DropdownButtonFormField<String>(
                value: _selectedLanguage,
                decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.secondary,
                    ), // Bottom border
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: AppColors.secondary,
                    ), // Focused bottom border
                  ),
                ),
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
            ),
            viewModel.loader
                ? CircularProgressIndicator(
                  color: AppColors.secondary,
                  strokeWidth: 2,
                )
                : Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
                  child: InkWell(
                    onTap: () {
                      viewModel.chooseLanguage('1');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        color:
                            AppColors
                                .secondary, // Background with secondary color
                        border: Border(
                          bottom: BorderSide(
                            color:
                                AppColors
                                    .primary, // Bottom border with primary color
                            width:
                                4.0, // Adjust the width to control the thickness of the line
                          ),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppConstants.next,
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

            // Spacer to push the copyright to the bottom
            Spacer(),

            // Bottom Area (Copyright)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(child: Text(AppConstants.copyright)),
            ),
          ],
        ),
      ),
    );
  }
}
