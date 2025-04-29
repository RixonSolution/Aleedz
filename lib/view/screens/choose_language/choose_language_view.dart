import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_constants.dart';
import 'package:aleedz/core/constants/assets/app_images.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/%20login/login_view.dart';
import 'package:aleedz/viewmodel/choose_language_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChooseLanguageView extends ConsumerWidget {
  ChooseLanguageView({super.key});

  String _selectedLanguage = 'English';

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chooseLanguageProvider);
    final viewModel = ref.read(chooseLanguageProvider.notifier);

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
                        child: Text(language),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  _selectedLanguage = newValue ?? '';
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
              child: InkWell(
                onTap: () {
                  NavigationService.navigateTo(LoginView());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  decoration: BoxDecoration(
                    color:
                        AppColors.secondary, // Background with secondary color
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
