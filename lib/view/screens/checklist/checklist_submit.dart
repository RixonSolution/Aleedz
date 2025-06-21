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
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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

                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.checkListSubmitView.length,
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        primary: true,
                        itemBuilder: (BuildContext context, int index) {
                          return Column(
                            children: [
                              ProductCard(
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
                                          onChanged: (value) {
                                            print(
                                              viewModel
                                                  .checkListSubmitView[index]
                                                  .checklistID,
                                            );
                                            print("User selected: $value");

                                            viewModel.addOrUpdateChecklistEntry(
                                              ChecklistEntry(
                                                token:
                                                    viewModel.user?.apiToken ??
                                                    '',
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
                                                storeID:
                                                    widget.storeId.toString(),
                                                checkListStatus: value,
                                                teamMemberID:
                                                    viewModel.user?.teamMemberID
                                                        .toString() ??
                                                    '',
                                                visitID:
                                                    widget.visiteId.toString(),
                                                // imagePath: '/new/path.jpg',
                                              ),
                                            );
                                          },
                                        )
                                        : viewModel
                                                .checkListSubmitView[index]
                                                .inputTypeID ==
                                            2
                                        ? QuantityBox(
                                          onChanged: (String value) {
                                            print(
                                              viewModel
                                                  .checkListSubmitView[index]
                                                  .checklistID,
                                            );
                                            print(
                                              "Quantity: $value",
                                            ); // or answers[index].answer = value;

                                            viewModel.addOrUpdateChecklistEntry(
                                              ChecklistEntry(
                                                token:
                                                    viewModel.user?.apiToken ??
                                                    '',
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
                                                storeID:
                                                    widget.storeId.toString(),
                                                checkListStatus: value,
                                                teamMemberID:
                                                    viewModel.user?.teamMemberID
                                                        .toString() ??
                                                    '',
                                                visitID:
                                                    widget.visiteId.toString(),
                                                // imagePath: '/new/path.jpg',
                                              ),
                                            );
                                          },
                                        )
                                        : viewModel
                                                .checkListSubmitView[index]
                                                .inputTypeID ==
                                            3
                                        ? DateBox(
                                          onChanged: (String selectedDate) {
                                            print(
                                              viewModel
                                                  .checkListSubmitView[index]
                                                  .checklistID,
                                            );
                                            print(
                                              "Selected date: $selectedDate",
                                            ); // or update answers[index].answer

                                            viewModel.addOrUpdateChecklistEntry(
                                              ChecklistEntry(
                                                token:
                                                    viewModel.user?.apiToken ??
                                                    '',
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
                                                storeID:
                                                    widget.storeId.toString(),
                                                checkListStatus: selectedDate,
                                                teamMemberID:
                                                    viewModel.user?.teamMemberID
                                                        .toString() ??
                                                    '',
                                                visitID:
                                                    widget.visiteId.toString(),
                                                // imagePath: '/new/path.jpg',
                                              ),
                                            );
                                          },
                                        )
                                        : TextBox(
                                          onChanged: (value) {
                                            print(
                                              viewModel
                                                  .checkListSubmitView[index]
                                                  .checklistID,
                                            );
                                            print(
                                              "Text value: $value",
                                            ); // or update your JSON model here

                                            viewModel.addOrUpdateChecklistEntry(
                                              ChecklistEntry(
                                                token:
                                                    viewModel.user?.apiToken ??
                                                    '',
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
                                                storeID:
                                                    widget.storeId.toString(),
                                                checkListStatus: value,
                                                teamMemberID:
                                                    viewModel.user?.teamMemberID
                                                        .toString() ??
                                                    '',
                                                visitID:
                                                    widget.visiteId.toString(),
                                                // imagePath: '/new/path.jpg',
                                              ),
                                            );
                                          },
                                        ),
                                index: index,
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

                                onChanged: (String value) {
                                  print(
                                    viewModel
                                        .checkListSubmitView[index]
                                        .checklistID,
                                  );
                                  print(
                                    "Description: $value",
                                  ); // or answers[index].answer = value;

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
                                      // checkListStatus: value,
                                      teamMemberID:
                                          viewModel.user?.teamMemberID
                                              .toString() ??
                                          '',
                                      visitID: widget.visiteId.toString(),
                                      description: value,
                                      // imagePath: '/new/path.jpg',
                                    ),
                                  );
                                },
                              ),

                              Divider(indent: 12, endIndent: 12),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class ProductCard extends StatefulWidget {
  final String title;
  final Widget optionWidget;
  final int index; // change from dynamic to int
  final int index1; // change from dynamic to int

  final Function(String)? onChanged;
  final String? imagePath;
  final Function()? onPickImage;
  final String? initialDescription;

  ProductCard({
    required this.title,
    required this.optionWidget,
    required this.index,
    required this.index1,

    this.onChanged,
    this.imagePath,
    this.onPickImage,
    this.initialDescription,

    Key? key,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
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
                  onChanged: (value) {
                    if (widget.onChanged != null) {
                      widget.onChanged!(value);
                    }
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
                      widget.imagePath != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(widget.imagePath!),
                              fit: BoxFit.cover,
                            ),
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

class ToggleYesNo extends StatefulWidget {
  final Function(String) onChanged;
  ToggleYesNo({required this.onChanged}); // constructor

  @override
  _ToggleYesNoState createState() => _ToggleYesNoState();
}

class _ToggleYesNoState extends State<ToggleYesNo> {
  String selected = 'Yes';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            _buildOption('Yes'),
            SizedBox(width: 12),
            _buildOption('No'),
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

  Widget _buildOption(String value) {
    bool isSelected = selected == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = value;
          widget.onChanged(value);
        });
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

class QuantityBox extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;

  const QuantityBox({this.controller, this.onChanged});

  @override
  State<QuantityBox> createState() => _QuantityBoxState();
}

class _QuantityBoxState extends State<QuantityBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Set a fixed width similar to your design
      height: 36,
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
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

class TextBox extends StatefulWidget {
  final TextEditingController? controller;
  final Function(String)? onChanged;
  const TextBox({this.controller, this.onChanged});

  @override
  State<TextBox> createState() => _TextBoxState();
}

class _TextBoxState extends State<TextBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Set a fixed width similar to your design
      height: 36,
      child: TextField(
        controller: widget.controller,
        keyboardType: TextInputType.text,
        onChanged: (value) {
          if (widget.onChanged != null) {
            widget.onChanged!(value);
          }
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

class DateBox extends StatefulWidget {
  final Function(String)? onChanged;

  const DateBox({Key? key, this.onChanged}) : super(key: key);
  @override
  _DateBoxState createState() => _DateBoxState();
}

class _DateBoxState extends State<DateBox> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
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

      if (widget.onChanged != null) {
        String formatted = DateFormat('dd-MM-yyyy').format(picked);
        widget.onChanged!(formatted);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

    return GestureDetector(
      onTap: () => _selectDate(context),
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
