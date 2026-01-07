import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:aleedz/core/services/label_services.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleChangePassword() {
    if (_formKey.currentState?.validate() ?? false) {
      // Perform password change logic here
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(LabelService().getLabel(210))));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,

        body: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        NavigationService.goBack();
                      },
                      child: Image.asset(
                        AppIcons.backArrow,
                        height: 30,
                        width: 30,
                      ),
                    ),
                    Text(
                      LabelService().getLabel(211),
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Image.asset(
                      AppIcons.locationIcon,
                      height: 30,
                      width: 30,
                      color: AppColors.whiteColor,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Divider(color: AppColors.primary, height: 0),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 60),
                    TextFormField(
                      controller: _currentPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: LabelService().getLabel(338),
                        border: OutlineInputBorder(),
                      ),
                      validator:
                          (value) =>
                              (value == null || value.isEmpty)
                                  ? LabelService().getLabel(339)
                                  : null,
                    ),
                    const SizedBox(height: 12),

                    // New Password Field
                    TextFormField(
                      controller: _newPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: LabelService().getLabel(340),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LabelService().getLabel(341);
                        }
                        if (value.length < 6) {
                          return LabelService().getLabel(330);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    // Confirm Password Field
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: LabelService().getLabel(342),
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return LabelService().getLabel(343);
                        }
                        if (value != _newPasswordController.text) {
                          return LabelService().getLabel(344);
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    ElevatedButton(
                      onPressed: _handleChangePassword,
                      child: Text(LabelService().getLabel(211)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors
                                .secondary, // Change this to your desired color
                        foregroundColor: Colors.white, // Text color
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
