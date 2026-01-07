import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_constants.dart';
import 'package:aleedz/core/constants/assets/app_images.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/services/region_service.dart';
import 'package:aleedz/core/services/signup_service.dart';
import 'package:aleedz/models/region_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/choose_language/choose_language_view.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

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
  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _contactFocusNode = FocusNode();
  final FocusNode _companyFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  final RegionService _regionService = RegionService();
  final SignupService _signupService = SignupService();

  bool _isSubmitting = false;
  bool _isRegionsLoading = false;
  String? _regionError;
  RegionModel? _selectedRegion;
  int? _selectedRegionId;
  List<RegionModel> _regions = [];
  String? _completePhone;
  bool _isPasswordVisible = false;
  static const String _apiToken =
      'eyJpdiI6IjUxSktCdEw2V2NoRzhXTGNCYk1nUGc9PSIsInZhbHVlIjoiTGZjTUdkZG1YcFJxZDBNT1VnUTJpNGJ0VWVJbmVEQXRPZHMvSHA3UzBXYlZsWVdSQlhiQnRlcFV1QXRVdWJvNCIsIm1hYyI6IjcwNWRjNzhlMWExZjQxZTI4MGZiYmY4ODE5M2ZhNWJjMDlmOTUwMDRjNjNlOWVkMjMyODdmZWMyODRhYTRlMTQiLCJ0YWciOiIifQ==';

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _isRegionsLoading = true;
      _regionError = null;
    });
    await _loadLabels();
    final hasBaseUrl = await _loadBaseUrl();
    if (!mounted || !hasBaseUrl) {
      if (mounted) {
        setState(() {
          _isRegionsLoading = false;
        });
      }
      return;
    }
    await _fetchRegions();
  }

  Future<void> _loadLabels() async {
    await LabelService().loadLabels();
    setState(() {});
  }

  Future<bool> _loadBaseUrl() async {
    await ApiConstants.initialize();
    final persisted = ApiConstants.persistedBaseUrl;
    if (persisted == null || persisted.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        NavigationService.resetTo(ChooseLanguageView());
      });
      return false;
    }
    return true;
  }

  Future<void> _fetchRegions() async {
    setState(() {
      _isRegionsLoading = true;
      _regionError = null;
    });

    try {
      final regions = await _regionService.fetchRegions(token: _apiToken);
      if (!mounted) return;
      setState(() {
        _regions = regions;
      });
    } catch (e) {
      debugPrint('Region load failed: $e');
      if (!mounted) return;
      setState(() {
        _regionError = 'Unable to load countries. Please try again.';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isRegionsLoading = false;
      });
    }
  }

  Widget _buildCountryDropdown() {
    final dropdown = DropdownSearch<RegionModel>(
      items: _regions,
      selectedItem: _selectedRegion,
      itemAsString: (region) => region.name,
      onChanged: (value) {
        setState(() {
          _selectedRegion = value;
          _selectedRegionId = value?.id;
        });
      },
      validator: (value) {
        if (_isRegionsLoading) {
          return LabelService().getLabel(315);
        }
        if (_regionError != null) {
          return LabelService().getLabel(314);
        }
        if (_regions.isEmpty) {
          return LabelService().getLabel(313);
        }
        if (value == null) {
          return LabelService().getLabel(312);
        }
        return null;
      },
      compareFn:
          (item, selectedItem) =>
              selectedItem != null && item.id == selectedItem.id,
      dropdownBuilder: (context, selectedItem) {
        final label =
            selectedItem?.name ??
            (_regions.isEmpty
                ? LabelService().getLabel(313)
                : LabelService().getLabel(316));
        return Text(
          label,
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
          hintText: LabelService().getLabel(316),
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
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.primary, width: 1.8),
          ),
        ),
      ),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        fit: FlexFit.loose,
        emptyBuilder:
            (context, _) => Center(child: Text(LabelService().getLabel(250))),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            hintText: LabelService().getLabel(317),
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
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary, width: 1.4),
            ),
          ),
        ),
        itemBuilder: (context, item, isSelected) {
          return ListTile(
            title: Text(
              item.name,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          );
        },
      ),
      clearButtonProps: const ClearButtonProps(isVisible: false),
      dropdownButtonProps: const DropdownButtonProps(
        icon: Icon(Icons.keyboard_arrow_down_rounded),
      ),
    );

    if (_isRegionsLoading) {
      return Stack(
        children: [
          AbsorbPointer(child: dropdown),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: SizedBox(
                  height: 22,
                  width: 22,
                  child: LoadingAnimationWidget.discreteCircle(
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (_regionError != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AbsorbPointer(child: dropdown),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red.shade400, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _regionError!,
                  style: TextStyle(
                    color: Colors.red.shade400,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  padding: EdgeInsets.zero,
                ),
                onPressed: _fetchRegions,
                icon: const Icon(Icons.refresh, size: 16),
                label: Text(LabelService().getLabel(251)),
              ),
            ],
          ),
        ],
      );
    }

    return dropdown;
  }

  Future<void> _handleSignUp() async {
    if (_isRegionsLoading) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LabelService().getLabel(252))),
      );
      return;
    }
    if (_regionError != null || _regions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LabelService().getLabel(253)),
        ),
      );
      return;
    }
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }
    if (_completePhone == null || _completePhone!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LabelService().getLabel(254))),
      );
      return;
    }
    final regionId = _selectedRegionId;
    if (regionId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(LabelService().getLabel(255))));
      return;
    }

    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final mobile = _completePhone!.trim();
    final password = _passwordController.text.trim();

    setState(() {
      _isSubmitting = true;
    });

    try {
      final response = await _signupService.signUp(
        name: name,
        email: email,
        mobile: mobile,
        regionId: regionId,
        password: password,
        token: _apiToken,
      );

      if (!mounted) return;

      final status = response['status'] as int?;
      final message =
          response['message']?.toString() ?? LabelService().getLabel(318);

      if (status == 200) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
        NavigationService.goBack();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              message.isNotEmpty
                  ? message
                  : LabelService().getLabel(319),
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Signup failed: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(LabelService().getLabel(256))),
      );
    } finally {
      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _companyController.dispose();
    _passwordController.dispose();
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _contactFocusNode.dispose();
    _companyFocusNode.dispose();
    _passwordFocusNode.dispose();
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
                        Text(LabelService().getLabel(257),
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
                          hint: LabelService().getLabel(320),
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? LabelService().getLabel(321)
                                      : null,
                        ),
                        const SizedBox(height: 18),
                        Text(LabelService().getLabel(258),
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
                          hint: LabelService().getLabel(322),
                          keyboardType: TextInputType.emailAddress,
                          validator:
                              (value) =>
                                  value == null || value.trim().isEmpty
                                      ? LabelService().getLabel(323)
                                      : null,
                        ),
                        const SizedBox(height: 18),
                        Text(LabelService().getLabel(259),
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _buildCountryDropdown(),
                        const SizedBox(height: 18),
                        Text(LabelService().getLabel(260),
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
                            hintText: LabelService().getLabel(324),
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
                              return LabelService().getLabel(325);
                            }
                            if (phone.number.length < 6) {
                              return LabelService().getLabel(326);
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 18),
                        Text(LabelService().getLabel(261),
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
                          hint: LabelService().getLabel(327),
                        ),
                        const SizedBox(height: 18),
                        Text(LabelService().getLabel(262),
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 10),
                        _StyledField(
                          controller: _passwordController,
                          focusNode: _passwordFocusNode,
                          hint: LabelService().getLabel(328),
                          obscureText: !_isPasswordVisible,
                          validator:
                              (value) =>
                                  value == null || value.isEmpty
                                      ? LabelService().getLabel(329)
                                      : value.length < 6
                                      ? LabelService().getLabel(330)
                                      : null,
                          suffix: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: AppColors.blackColor.withOpacity(0.75),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        _isSubmitting
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
                                onPressed: _handleSignUp,
                                child: Text(LabelService().getLabel(263),
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
                              Text(LabelService().getLabel(264),
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
