import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/checklist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ChecklistSubmit extends ConsumerStatefulWidget {
  String checkInTime, storeName, checklistName;
  int storeId;

  ChecklistSubmit({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.checklistName,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<ChecklistSubmit> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<ChecklistSubmit> {
  void _showImagePickerDialog(String direction) {
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
                onTap: () {
                  ref
                      .read(checklistModelProvider.notifier)
                      .pickFromCamera(direction);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text(
                  'From Gallery',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
                onTap: () {
                  ref
                      .read(checklistModelProvider.notifier)
                      .pickFromGallery(direction);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
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
            onPressed: () {
              // Handle submit action here
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Form Submitted!",
                    style: TextStyle(color: AppColors.whiteColor),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Text(
              "Submit",
              style: TextStyle(fontSize: 14, color: AppColors.whiteColor),
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
                      child: ListView(
                        children: [
                          ProductCard(
                            title:
                                'Zone Vibe 100 wireless headphones - GRAPHITE',
                            optionWidget: ToggleYesNo(),
                            onTap: () {
                              _showImagePickerDialog('left');
                            },
                          ),
                          Divider(indent: 12, endIndent: 12),
                          ProductCard(
                            title:
                                'Zone Vibe 100 wireless headphones - GRAPHITE',
                            optionWidget: QuantityBox(),
                            onTap: () {
                              _showImagePickerDialog('left');
                            },
                          ),
                          Divider(indent: 12, endIndent: 12),
                          ProductCard(
                            title:
                                'Zone Vibe 100 wireless headphones - GRAPHITE',
                            optionWidget: DateBox(),
                            onTap: () {
                              _showImagePickerDialog('left');
                            },
                          ),
                          Divider(indent: 12, endIndent: 12),
                        ],
                      ),
                    ),
                  ],
                ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String title;
  final Widget optionWidget;
  void Function() onTap;

  ProductCard({
    required this.title,
    required this.optionWidget,
    required this.onTap,
  });

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
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              optionWidget,
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  maxLines: 2,
                ),
              ),
              SizedBox(width: 12),
              GestureDetector(
                onTap: onTap,
                child: Container(
                  height: 80,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(Icons.camera_alt),
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
  @override
  _ToggleYesNoState createState() => _ToggleYesNoState();
}

class _ToggleYesNoState extends State<ToggleYesNo> {
  String selected = 'Yes';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [_buildOption('Yes'), SizedBox(width: 12), _buildOption('No')],
    );
  }

  Widget _buildOption(String value) {
    bool isSelected = selected == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          selected = value;
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

class QuantityBox extends StatelessWidget {
  final TextEditingController? controller;

  const QuantityBox({this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80, // Set a fixed width similar to your design
      height: 36,
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          hintText: 'Quantity',
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
  const DateBox({Key? key}) : super(key: key);

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
