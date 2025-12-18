import 'dart:io';

import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/models/activity_category_Id_model.dart';
import 'package:aleedz/models/market_activity_list.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/issues_veiwmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class IssueSubmitView extends ConsumerStatefulWidget {
  final String checkInTime, storeName;
  final int storeId;

  const IssueSubmitView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<IssueSubmitView> createState() => _IssueSubmitViewState();
}

class _IssueSubmitViewState extends ConsumerState<IssueSubmitView> {
  ActivityCategoryModel? _selectedIssueCategory;
  bool _isSubmitting = false;
  final Map<int, int> _imagePageIndex = {};

  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController quantityController = TextEditingController(
    text: '1',
  );

  @override
  void initState() {
    super.initState();
    Future.microtask(_initialize);
  }

  Future<void> _initialize() async {
    final notifier = ref.read(issuesModelProvider.notifier);
    notifier.marketActivityList = [];
    notifier.loader = true;
    notifier.notifyListeners();
    await ref
        .read(issuesModelProvider.notifier)
        .getMarketActivityList(
          storeId: widget.storeId.toString(),
          activityCategoryId: '0',
          // activityCategoryId: categoryId,
          activityTypeId: '0',
          // activityTypeId: typeId,
          brandId: '2',
        );

    await notifier.loadActivity();
    _selectedIssueCategory =
        notifier.issueList.isNotEmpty ? notifier.issueList.first : null;

    if (_selectedIssueCategory != null) {
      await _refreshIssueList();
    } else {
      notifier.loader = false;
      notifier.notifyListeners();
    }
    if (mounted) setState(() {});
  }

  Future<void> _refreshIssueList() async {
    if (_selectedIssueCategory == null) return;
    final categoryId =
        (_selectedIssueCategory?.activityCategoryID ?? 0).toString();
    final typeId = (_selectedIssueCategory?.activityTypeID ?? 0).toString();

    await ref
        .read(issuesModelProvider.notifier)
        .getMarketActivityList(
          storeId: widget.storeId.toString(),
          activityCategoryId: categoryId,
          activityTypeId: typeId,
          brandId: '2',
        );
  }

