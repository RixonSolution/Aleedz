import 'dart:io';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/models/checklist_entry.dart';
import 'package:aleedz/models/checklist_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/checklist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChecklistSubmit extends ConsumerStatefulWidget {
  String checkInTime, storeName, checklistName;
  int storeId, visiteId, checklistTypeId;

  ChecklistSubmit({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.checklistName,
    required this.storeId,
    required this.visiteId,
    required this.checklistTypeId,
  }) : super(key: key);

  @override
  ConsumerState<ChecklistSubmit> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<ChecklistSubmit> {
  late int _currentChecklistTypeId;
  late String _currentChecklistName;

  void _showImagePickerDialog(
    String direction, {
    required Function(String) onImageSelected,
  }) {
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
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                  title: Text(
                    LabelService().getLabel(112),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final path = await ref
                        .read(checklistModelProvider.notifier)
                        .pickFromCamera(direction);
                    if (path != null) onImageSelected(path);
                  },
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.white),
                  ),
                  title: Text(
                    LabelService().getLabel(113),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () async {
                    Navigator.pop(context);
                    final path = await ref
                        .read(checklistModelProvider.notifier)
                        .pickFromGallery(direction);
                    if (path != null) onImageSelected(path);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _currentChecklistTypeId = widget.checklistTypeId;
    _currentChecklistName = widget.checklistName;
    Future.microtask(() {
      loadUserAndFetchCheckList();
    });
  }

  Future<void> loadUserAndFetchCheckList() async {
    final notifier = ref.read(checklistModelProvider.notifier);
    await notifier.loadUser();
    if (notifier.checkList.isEmpty) {
      await notifier.getCheckListType(storeId: widget.storeId.toString());
    }
    await notifier.getCheckSubmitList(
      storeId: widget.storeId.toString(),
      checkListCateId: _currentChecklistTypeId.toString(),
      visitedId: widget.visiteId.toString(),
    );
  }

  Future<void> _applyFilter(
    ChecklistModel item,
    checklistViewModel viewModel,
  ) async {
    Navigator.of(context).pop();
    setState(() {
      _currentChecklistTypeId =
          item.checklistCategoryID ?? _currentChecklistTypeId;
      _currentChecklistName = item.checklist ?? _currentChecklistName;
    });
    await viewModel.getCheckSubmitList(
      storeId: widget.storeId.toString(),
      checkListCateId: _currentChecklistTypeId.toString(),
      visitedId: widget.visiteId.toString(),
    );
  }

  void _openFilterSheet(checklistViewModel viewModel) async {
    if (viewModel.checkList.isEmpty) {
      await viewModel.getCheckListType(storeId: widget.storeId.toString());
    }

    List<ChecklistModel> localList = List.from(viewModel.checkList);
    final searchController = TextEditingController();

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
            void filter(String query) {
              final q = query.toLowerCase();
              setModalState(() {
                localList =
                    viewModel.checkList.where((item) {
                      final name = item.checklist?.toLowerCase() ?? '';
                      return name.contains(q);
                    }).toList();
              });
            }

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
                            'Filter Checklist',
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
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x19000000),
                              blurRadius: 12,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextField(
                            controller: searchController,
                            onChanged: filter,
                            style: const TextStyle(color: AppColors.blackColor),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: LabelService().getLabel(135),
                              hintStyle: const TextStyle(
                                color: AppColors.greyText,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 0,
                                minHeight: 0,
                              ),
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.search,
                                  size: 20,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      localList.isEmpty
                          ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 30),
                            child: Center(
                              child: Text(
                                LabelService().getLabel(134),
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          )
                          : ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: localList.length,
                            separatorBuilder:
                                (_, __) => Divider(color: Colors.grey.shade300),
                            itemBuilder: (context, index) {
                              final item = localList[index];
                              return InkWell(
                                onTap: () => _applyFilter(item, viewModel),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 24,
                                        child: Text(
                                          '${index + 1}.',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          item.checklist ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.blackColor,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right_rounded,
                                        color: AppColors.primary,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() => searchController.dispose());
  }

  String? getChecklistImagePath(String checklistId) {
    final viewModel = ref.watch(checklistModelProvider);

    final matchingEntries = viewModel.checklistEntries.where(
      (e) => e.checkListID == checklistId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.imagePath;
    }

    return null;
  }

  String? getChecklistDescription(String checklistId) {
    final viewModel = ref.watch(checklistModelProvider);

    final matchingEntries = viewModel.checklistEntries.where(
      (e) => e.checkListID == checklistId,
    );

    if (matchingEntries.isNotEmpty) {
      return matchingEntries.first.description;
    }

    return null;
  }

  bool loader = false;
  bool canSubmitChecklist() {
    final viewModel = ref.watch(checklistModelProvider);
    return viewModel.checklistEntries.any(
      (entry) => entry.checkListStatus != null,
    );
  }

  Future<void> submitChecklistEntries() async {
    final viewModel = ref.watch(checklistModelProvider);
    if (mounted) {
      setState(() {
        loader = true;
      });
    }

    for (int i = 0; i < viewModel.checklistEntries.length; i++) {
      final entry = viewModel.checklistEntries[i];

      print("Submitting entry ${i + 1}/${viewModel.checklistEntries.length}:");
      print(entry.toJson());

      await viewModel.checklistSubmit(
        token: entry.token,
        checklistAuditId: entry.checklistAuditID.toString(),
        checklistId: entry.checkListID.toString(),
        storeId: entry.storeID.toString(),
        checklistStatus: entry.checkListStatus.toString(),
        teamMemberId: entry.teamMemberID.toString(),
        visitId: entry.visitID.toString(),
        description: entry.description.toString(),

        checkInImgFile: entry.imagePath != null ? File(entry.imagePath!) : null,
      );

      // Check if the last response was successful before continuing
    }
    if (mounted) {
      setState(() {
        loader = false;
      });
    }
    print("✅ All checklist entries submitted.");
  }

  Map<String, TextEditingController> descriptionControllers = {}; // ✅ Add here

  Widget _buildSubmitButton(checklistViewModel viewModel) {
    if (!canSubmitChecklist() && !loader) {
      return const SizedBox.shrink();
    }
    final bool disabled = loader;
    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: GestureDetector(
            onTap:
                disabled
                    ? null
                    : () async {
                      await submitChecklistEntries();
                      if (!mounted) return;
                      NavigationService.goBack();
                      AppSnackBar.showSuccess(
                        context,
                        LabelService().getLabel(73),
                      );
                    },
            child: Container(
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x19000000),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child:
                    loader
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.2,
                            color: Colors.white,
                          ),
                        )
                        : Text(
                          LabelService().getLabel(73),
                          style: const TextStyle(
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
  Widget build(BuildContext context) {
    final viewModel = ref.watch(checklistModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Stack(
          children: [
            viewModel.loader
                ? const Center(child: CircularProgressIndicator())
                : Column(
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
                          colors: [Color(0xFF111827), Color(0xFF0B1120)],
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
                                'Checklist',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Spacer(),
                              InkWell(
                                onTap: () => _openFilterSheet(viewModel),
                                child: Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.08),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.filter_alt_outlined,
                                    size: 18,
                                    color: Colors.white,
                                  ),
                                ),
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
                          const SizedBox(height: 6),
                          Text(
                            _currentChecklistName,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
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
                                  Icons.access_time_filled,
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
                          const SizedBox(height: 4),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.checkListSubmitView.length,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        primary: true,
                        padding: const EdgeInsets.only(bottom: 120),
                        itemBuilder: (BuildContext context, int index) {
                          final descriptionController = TextEditingController(
                            text: getChecklistDescription(
                              viewModel.checkListSubmitView[index].checklistID
                                  .toString(),
                            ),
                          );
                          final inputType =
                              viewModel.checkListSubmitView[index].inputTypeID;
                          final String optionLabel =
                              inputType == 1
                                  ? 'Status'
                                  : inputType == 2
                                  ? 'Quantity'
                                  : inputType == 3
                                  ? 'Date'
                                  : 'Value';
                          final hasStatus =
                              (viewModel
                                      .checkListSubmitView[index]
                                      .checkListStatus
                                      ?.isNotEmpty ??
                                  false);
                          final hasDescription =
                              descriptionController.text.trim().isNotEmpty;
                          final hasImage =
                              (getChecklistImagePath(
                                        viewModel
                                            .checkListSubmitView[index]
                                            .checklistID
                                            .toString(),
                                      ) ??
                                      '')
                                  .isNotEmpty;
                          final isPrefilled =
                              hasStatus || hasDescription || hasImage;

                          return Column(
                            children: [
                              ProductCard(
                                storeId: widget.storeId,
                                visitId: widget.visiteId,
                                initialDescription: descriptionController.text,
                                optionLabel: optionLabel,
                                isPrefilled: isPrefilled,
                                title:
                                    viewModel
                                        .checkListSubmitView[index]
                                        .question ??
                                    '',
                                optionWidget:
                                    viewModel
                                                .checkListSubmitView[index]
                                                .inputTypeID ==
                                            1
                                        ? ToggleYesNo(
                                          initialValue:
                                              viewModel
                                                  .checkListSubmitView[index]
                                                  .checkListStatus ??
                                              '',
                                          index: index,
                                          storeId: widget.storeId,
                                          visiteId: widget.visiteId,
                                        )
                                        : viewModel
                                                .checkListSubmitView[index]
                                                .inputTypeID ==
                                            2
                                        ? QuantityBox(
                                          initialValue:
                                              viewModel
                                                  .checkListSubmitView[index]
                                                  .checkListStatus ??
                                              '',
                                          index: index,
                                          storeId: widget.storeId,
                                          visiteId: widget.visiteId,
                                          hint: optionLabel,
                                        )
                                        : viewModel
                                                .checkListSubmitView[index]
                                                .inputTypeID ==
                                            3
                                        ? DateBox(
                                          initialValue:
                                              viewModel
                                                  .checkListSubmitView[index]
                                                  .checkListStatus ??
                                              '',
                                          index: index,
                                          storeId: widget.storeId,
                                          visiteId: widget.visiteId,
                                          hint: optionLabel,
                                        )
                                        : TextBox(
                                          initialValue:
                                              viewModel
                                                  .checkListSubmitView[index]
                                                  .checkListStatus ??
                                              '',
                                          index: index,
                                          storeId: widget.storeId,
                                          visiteId: widget.visiteId,
                                          hint: optionLabel,
                                        ),
                                index: index,
                                onRemoveImage: () {
                                  setState(() {});
                                  viewModel.addOrUpdateChecklistEntry(
                                    ChecklistEntry(
                                      token: viewModel.user?.apiToken ?? '',
                                      checklistAuditID:
                                          viewModel
                                                      .checkListSubmitView[index]
                                                      .checklistAuditID ==
                                                  null
                                              ? '0'
                                              : viewModel
                                                  .checkListSubmitView[index]
                                                  .checklistAuditID,
                                      checkListID:
                                          viewModel
                                              .checkListSubmitView[index]
                                              .checklistID
                                              .toString(),
                                      storeID: widget.storeId.toString(),
                                      teamMemberID:
                                          viewModel.user?.teamMemberID
                                              .toString() ??
                                          '',
                                      visitID: widget.visiteId.toString(),
                                      imagePath: '',
                                    ),
                                  );
                                  viewModel.notifyListeners();
                                },
                                onPickImage: () {
                                  _showImagePickerDialog(
                                    'left',
                                    onImageSelected: (String path) {
                                      setState(() {
                                        print('selected image ${path}');
                                      });

                                      viewModel.addOrUpdateChecklistEntry(
                                        ChecklistEntry(
                                          token: viewModel.user?.apiToken ?? '',
                                          checklistAuditID:
                                              viewModel
                                                          .checkListSubmitView[index]
                                                          .checklistAuditID ==
                                                      null
                                                  ? '0'
                                                  : viewModel
                                                      .checkListSubmitView[index]
                                                      .checklistAuditID,
                                          checkListID:
                                              viewModel
                                                  .checkListSubmitView[index]
                                                  .checklistID
                                                  .toString(),
                                          storeID: widget.storeId.toString(),
                                          teamMemberID:
                                              viewModel.user?.teamMemberID
                                                  .toString() ??
                                              '',
                                          visitID: widget.visiteId.toString(),
                                          imagePath: path,
                                        ),
                                      );
                                    },
                                  );
                                },
                                imagePath: getChecklistImagePath(
                                  viewModel
                                      .checkListSubmitView[index]
                                      .checklistID
                                      .toString(),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
            _buildSubmitButton(viewModel),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends ConsumerStatefulWidget {
  final String title;
  final Widget optionWidget;
  final String optionLabel;
  final int index; // change from dynamic to int
  final int storeId;
  final int visitId;
  final bool isPrefilled;

  final String? imagePath;
  final Function()? onPickImage;
  final String? initialDescription;
  final VoidCallback? onRemoveImage;

  ProductCard({
    required this.title,
    required this.optionWidget,
    required this.optionLabel,
    required this.index,
    required this.isPrefilled,

    this.imagePath,
    this.onPickImage,
    this.initialDescription,
    this.onRemoveImage,
    required this.storeId,
    required this.visitId,

    Key? key,
  });

  @override
  ConsumerState<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends ConsumerState<ProductCard> {
  late final TextEditingController controller;
  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialDescription);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(checklistModelProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color:
              widget.isPrefilled
                  ? AppColors.primary.withOpacity(0.08)
                  : Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
          border: Border.all(
            color:
                widget.isPrefilled
                    ? AppColors.primary.withOpacity(0.35)
                    : Colors.transparent,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              left: 10,
              top: 12,
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  '${widget.index + 1}. ',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    color: Color(0xFF111827),
                    height: 1.2,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(0, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: Color(0xFF111827),
                              height: 1.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: controller,
                      onChanged: (value) {
                        viewModel.addOrUpdateChecklistEntry(
                          ChecklistEntry(
                            token: viewModel.user?.apiToken ?? '',
                            checklistAuditID:
                                viewModel
                                            .checkListSubmitView[widget.index]
                                            .checklistAuditID ==
                                        null
                                    ? '0'
                                    : viewModel
                                        .checkListSubmitView[widget.index]
                                        .checklistAuditID,
                            checkListID:
                                viewModel
                                    .checkListSubmitView[widget.index]
                                    .checklistID
                                    .toString(),
                            storeID: widget.storeId.toString(),
                            teamMemberID:
                                viewModel.user?.teamMemberID.toString() ?? '',
                            visitID: widget.visitId.toString(),
                            description: value,
                          ),
                        );
                      },
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: LabelService().getLabel(66),
                        hintStyle: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                        filled: true,
                        fillColor: const Color(0xFFF7F8FB),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1.2,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.4,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: widget.onPickImage,
                          child: Container(
                            height: 70,
                            width: 70,
                            decoration: BoxDecoration(
                              color: AppColors.lightGreyBackground,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1,
                              ),
                            ),
                            child:
                                (widget.imagePath != null &&
                                        widget.imagePath!.isNotEmpty)
                                    ? Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          child: Image.file(
                                            File(widget.imagePath!),
                                            fit: BoxFit.cover,
                                            width: 70,
                                            height: 70,
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: widget.onRemoveImage,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              padding: const EdgeInsets.all(4),
                                              child: const Icon(
                                                Icons.close,
                                                size: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                    : const Icon(
                                      Icons.camera_alt,
                                      color: Colors.black54,
                                      size: 28,
                                    ),
                          ),
                        ),
                        widget.optionWidget,
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ToggleYesNo extends ConsumerStatefulWidget {
  final String initialValue;
  final int index, storeId, visiteId;
  ToggleYesNo({
    required this.initialValue,
    required this.index,
    required this.storeId,
    required this.visiteId,
  }); // constructor

  @override
  _ToggleYesNoState createState() => _ToggleYesNoState();
}

class _ToggleYesNoState extends ConsumerState<ToggleYesNo> {
  String selected = LabelService().getLabel(95);

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildOption(LabelService().getLabel(95), widget.index),
        const SizedBox(width: 8),
        _buildOption(LabelService().getLabel(94), widget.index),
      ],
    );
  }

  Widget _buildOption(String value, int index) {
    final viewModel = ref.watch(checklistModelProvider);

    bool isSelected = selected == value;
    final bool isYes = value == LabelService().getLabel(95);
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = value;
        });

        print(viewModel.checkListSubmitView[index].checklistID);
        print("User selected: $value");

        viewModel.addOrUpdateChecklistEntry(
          ChecklistEntry(
            token: viewModel.user?.apiToken ?? '',
            checklistAuditID:
                viewModel.checkListSubmitView[index].checklistAuditID == null
                    ? '0'
                    : viewModel.checkListSubmitView[index].checklistAuditID,
            checkListID:
                viewModel.checkListSubmitView[index].checklistID.toString(),
            storeID: widget.storeId.toString(),
            checkListStatus: value,
            teamMemberID: viewModel.user?.teamMemberID.toString() ?? '',
            visitID: widget.visiteId.toString(),
            // imagePath: '/new/path.jpg',
          ),
        );
      },
      child: Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? (isYes ? const Color(0xFFE9F9F0) : const Color(0xFFFFE5E5))
                  : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color:
                isSelected
                    ? (isYes
                        ? const Color(0xFF16A34A)
                        : const Color(0xFFFF7A7A))
                    : const Color(0xFFCBD1DC),
            width: 1.6,
          ),
        ),
        child: Icon(
          isYes ? Icons.check : Icons.close,
          color:
              isSelected
                  ? (isYes ? const Color(0xFF16A34A) : const Color(0xFFD14343))
                  : const Color(0xFF94A3B8),
          size: 18,
        ),
      ),
    );
  }
}

class QuantityBox extends ConsumerStatefulWidget {
  final String initialValue;
  final int index, storeId, visiteId;
  final String? hint;

  const QuantityBox({
    required this.initialValue,
    required this.index,
    required this.storeId,
    required this.visiteId,
    this.hint,
  });

  @override
  ConsumerState<QuantityBox> createState() => _QuantityBoxState();
}

class _QuantityBoxState extends ConsumerState<QuantityBox> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(checklistModelProvider);

    return Container(
      width: 96,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD1DC)),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) {
          viewModel.addOrUpdateChecklistEntry(
            ChecklistEntry(
              token: viewModel.user?.apiToken ?? '',
              checklistAuditID:
                  viewModel
                              .checkListSubmitView[widget.index]
                              .checklistAuditID ==
                          null
                      ? '0'
                      : viewModel
                          .checkListSubmitView[widget.index]
                          .checklistAuditID,
              checkListID:
                  viewModel.checkListSubmitView[widget.index].checklistID
                      .toString(),
              storeID: widget.storeId.toString(),
              checkListStatus: value,
              teamMemberID: viewModel.user?.teamMemberID.toString() ?? '',
              visitID: widget.visiteId.toString(),
            ),
          );
        },
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          isDense: true,
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),
      ),
    );
  }
}

class TextBox extends ConsumerStatefulWidget {
  final String initialValue;
  final int index, storeId, visiteId;
  final String? hint;

  const TextBox({
    required this.initialValue,
    required this.index,
    required this.storeId,
    required this.visiteId,
    this.hint,
  });

  @override
  ConsumerState<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends ConsumerState<TextBox> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();
    controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(checklistModelProvider);

    return Container(
      width: 120,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFF7F8FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFCBD1DC)),
      ),
      alignment: Alignment.center,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          viewModel.addOrUpdateChecklistEntry(
            ChecklistEntry(
              token: viewModel.user?.apiToken ?? '',
              checklistAuditID:
                  viewModel
                              .checkListSubmitView[widget.index]
                              .checklistAuditID ==
                          null
                      ? '0'
                      : viewModel
                          .checkListSubmitView[widget.index]
                          .checklistAuditID,
              checkListID:
                  viewModel.checkListSubmitView[widget.index].checklistID
                      .toString(),
              storeID: widget.storeId.toString(),
              checkListStatus: value,
              teamMemberID: viewModel.user?.teamMemberID.toString() ?? '',
              visitID: widget.visiteId.toString(),
            ),
          );
        },
        textAlign: TextAlign.center,
        maxLength: 20,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          isDense: true,
          hintText: widget.hint ?? LabelService().getLabel(65),
          hintStyle: TextStyle(color: Colors.grey.shade500),
        ),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),
      ),
    );
  }
}

