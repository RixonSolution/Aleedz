import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_constants.dart';
import 'package:aleedz/core/constants/assets/app_images.dart';
import 'package:aleedz/core/constants/countries.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/choose_language/choose_language_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _contactFocusNode = FocusNode();
  final FocusNode _companyFocusNode = FocusNode();

  bool _isSubmitting = false;
  String? _selectedCountry;
  String? _completePhone;

  @override
  void initState() {
    _loadLabels();
    _loadBaseUrl();
    super.initState();
  }

  Future<void> _loadLabels() async {
    await LabelService().loadLabels();
    setState(() {});
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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _contactFocusNode.dispose();
    _companyFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                        Text(
                          'Name*',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _StyledField(
                          controller: _nameController,
                          focusNode: _nameFocusNode,
                          hint: 'Enter name',
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Name is required'
                                      : null,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Email*',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _StyledField(
                          controller: _emailController,
                          focusNode: _emailFocusNode,
                          hint: 'Enter email',
                          keyboardType: TextInputType.emailAddress,
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Email is required'
                                      : null,
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Country*',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        DropdownSearch<String>(
                          items: countries,
                          selectedItem: _selectedCountry,
                          onChanged: (value) {
                            setState(() {
                              _selectedCountry = value;
                            });
                          },
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? 'Country is required'
                                      : null,
                          dropdownBuilder: (context, selectedItem) {
                            return Text(
                              selectedItem ?? 'Select country',
                              style: TextStyle(
                                color:
                                    selectedItem == null
                                        ? AppColors.blackColor.withOpacity(0.45)
                                        : AppColors.blackColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              hintText: 'Select country',
                              hintStyle: TextStyle(
                                color: AppColors.blackColor.withOpacity(0.45),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 14,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: AppColors.primary,
                                  width: 1.8,
                                ),
                              ),
                            ),
                          ),
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            fit: FlexFit.loose,
                            searchFieldProps: TextFieldProps(
                              decoration: InputDecoration(
                                hintText: 'Search country',
                                hintStyle: TextStyle(
                                  color: AppColors.blackColor.withOpacity(0.45),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade300,
                                    width: 1.2,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                    color: AppColors.primary,
                                    width: 1.4,
                                  ),
                                ),
                              ),
                            ),
                            itemBuilder: (context, item, isSelected) {
                              return ListTile(
                                title: Text(
                                  item,
                                  style: TextStyle(
                                    color: AppColors.blackColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                          clearButtonProps: const ClearButtonProps(
                            isVisible: false,
                          ),
                          dropdownButtonProps: const DropdownButtonProps(
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                          ),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Contact Number',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        IntlPhoneField(
                          focusNode: _contactFocusNode,
                          initialCountryCode: 'US',
                          dropdownIcon: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Colors.black54,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Enter contact number',
                            hintStyle: TextStyle(
                              color: AppColors.blackColor.withOpacity(0.45),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: AppColors.primary,
                                width: 1.8,
                              ),
                            ),
                          ),
                          autovalidateMode: AutovalidateMode.disabled,
                          onChanged: (phone) {
                            _completePhone = phone.completeNumber;
                          },
                          validator: (phone) {
                            if (phone == null || phone.number.isEmpty) {
                              return 'Contact number is required';
                            }
                            if (phone.number.length < 6) {
                              return 'Enter a valid number';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'Company Name',
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _StyledField(
                          controller: _companyController,
                          focusNode: _companyFocusNode,
                          hint: 'Enter company name',
                        ),
                        const SizedBox(height: 24),
                        _isSubmitting
                            ? Center(
                              child: CircularProgressIndicator(
                                color: AppColors.secondary,
                                strokeWidth: 2,
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
                                  if (_completePhone == null ||
                                      _completePhone!.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please enter a valid contact number.',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  setState(() {
                                    _isSubmitting = true;
                                  });
                                  await Future.delayed(
                                    const Duration(milliseconds: 600),
                                  );
                                  if (!mounted) return;
                                  setState(() {
                                    _isSubmitting = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Sign-up submitted. Connect backend action here.',
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  'Sign Up',
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
                                'Already have an account?',
                                style: TextStyle(
                                  color: AppColors.blackColor.withOpacity(0.65),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              GestureDetector(
                                onTap: NavigationService.goBack,
                                child: Text(
                                  '  | Login ',
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
                      ],
                    ),
                  ),
                ),
                if (!isKeyboardOpen) ...[
                  const SizedBox(height: 12),
                  Text(
                    'Copyright 2025 @Aleedz Solutions',
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
    this.keyboardType,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final String? Function(String?)? validator;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText,
      validator: validator,
      keyboardType: keyboardType,
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
