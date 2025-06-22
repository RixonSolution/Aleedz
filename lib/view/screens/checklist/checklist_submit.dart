import 'dart:io';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/models/checklist_entry.dart';
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
  void _showImagePickerDialog(
    String direction, {
    required Function(String) onImageSelected,
  }) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.secondary,
          title: Text(
            'Pick an image',
            style: TextStyle(color: AppColors.whiteColor),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text(
                  'From Camera',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                onTap: () async {
                  final path = await ref
                      .read(checklistModelProvider.notifier)
                      .pickFromCamera(direction);
                  Navigator.pop(context);
                  if (path != null) onImageSelected(path);
                },
              ),
              ListTile(
                title: const Text(
                  'From Gallery',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                onTap: () async {
                  final path = await ref
                      .read(checklistModelProvider.notifier)
                      .pickFromGallery(direction);
                  Navigator.pop(context);
                  if (path != null) onImageSelected(path);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchCheckList();
    });
  }

  Future<void> loadUserAndFetchCheckList() async {
    final notifier = ref.read(checklistModelProvider.notifier);
    await notifier.getCheckSubmitList(
      storeId: widget.storeId.toString(),
      checkListCateId: widget.checklistTypeId.toString(),
      visitedId: widget.visiteId.toString(),
    );
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

  Future<void> submitChecklistEntries() async {
    final viewModel = ref.watch(checklistModelProvider);

    setState(() {
      loader = true;
    });

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
    setState(() {
      loader = false;
    });
    print("✅ All checklist entries submitted.");
  }

  Map<String, TextEditingController> descriptionControllers = {}; // ✅ Add here

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(checklistModelProvider);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          color: Colors.white,
          child: ElevatedButton(
            onPressed: () async {
              await submitChecklistEntries();
              NavigationService.goBack();

              // viewModel.checklistEntries = [];

              AppSnackBar.showSuccess(context, 'Checklist submitted}');

              // // Handle submit action here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child:
                loader
                    ? CircularProgressIndicator(color: AppColors.whiteColor)
                    : Text(
                      LabelService().getLabel(73),
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.whiteColor,
                      ),
                    ),
          ),
        ),
        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
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
                          const Text(
                            'Checklist',
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
                    const SizedBox(height: 5),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Divider(color: AppColors.primary, height: 0),
                    ),
                    const SizedBox(height: 5),
                    Center(
                      child: Text(
                        widget.storeName,
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        'Checked In ${widget.checkInTime}',
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Center(
                        child: Text(
                          widget.checklistName,
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),

                    ListView.builder(
                      itemCount: viewModel.checkListSubmitView.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      primary: true,
                      itemBuilder: (BuildContext context, int index) {
                        final descriptionController = TextEditingController(
                          text: getChecklistDescription(
                            viewModel.checkListSubmitView[index].checklistID
                                .toString(),
                          ),
                        );

                        return Column(
                          children: [
                            ProductCard(
                              storeId: widget.storeId,
                              visitId: widget.visiteId,
                              initialDescription: descriptionController.text,
                              index1: index + 1,

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
                                                .checkListStatus,
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
                                                .checkListStatus,
                                        index: index,
                                        storeId: widget.storeId,
                                        visiteId: widget.visiteId,
                                      )
                                      : viewModel
                                              .checkListSubmitView[index]
                                              .inputTypeID ==
                                          3
                                      ? DateBox(
                                        initialValue:
                                            viewModel
                                                .checkListSubmitView[index]
                                                .checkListStatus,
                                        index: index,
                                        storeId: widget.storeId,
                                        visiteId: widget.visiteId,
                                      )
                                      : TextBox(
                                        initialValue:
                                            viewModel
                                                .checkListSubmitView[index]
                                                .checkListStatus,
                                        index: index,
                                        storeId: widget.storeId,
                                        visiteId: widget.visiteId,
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
                                viewModel.checkListSubmitView[index].checklistID
                                    .toString(),
                              ),
                            ),

                            Divider(indent: 12, endIndent: 12),
                          ],
                        );
                      },
                    ),
                  ],
                ),
      ),
    );
  }
}

class ProductCard extends ConsumerStatefulWidget {
  final String title;
  final Widget optionWidget;
  final int index; // change from dynamic to int
  final int index1; // change from dynamic to int
  final int storeId;
  final int visitId;

