import 'dart:async';

import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_constants.dart';
import 'package:aleedz/core/constants/assets/app_images.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/view/screens/onboarding/login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ChooseLanguageView extends ConsumerStatefulWidget {
  @override
  _ChooseLanguageViewState createState() => _ChooseLanguageViewState();
}

class _ChooseLanguageViewState extends ConsumerState<ChooseLanguageView> {
  late int selectedLanguageId;
  TextEditingController controller = TextEditingController();

  String _selectedLanguage = 'English';
  bool _isSaving = false;

  final List<String> _languages = ['English', 'Spanish', 'French', 'German'];

  @override
  void initState() {
    super.initState();
    selectedLanguageId = 1; // Default language ID
    _bootstrapStoredValues();
  }

  // Fetch the app labels using the language ID

  // Handle language selection change
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

  String? _normalizeUrl(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final parsed = Uri.tryParse(trimmed);
    final hasValidScheme =
        parsed?.scheme == 'http' || parsed?.scheme == 'https';
    if (parsed == null || !hasValidScheme || parsed.host.isEmpty) return null;

    return trimmed.replaceFirst(RegExp(r'/+$'), '');
  }

  Future<bool> _probeBaseUrl(String baseUrl) async {
    final sanitized = baseUrl.replaceFirst(RegExp(r'/+$'), '');
    final uri = Uri.tryParse(
      '$sanitized/WebService.asmx/AppSettings?LanguageID=$selectedLanguageId',
    );
    if (uri == null) return false;

    try {
      final response = await http
          .get(uri, headers: {'Accept': 'application/json'})
          .timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } on TimeoutException {
      return false;
    } catch (_) {
      return false;
    }
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
                    const SizedBox(height: 8),
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
                      const SizedBox(height: 18),
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
                          setState(() {
                            _selectedLanguage = newValue ?? '';
                            final index = _languages.indexOf(_selectedLanguage);
                            selectedLanguageId = index >= 0 ? index + 1 : 1;
                          });
                        },
                      ),
                      const SizedBox(height: 24),
                      viewModel.loader || _isSaving
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
                                shadowColor: AppColors.primary.withOpacity(0.3),
                                backgroundColor: AppColors.primary,
                              ).copyWith(
                                backgroundColor:
                                    MaterialStateProperty.resolveWith((states) {
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
                                if (_isSaving) return;

                                final normalized = _normalizeUrl(
                                  controller.text,
                                );
                                if (normalized == null) {
                                  AppSnackBar.showError(
                                    context,
                                    'Enter a valid base URL (http/https).',
                                  );
                                  return;
                                }

                                setState(() => _isSaving = true);
                                try {
                                  final reachable = await _probeBaseUrl(
                                    normalized,
                                  );
                                  if (!reachable) {
                                    AppSnackBar.showError(
                                      context,
                                      'Cannot reach server at that URL. Please check and try again.',
                                    );
                                    return;
                                  }

                                  await saveBaseUrl(normalized);
                                  final success = await viewModel
                                      .chooseLanguage(
                                        selectedLanguageId.toString(),
                                      );

                                  if (!success) {
                                    AppSnackBar.showError(
                                      context,
                                      'Failed to load language data. Please try again.',
                                    );
                                  }
                                } catch (_) {
                                  AppSnackBar.showError(
                                    context,
                                    'Failed to save base URL. Please try again.',
                                  );
                                } finally {
                                  if (mounted) {
                                    setState(() => _isSaving = false);
                                  }
                                }
                              },
                              child: const Text(
                                AppConstants.next,
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
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

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