class DateBox extends ConsumerStatefulWidget {
  final String initialValue;
  final int index, storeId, visiteId;
  final String? hint;
  const DateBox({
    Key? key,
    required this.initialValue,
    required this.index,
    required this.storeId,
    required this.visiteId,
    this.hint,
  }) : super(key: key);
  @override
  _DateBoxState createState() => _DateBoxState();
}

class _DateBoxState extends ConsumerState<DateBox> {
  DateTime selectedDate = DateTime.now();
  bool hasValue = false;

  Future<void> _selectDate(BuildContext context, int index) async {
    final viewModel = ref.watch(checklistModelProvider);

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        hasValue = true;
      });

      print(viewModel.checkListSubmitView[index].checklistID);
      print("Selected date: $selectedDate"); // or update answers[index].answer

      viewModel.addOrUpdateChecklistEntry(
        ChecklistEntry(
          token: viewModel.user?.apiToken ?? '',
          checklistAuditID:
              viewModel.checkListSubmitView[index].checklistAuditID == null
                  ? '0'
                  : viewModel.checkListSubmitView[index].checklistAuditID,
          checkListID:
              viewModel.checkListSubmitView[index].checklistID.toString(),
          storeID: widget.storeId.toString(),
          checkListStatus: selectedDate.toString(),
          teamMemberID: viewModel.user?.teamMemberID.toString() ?? '',
          visitID: widget.visiteId.toString(),
          // imagePath: '/new/path.jpg',
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.initialValue.isNotEmpty) {
      try {
        selectedDate = DateTime.parse(widget.initialValue);
        hasValue = true;
      } catch (e) {
        print('Invalid date format in initialValue: ${widget.initialValue}');
        selectedDate = DateTime.now(); // fallback to today
      }
    } else {
      selectedDate = DateTime.now();
    }

    print("Initial selectedDate: $selectedDate");
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);
    final displayText = hasValue ? formattedDate : (widget.hint ?? 'Date');

    return GestureDetector(
      onTap: () => _selectDate(context, widget.index),
      child: Container(
        width: 120,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFCBD1DC)),
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF7F8FB),
        ),
        child: Center(
          child: Text(
            displayText,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: hasValue ? const Color(0xFF111827) : Colors.grey.shade500,
            ),
          ),
        ),
      ),
    );
  }
}