  final String? imagePath;
  final Function()? onPickImage;
  final String? initialDescription;
  final VoidCallback? onRemoveImage;

  ProductCard({
    required this.title,
    required this.optionWidget,
    required this.index,
    required this.index1,

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
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${widget.index1}. ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: Text(
                  widget.title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              widget.optionWidget,
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,

                  onChanged: (value) {
                    print(
                      viewModel.checkListSubmitView[widget.index].checklistID,
                    );
                    print(
                      "Description: $value",
                    ); // or answers[index].answer = value;

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
                        // checkListStatus: value,
                        teamMemberID:
                            viewModel.user?.teamMemberID.toString() ?? '',
                        visitID: widget.visitId.toString(),
                        description: value,
                        // imagePath: '/new/path.jpg',
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    labelText: LabelService().getLabel(66),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 2,
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: widget.onPickImage,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child:
                      (widget.imagePath != null && widget.imagePath!.isNotEmpty)
                          ? Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(widget.imagePath!),
                                  fit: BoxFit.cover,
                                  width: 80,
                                  height: 80,
                                ),
                              ),
                              Positioned(
                                top: 4,
                                right: 4,
                                child: GestureDetector(
                                  onTap:
                                      widget
                                          .onRemoveImage, // <-- Add this callback
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.black54,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: EdgeInsets.all(4),
                                    child: Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                          : Icon(Icons.camera_alt),
                ),
              ),
            ],
          ),
        ],
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
  String selected = 'Yes';

  @override
  void initState() {
    super.initState();
    selected = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildOption('Yes', widget.index),
            SizedBox(width: 12),
            _buildOption('No', widget.index),
          ],
        ),
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10, top: 5),
              child: Text('Yes'),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 5),
              child: Text('No'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOption(String value, int index) {
    final viewModel = ref.watch(checklistModelProvider);

    bool isSelected = selected == value;
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
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isSelected ? Colors.black : Colors.grey[300],
        ),
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Icon(Icons.check, color: Colors.white, size: 20),
        ),
      ),
    );
  }
}

class QuantityBox extends ConsumerStatefulWidget {
  final String initialValue;
  final int index, storeId, visiteId;

  const QuantityBox({
    required this.initialValue,
    required this.index,
    required this.storeId,
    required this.visiteId,
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
      width: 80, // Set a fixed width similar to your design
      height: 36,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) {
          print(viewModel.checkListSubmitView[widget.index].checklistID);
          print("Quantity: $value"); // or answers[index].answer = value;

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
              // imagePath: '/new/path.jpg',
            ),
          );
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          hintText: LabelService().getLabel(63),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class TextBox extends ConsumerStatefulWidget {
  final String initialValue;
  final int index, storeId, visiteId;

  const TextBox({
    required this.initialValue,
    required this.index,
    required this.storeId,
    required this.visiteId,
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
      width: 80, // Set a fixed width similar to your design
      height: 36,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          print(viewModel.checkListSubmitView[widget.index].checklistID);
          print("Text value: $value"); // or update your JSON model here

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
              // imagePath: '/new/path.jpg',
            ),
          );
        },
        textAlign: TextAlign.center,
        maxLength: 10,
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          hintText: LabelService().getLabel(65),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: Colors.grey),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DateBox extends ConsumerStatefulWidget {
  final String initialValue;
  final int index, storeId, visiteId;
  const DateBox({
    Key? key,
    required this.initialValue,
    required this.index,
    required this.storeId,
    required this.visiteId,
  }) : super(key: key);
  @override
  _DateBoxState createState() => _DateBoxState();
}

class _DateBoxState extends ConsumerState<DateBox> {
  DateTime selectedDate = DateTime.now();

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
      });

      String formatted = DateFormat('dd-MM-yyyy').format(picked);

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

    if (widget.initialValue != null && widget.initialValue!.isNotEmpty) {
      try {
        selectedDate = DateTime.parse(widget.initialValue!);
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

    return GestureDetector(
      onTap: () => _selectDate(context, widget.index),
      child: Container(
        width: 80,
        padding: EdgeInsets.symmetric(horizontal: 2, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
        ),
        child: Center(
          child: Text(
            formattedDate,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