  void _showSwipeHintSnack() {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.swipe_left, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Swipe left to delete the record',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1f2937),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<bool> _confirmDeleteDialog() async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          content: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LabelService().getLabel(100),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  LabelService().getLabel(99),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(LabelService().getLabel(94)),
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(LabelService().getLabel(95)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    return result ?? false;
  }

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      LabelService().getLabel(111),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.camera_alt, color: Colors.white),
                  title: Text(
                    LabelService().getLabel(112),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImage = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (pickedImage != null &&
                        ref
                                .read(issuesModelProvider.notifier)
                                .beforeActivityImages
                                .length <
                            4) {
                      ref
                          .read(issuesModelProvider.notifier)
                          .beforeActivityImages
                          .add(File(pickedImage.path));
                      ref.read(issuesModelProvider.notifier).notifyListeners();
                    }
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.photo_library, color: Colors.white),
                  title: Text(
                    LabelService().getLabel(113),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final pickedImages = await ImagePicker().pickMultiImage();
                    if (pickedImages.isNotEmpty) {
                      for (var image in pickedImages) {
                        if (ref
                                .read(issuesModelProvider.notifier)
                                .beforeActivityImages
                                .length >=
                            4) {
                          break;
                        }
                        ref
                            .read(issuesModelProvider.notifier)
                            .beforeActivityImages
                            .add(File(image.path));
                      }
                      ref.read(issuesModelProvider.notifier).notifyListeners();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<String> _imageUrls(MarketActivityList item) {
    final urls = <String>[];
    if (item.imageActivity != null && item.imageActivity!.isNotEmpty) {
      urls.add(item.imageActivity!);
    }
    if (item.imageActivity2 != null && item.imageActivity2!.isNotEmpty) {
      urls.add(item.imageActivity2!);
    }
    return urls;
  }

  String _initials(String? name) {
    if (name == null || name.trim().isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) {
      return parts.first.substring(0, 1).toUpperCase();
    }
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  InputDecoration _sheetInputDecoration(String hint, {Widget? prefix}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefix,
      filled: true,
      fillColor: const Color(0xFFF7F8FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.secondary),
      ),
    );
  }

  Widget _fieldLabel(String text, {bool required = true}) {
    return Row(
      children: [
        Text(
          text,
          style: const TextStyle(
            color: Color(0xFF111827),
            fontSize: 14,
            fontWeight: FontWeight.w800,
          ),
        ),
        if (required)
          const Text(
            ' *',
            style: TextStyle(
              color: Colors.red,
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
      ],
    );
  }

  void _openCreateIssueSheet(IssuesViewModel viewModel) {
    descriptionController.clear();
    quantityController.text = '1';
    viewModel.beforeActivityImages.clear();
    viewModel.notifyListeners();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AnimatedBuilder(
              animation: viewModel,
              builder: (context, _) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Create New Issue',
                                style: TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(ctx).pop(),
                                child: Container(
                                  height: 36,
                                  width: 36,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF2F3F5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.close,
                                    size: 18,
                                    color: Color(0xFF111827),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Divider(color: Colors.grey.shade300, height: 1),
                          const SizedBox(height: 16),

                          _fieldLabel('Issue'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value: _selectedIssueCategory?.activityCategoryID,
                            decoration: _sheetInputDecoration('Select Issue'),
                            items:
                                viewModel.issueList
                                    .map(
                                      (issue) => DropdownMenuItem<int>(
                                        value: issue.activityCategoryID,
                                        child: Text(
                                          issue.activityCategoryName ?? '',
                                        ),
                                      ),
                                    )
                                    .toList(),
                            onChanged: (value) {
                              if (value == null) return;
                              final selected = viewModel.issueList.firstWhere(
                                (i) => i.activityCategoryID == value,
                              );
                              setState(() {
                                _selectedIssueCategory = selected;
                              });
                              setModalState(() {});
                            },
                          ),
                          const SizedBox(height: 16),
                          _fieldLabel('Description'),
                          const SizedBox(height: 8),
                          TextField(
                            controller: descriptionController,
                            maxLines: 3,
                            minLines: 2,
                            decoration: _sheetInputDecoration(
                              LabelService().getLabel(118),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _fieldLabel('Quantity'),
                          const SizedBox(height: 8),
                          TextField(
                            keyboardType: TextInputType.number,
                            controller: quantityController,
                            maxLines: 1,
                            minLines: 1,
                            decoration: _sheetInputDecoration(
                              LabelService().getLabel(156),
                            ),
                          ),
                          const SizedBox(height: 16),
                          _fieldLabel('Photos'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (viewModel.beforeActivityImages.length <
                                      4) {
                                    _showImagePickerDialog();
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          LabelService().getLabel(114),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                  height: 80,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.camera_alt,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: SizedBox(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount:
                                        viewModel.beforeActivityImages.length,
                                    itemBuilder: (context, index) {
                                      final file =
                                          viewModel.beforeActivityImages[index];
                                      return Stack(
                                        children: [
                                          Container(
                                            margin: const EdgeInsets.only(
                                              right: 10,
                                            ),
                                            height: 70,
                                            width: 80,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              image: DecorationImage(
                                                image: FileImage(file),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: GestureDetector(
                                              onTap: () {
                                                viewModel.beforeActivityImages
                                                    .removeAt(index);
                                                viewModel.notifyListeners();
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: AppColors.secondary,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  4,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child:
                                _isSubmitting
                                    ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                    : ElevatedButton(
                                      onPressed: () async {
                                        if (_selectedIssueCategory == null) {
                                          AppSnackBar.showError(
                                            context,
                                            'Please select issue',
                                          );
                                          return;
                                        }
                                        if (descriptionController
                                            .text
                                            .isEmpty) {
                                          AppSnackBar.showError(
                                            context,
                                            LabelService().getLabel(157),
                                          );
                                          return;
                                        }
                                        if (quantityController.text.isEmpty) {
                                          AppSnackBar.showError(
                                            context,
                                            LabelService().getLabel(158),
                                          );
                                          return;
                                        }
                                        if (viewModel
                                            .beforeActivityImages
                                            .isEmpty) {
                                          AppSnackBar.showError(
                                            context,
                                            LabelService().getLabel(115),
                                          );
                                          return;
                                        }

                                        bool sheetClosed = false;
                                        setState(() {
                                          _isSubmitting = true;
                                        });
                                        setModalState(() {});
                                        try {
                                          await viewModel.marketActivityAdd(
                                            storeID: widget.storeId.toString(),
                                            activityTypeId:
                                                (_selectedIssueCategory
                                                            ?.activityTypeID ??
                                                        0)
                                                    .toString(),
                                            activityCategoryId:
                                                (_selectedIssueCategory
                                                            ?.activityCategoryID ??
                                                        0)
                                                    .toString(),
                                            brandId: '1',
                                            activityDescription:
                                                descriptionController.text,
                                            statusId: '1',
                                            quantity: quantityController.text,
                                            deployementReason: '1',
                                            beforeActivityPictures:
                                                viewModel.beforeActivityImages,
                                          );

                                          descriptionController.clear();
                                          quantityController.text = '1';
                                          viewModel.beforeActivityImages
                                              .clear();
                                          await _refreshIssueList();
                                          if (mounted) {
                                            sheetClosed = true;
                                            Navigator.of(ctx).pop();
                                          }
                                        } finally {
                                          if (mounted) {
                                            setState(() {
                                              _isSubmitting = false;
                                            });
                                            if (!sheetClosed) {
                                              setModalState(() {});
                                            }
                                          } else {
                                            _isSubmitting = false;
                                          }
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: const Text(
                                        'Create Issue',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                          ),
                          SizedBox(height: 40),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  void _openFilterSheet(IssuesViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AnimatedBuilder(
              animation: viewModel,
              builder: (context, _) {
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(ctx).viewInsets.bottom,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Filter Issues',
                              style: TextStyle(
                                color: Color(0xFF111827),
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            InkWell(
                              onTap: () => Navigator.of(ctx).pop(),
                              child: Container(
                                height: 36,
                                width: 36,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF2F3F5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Color(0xFF111827),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Divider(color: Colors.grey.shade300, height: 1),
                        const SizedBox(height: 16),
                        _fieldLabel('Issue'),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<int>(
                          value: _selectedIssueCategory?.activityCategoryID,
                          decoration: _sheetInputDecoration('Select Issue'),
                          items:
                              viewModel.issueList
                                  .map(
                                    (issue) => DropdownMenuItem<int>(
                                      value: issue.activityCategoryID,
                                      child: Text(
                                        issue.activityCategoryName ?? '',
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) async {
                            if (value == null) return;
                            final selected = viewModel.issueList.firstWhere(
                              (i) => i.activityCategoryID == value,
                            );
                            setState(() {
                              _selectedIssueCategory = selected;
                            });
                            setModalState(() {});
                            Navigator.of(ctx).pop();
                            await _refreshIssueList();
                          },
                        ),
                        SizedBox(
                          height: MediaQuery.of(ctx).padding.bottom + 24,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _createIssueButton(IssuesViewModel viewModel) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: GestureDetector(
            onTap: () async {
              if (viewModel.issueList.isEmpty) {
                await viewModel.getIssueList(
                  divisionId: '1',
                  categoryTypeId: '20',
                );
                if (_selectedIssueCategory == null &&
                    viewModel.issueList.isNotEmpty) {
                  setState(() {
                    _selectedIssueCategory = viewModel.issueList.first;
                  });
                }
              }
              _openCreateIssueSheet(viewModel);
            },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Create New Issue',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    descriptionController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(issuesModelProvider);
    final isListLoading =
        viewModel.loader && viewModel.marketActivityList.isEmpty;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          body: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 18,
                    ),
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1f2937), Color(0xFF0f172a)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () => NavigationService.goBack(),
                              child: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Issues',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                              onPressed: _showSwipeHintSnack,
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.storeName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.check,
                                    color: AppColors.primary,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    '${LabelService().getLabel(14)} ${widget.checkInTime}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                if (viewModel.issueList.isEmpty) {
                                  await viewModel.getIssueList(
                                    divisionId: '1',
                                    categoryTypeId: '0',
                                  );
                                }
                                _openFilterSheet(viewModel);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.filter_alt_outlined,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child:
                        isListLoading
                            ? const Center(child: CircularProgressIndicator())
                            : ListView.builder(
                              padding: const EdgeInsets.only(
                                bottom: 140,
                                top: 4,
                              ),
                              itemCount: viewModel.marketActivityList.length,
                              itemBuilder: (context, index) {
                                final item =
                                    viewModel.marketActivityList[index];
                                final itemKey = item.activityID ?? index;
                                final images = _imageUrls(item);
                                final statusLabel =
                                    (item.quantity?.isNotEmpty ?? false)
                                        ? 'Qty ${item.quantity}'
                                        : 'Open';

                                return Dismissible(
                                  key: ValueKey(
                                    'issue_${item.activityID ?? index}',
                                  ),
                                  direction: DismissDirection.endToStart,
                                  background: Container(
                                    alignment: Alignment.centerRight,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red.shade50,
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                      size: 28,
                                    ),
                                  ),
                                  confirmDismiss: (direction) async {
                                    if (direction !=
                                        DismissDirection.endToStart) {
                                      return false;
                                    }
                                    final shouldDelete =
                                        await _confirmDeleteDialog();
                                    if (!shouldDelete) return false;

                                    await viewModel.removeActivity(
                                      activityId: item.activityID.toString(),
                                      activityTypeId:
                                          item.activityTypeID.toString(),
                                    );
                                    await _refreshIssueList();
                                    return true;
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 8,
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(18),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Color(0x19000000),
                                            blurRadius: 18,
                                            offset: Offset(0, 8),
                                          ),
                                        ],
                                        border: const Border(
                                          left: BorderSide(
                                            color: AppColors.primary,
                                            width: 4,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        item.activityTypeName ??
                                                            '',
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xFF111827,
                                                          ),
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        item.activityCategoryName ??
                                                            '',
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xFF111827,
                                                          ),
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        '#${item.activityID ?? '-'} • ${item.storeName ?? widget.storeName}',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors
                                                                  .greyText,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Text(
                                                        '${item.activityDateTime ?? ''}',
                                                        style: TextStyle(
                                                          color:
                                                              AppColors
                                                                  .greyText,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 10,
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFFFF4EC,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    statusLabel,
                                                    style: const TextStyle(
                                                      color: Color(0xFFf97316),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            if (images.isNotEmpty) ...[
                                              const SizedBox(height: 14),
                                              SizedBox(
                                                height: 180,
                                                child: Stack(
                                                  children: [
                                                    PageView.builder(
                                                      controller: PageController(
                                                        initialPage:
                                                            _imagePageIndex[itemKey] ??
                                                            0,
                                                      ),
                                                      itemCount: images.length,
                                                      onPageChanged: (page) {
                                                        setState(() {
                                                          _imagePageIndex[itemKey] =
                                                              page;
                                                        });
                                                      },
                                                      itemBuilder: (
                                                        context,
                                                        imgIndex,
                                                      ) {
                                                        return ClipRRect(
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                          child: CachedNetworkImage(
                                                            imageUrl:
                                                                '${ApiConstants.baseUrl}/${images[imgIndex]}',
                                                            fit: BoxFit.cover,
                                                            placeholder:
                                                                (
                                                                  context,
                                                                  url,
                                                                ) => Shimmer.fromColors(
                                                                  baseColor:
                                                                      Colors
                                                                          .grey[300]!,
                                                                  highlightColor:
                                                                      Colors
                                                                          .grey[100]!,
                                                                  child: Container(
                                                                    color:
                                                                        Colors
                                                                            .white,
                                                                  ),
                                                                ),
                                                            errorWidget:
                                                                (
                                                                  context,
                                                                  url,
                                                                  error,
                                                                ) => const Icon(
                                                                  Icons.error,
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                    Positioned(
                                                      bottom: 8,
                                                      left: 0,
                                                      right: 0,
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: List.generate(images.length, (
                                                          dotIndex,
                                                        ) {
                                                          final isActive =
                                                              (_imagePageIndex[itemKey] ??
                                                                  0) ==
                                                              dotIndex;
                                                          return AnimatedContainer(
                                                            duration:
                                                                const Duration(
                                                                  milliseconds:
                                                                      200,
                                                                ),
                                                            margin:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal: 4,
                                                                ),
                                                            height: 8,
                                                            width:
                                                                isActive
                                                                    ? 16
                                                                    : 8,
                                                            decoration: BoxDecoration(
                                                              color:
                                                                  isActive
                                                                      ? AppColors
                                                                          .primary
                                                                      : Colors
                                                                          .white
                                                                          .withOpacity(
                                                                            0.7,
                                                                          ),
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    4,
                                                                  ),
                                                              boxShadow:
                                                                  isActive
                                                                      ? [
                                                                        BoxShadow(
                                                                          color: AppColors.primary.withOpacity(
                                                                            0.4,
                                                                          ),
                                                                          blurRadius:
                                                                              6,
                                                                          offset: const Offset(
                                                                            0,
                                                                            2,
                                                                          ),
                                                                        ),
                                                                      ]
                                                                      : [],
                                                            ),
                                                          );
                                                        }),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                            const SizedBox(height: 14),
                                            if ((item.activityDescription ?? '')
                                                .isNotEmpty)
                                              Text(
                                                item.activityDescription ?? '',
                                                style: const TextStyle(
                                                  color: Color(0xFF4B5563),
                                                  fontSize: 14,
                                                  height: 1.5,
                                                ),
                                              ),
                                            const SizedBox(height: 12),
                                            Divider(
                                              color: Colors.grey.shade300,
                                              height: 1,
                                            ),
                                            const SizedBox(height: 12),
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 18,
                                                  backgroundColor:
                                                      AppColors.primary,
                                                  child: Text(
                                                    _initials(
                                                      item.teamMemberName,
                                                    ),
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                Expanded(
                                                  child: Text(
                                                    item.teamMemberName ?? '',
                                                    style: const TextStyle(
                                                      color: Color(0xFF4B5563),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 6,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: const Color(
                                                      0xFFFFF4EC,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          14,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'Open',
                                                    style: TextStyle(
                                                      color: Color(0xFFf97316),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
              _createIssueButton(viewModel),
            ],
          ),
        ),
      ),
    );
  }
}
