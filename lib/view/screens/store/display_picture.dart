import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class DisplayPicture extends ConsumerStatefulWidget {
  String storeName, checkInTime;
  int storeId;
  DisplayPicture({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<DisplayPicture> createState() =>
      _DisplayAuditCheckSummaryState();
}

class _DisplayAuditCheckSummaryState extends ConsumerState<DisplayPicture> {
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

  Widget _fieldLabel(String text) {
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

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(storeModelProvider.notifier)
          .clearDisplayPicture(widget.storeId.toString());
      ref
          .read(storeModelProvider.notifier)
          .loadDisplayPicture(widget.storeId.toString(), '0', '1');
    });
  }

  FocusNode remarksFocus = FocusNode();

  TextEditingController remarksControll = TextEditingController();

  bool deleteLoader = false;

  Future<bool> _showDeleteDialog(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF111827), Color(0xFF0B1120)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Confirm Delete',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Delete this display picture record?',
                  style: TextStyle(
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
                        foregroundColor: AppColors.whiteColor,
                      ),
                      onPressed: () => Navigator.of(context).pop(false),
                      child: Text(LabelService().getLabel(94)), // Cancel
                    ),
                    TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.redAccent,
                      ),
                      onPressed: () => Navigator.of(context).pop(true),
                      child: Text(LabelService().getLabel(95)), // Delete/Yes
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

  void _showImagePickerDialog(String directiion) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondary,
          title: Text(
            LabelService().getLabel(111),
            style: TextStyle(color: AppColors.whiteColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  LabelService().getLabel(112),
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                onTap: () {
                  ref
                      .read(storeModelProvider.notifier)
                      .pickFromCamera(directiion);

                  Navigator.pop(context);
                  // if (source == 'camera') {
                  // } else {
                  //   ref.read(storeModelProvider.notifier).pickFromGallery();
                  // }
                },
              ),
              ListTile(
                title: Text(
                  LabelService().getLabel(113),
                  style: TextStyle(color: AppColors.whiteColor),
                ),

                onTap: () {
                  ref
                      .read(storeModelProvider.notifier)
                      .pickFromGallery(directiion);

                  Navigator.pop(context);

                  // if (source == 'camera') {
                  //   ref.read(storeModelProvider.notifier).pickFromCamera();
                  // } else {
                  // }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,
    String pictureId,
    String pictureName,
    void Function()? onPressed,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF111827), Color(0xFF0B1120)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  LabelService().getLabel(100),
                  style: TextStyle(color: AppColors.whiteColor, fontSize: 16, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Text(
                  LabelService().getLabel(99),
                  style: TextStyle(color: AppColors.whiteColor, fontSize: 15, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(), // Close dialog
                      child: Text(
                        LabelService().getLabel(94),
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                    ),
                    TextButton(
                      onPressed: onPressed,
                      child: Text(
                        LabelService().getLabel(95),
                        style: TextStyle(color: AppColors.whiteColor),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openAddDisplaySheet(StoreViewModel viewModel) {
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
                                'Add Display Picture',
                                style: TextStyle(
                                  color: Color(0xFF111827),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              InkWell(
                                onTap: () => Navigator.of(context).pop(),
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

                          _fieldLabel('Brand'),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value: viewModel.selectedBrand?.brandId,
                            decoration: _sheetInputDecoration('Select Brand'),
                            items:
                                viewModel.brandList
                                    .map(
                                      (brand) => DropdownMenuItem<int>(
                                        value: brand.brandId,
                                        child: Text(brand.brandName),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                (viewModel.brandList.isEmpty)
                                    ? null
                                    : (int? brandId) async {
                                      if (brandId == null) return;
                                      final selected = viewModel.brandList
                                          .firstWhere(
                                            (c) => c.brandId == brandId,
                                          );
                                      await viewModel.selectBrand(
                                        widget.storeId,
                                        selected,
                                      );
                                      setModalState(() {});
                                    },
                          ),

                          const SizedBox(height: 16),
                          _fieldLabel(LabelService().getLabel(132)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value:
                                viewModel
                                    .selectedPictureModel
                                    ?.pictureElementId,
                            decoration: _sheetInputDecoration(
                              LabelService().getLabel(132),
                            ),
                            items:
                                viewModel.pictureList
                                    .map(
                                      (picture) => DropdownMenuItem<int>(
                                        value: picture.pictureElementId,
                                        child: Text(picture.pictureElementName),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                viewModel.pictureList.isEmpty
                                    ? null
                                    : (int? picId) async {
                                      if (picId == null) return;
                                      final selected = viewModel.pictureList
                                          .firstWhere(
                                            (c) => c.pictureElementId == picId,
                                          );
                                      await viewModel.selectPictureDrop(
                                        selected,
                                        context,
                                      );
                                      setModalState(() {});
                                    },
                          ),

                          const SizedBox(height: 16),
                          _fieldLabel(LabelService().getLabel(194)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<int>(
                            value: viewModel.selectedIssueCategory?.categoryId,
                            decoration: _sheetInputDecoration(
                              LabelService().getLabel(194),
                            ),
                            items:
                                viewModel.categoryIssue
                                    .map(
                                      (category) => DropdownMenuItem<int>(
                                        value: category.categoryId,
                                        child: Text(category.categoryName),
                                      ),
                                    )
                                    .toList(),
                            onChanged:
                                viewModel.categoryIssue.isEmpty
                                    ? null
                                    : (int? cateId) async {
                                      if (cateId == null) return;
                                      final selected = viewModel.categoryIssue
                                          .firstWhere(
                                            (c) => c.categoryId == cateId,
                                          );
                                      await viewModel.selectCategoryIssue(
                                        widget.storeId,
                                        selected,
                                      );
                                      setModalState(() {});
                                    },
                          ),

                          const SizedBox(height: 16),
                          _fieldLabel('Remarks'),
                          const SizedBox(height: 8),
                          TextField(
                            focusNode: remarksFocus,
                            controller: remarksControll,
                            maxLines: 3,
                            minLines: 2,
                            decoration: _sheetInputDecoration('Remarks'),
                          ),

                          const SizedBox(height: 16),
                          _fieldLabel('Upload Photo'),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () {
                              _showImagePickerDialog('left');
                            },
                            child: Container(
                              height: 140,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF7F8FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade300),
                              ),
                              child:
                                  viewModel.leftImage != null
                                      ? Stack(
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                            child: Image.file(
                                              viewModel.leftImage!,
                                              fit: BoxFit.cover,
                                              height: double.infinity,
                                              width: double.infinity,
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            right: 8,
                                            child: GestureDetector(
                                              onTap: () {
                                                viewModel.leftImage = null;
                                                viewModel.notifyListeners();
                                                setModalState(() {});
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: AppColors.secondary,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 18,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                      : const Center(
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey,
                                          size: 32,
                                        ),
                                      ),
                            ),
                          ),

                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            height: 54,
                            child:
                                viewModel.loader
                                    ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                    : InkWell(
                                      onTap: () async {
                                        if (viewModel.selectedBrand == null) {
                                          AppSnackBar.showError(
                                            context,
                                            'Please select brand',
                                          );
                                        } else if (viewModel
                                                .selectedPictureModel ==
                                            null) {
                                          AppSnackBar.showError(
                                            context,
                                            LabelService().getLabel(132),
                                          );
                                        } else if (viewModel
                                                .selectedIssueCategory ==
                                            null) {
                                          AppSnackBar.showError(
                                            context,
                                            LabelService().getLabel(128),
                                          );
                                        } else if (remarksControll
                                            .text
                                            .isEmpty) {
                                          AppSnackBar.showError(
                                            context,
                                            LabelService().getLabel(129),
                                          );
                                        } else if (viewModel.leftImage ==
                                            null) {
                                          AppSnackBar.showError(
                                            context,
                                            LabelService().getLabel(116),
                                          );
                                        } else {
                                          FocusScope.of(context).unfocus();

                                          await viewModel.submitDisplayPicture(
                                            issueCategoryId:
                                                viewModel
                                                    .selectedIssueCategory!
                                                    .categoryId
                                                    .toString(),
                                            storeId: widget.storeId.toString(),
                                            pictureElementId:
                                                viewModel
                                                    .selectedPictureModel!
                                                    .pictureElementId
                                                    .toString(),
                                            remarks: remarksControll.text,
                                            pictureId: '0',
                                            elementImg: viewModel.leftImage!,
                                            brandId:
                                                viewModel.selectedBrand!.brandId
                                                    .toString(),
                                          );
                                          remarksControll.clear();
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Submit',
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
                          const SizedBox(height: 8),
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

  Widget _addDisplayButton(StoreViewModel viewModel) {
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: GestureDetector(
            onTap: () => _openAddDisplaySheet(viewModel),
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text(
                  'Add Display Picture',
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
        backgroundColor: AppColors.secondary,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Removes focus from any text field
      },
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
                            Text(
                              LabelService().getLabel(131),
                              style: const TextStyle(
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
                              Icon(
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
                      ],
                    ),
                  ),

                  Expanded(
                    child: ListView(
                      children: [
                        const SizedBox(height: 10),
                        ListView.builder(
                          itemCount: viewModel.viewPicture.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final picture = viewModel.viewPicture[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              child: Dismissible(
                                key: ValueKey(
                                  picture.pictureID ??
                                      '${picture.pictureName}_$index',
                                ),
                                direction: DismissDirection.endToStart,
                                confirmDismiss: (direction) async {
                                  if (direction !=
                                      DismissDirection.endToStart) {
                                    return false;
                                  }

                                  final shouldDelete = await _showDeleteDialog(
                                    context,
                                  );
                                  if (!shouldDelete) return false;

                                  viewModel.loader = true;
                                  viewModel.notifyListeners();

                                  await ref
                                      .read(storeModelProvider.notifier)
                                      .deleteDisplayPicture(
                                        storeId: widget.storeId.toString(),
                                        pictureId: picture.pictureID.toString(),
                                        pictureName:
                                            picture.pictureName.toString(),
                                      );
                                  viewModel.loader = false;
                                  viewModel.notifyListeners();
                                  return true;
                                },
                                background: Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  child: const Icon(
                                    Icons.swipe_left,
                                    color: Colors.grey,
                                    size: 24,
                                  ),
                                ),
                                secondaryBackground: Container(
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
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color(0x19000000),
                                        blurRadius: 14,
                                        offset: Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: IntrinsicHeight(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          width: 35,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              colors: [
                                                Color.fromARGB(255, 29, 43, 74),
                                                Color.fromARGB(255, 29, 43, 74),
                                              ],
                                              begin: Alignment.topLeft,
                                              end: Alignment.bottomRight,
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                                  topLeft: Radius.circular(18),
                                                  bottomLeft: Radius.circular(
                                                    18,
                                                  ),
                                                ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '${index + 1}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.all(14),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        picture.brandName ?? '',
                                                        style: const TextStyle(
                                                          color: Color(
                                                            0xFF111827,
                                                          ),
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.w800,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        picture.storePictureElementName ??
                                                            '',
                                                        style: TextStyle(
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        picture.categoryIssueName ??
                                                            '',
                                                        style: TextStyle(
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        picture.remarks ?? '',
                                                        style: TextStyle(
                                                          color:
                                                              Colors
                                                                  .grey
                                                                  .shade600,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Container(
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              horizontal: 10,
                                                              vertical: 6,
                                                            ),
                                                        decoration: BoxDecoration(
                                                          color: AppColors
                                                              .secondary
                                                              .withOpacity(
                                                                0.08,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                12,
                                                              ),
                                                        ),
                                                        child: Text(
                                                          picture.creationDateTime ??
                                                              '',
                                                          style:
                                                              const TextStyle(
                                                                color: Color(
                                                                  0xFF111827,
                                                                ),
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                              ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        '${ApiConstants.baseUrl}${picture.column1 ?? ''}',
                                                    height: 100,
                                                    width: 90,
                                                    placeholder:
                                                        (
                                                          context,
                                                          url,
                                                        ) => Shimmer.fromColors(
                                                          baseColor:
                                                              Colors.grey[300]!,
                                                          highlightColor:
                                                              Colors.grey[100]!,
                                                          child: Container(
                                                            height: 100,
                                                            width: 90,
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            const Icon(
                                                              Icons.error,
                                                            ),
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ],
              ),
              _addDisplayButton(viewModel),
            ],
          ),
        ),
      ),
    );
  }
}
