import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/issues_veiwmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class DeployementSubmitView extends ConsumerStatefulWidget {
  String checkInTime, storeName, activityCategoryName;
  int storeId, divisionId, activityTypeId, activitiCategoryId;

  DeployementSubmitView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.activityCategoryName,
    required this.divisionId,
    required this.activityTypeId,
    required this.activitiCategoryId,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<DeployementSubmitView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<DeployementSubmitView> {
  void _showImagePickerDialog() {
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
                title: const Text(
                  'From Gallery',
                  style: TextStyle(color: AppColors.whiteColor),
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
                          4)
                        break;
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
        );
      },
    );
  }

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchActivity();
    });
  }

  Future<void> loadUserAndFetchActivity() async {
    await ref
        .read(issuesModelProvider.notifier)
        .getMarketActivityList(
          storeId: widget.storeId.toString(),
          activityCategoryId: widget.activitiCategoryId.toString(),
          activityTypeId: widget.activityTypeId.toString(),
          brandId: '1',
        );
  }

  Future<void> _showLogoutDialog(
    BuildContext context,

    void Function()? onPressed,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing by tapping outside
      builder:
          (context) => AlertDialog(
            backgroundColor: AppColors.secondary,
            title: const Text(
              'Delete',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            content: const Text(
              'Are you sure you want to delete?',
              style: TextStyle(color: AppColors.whiteColor),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Close dialog
                child: const Text(
                  'No',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
              TextButton(
                onPressed: onPressed,
                child: const Text(
                  'Yes',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ],
          ),
    );
  }

  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(issuesModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    'Deployment',
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
            SizedBox(height: 5),
            Center(
              child: Text(
                widget.storeName,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Center(
              child: Text(
                'Checked In ${widget.checkInTime}',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),

            Container(
              decoration: BoxDecoration(color: AppColors.secondary),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.activityCategoryName,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.blackColor),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: TextField(
                                  controller: descriptionController,
                                  maxLines: 3,
                                  minLines: 2,
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Describe issue details',
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              BarcodeScannerUI(),
                              SizedBox(height: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          if (viewModel
                                                  .beforeActivityImages
                                                  .length <
                                              4) {
                                            _showImagePickerDialog();
                                          } else {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Maximum 4 images allowed.",
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
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
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
                                      SizedBox(
                                        height: 80,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount:
                                              viewModel
                                                  .beforeActivityImages
                                                  .length,
                                          itemBuilder: (context, index) {
                                            final file =
                                                viewModel
                                                    .beforeActivityImages[index];
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
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
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
                                                      viewModel
                                                          .beforeActivityImages
                                                          .removeAt(index);
                                                      viewModel
                                                          .notifyListeners();
                                                    },
                                                    child: Container(
                                                      decoration:
                                                          const BoxDecoration(
                                                            color:
                                                                AppColors
                                                                    .secondary,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                      padding:
                                                          const EdgeInsets.all(
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
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: SizedBox(
                            // width: double.infinity,
                            height: 50,
                            child:
                                viewModel.loader
                                    ? Center(child: CircularProgressIndicator())
                                    : ElevatedButton(
                                      onPressed: () async {
                                        if (descriptionController
                                            .text
                                            .isEmpty) {
                                          AppSnackBar.showError(
                                            context,
                                            'Please add description',
                                          );
                                        } else if (viewModel
                                            .beforeActivityImages
                                            .isEmpty) {
                                          AppSnackBar.showError(
                                            context,
                                            'Please add pictures',
                                          );
                                        } else {
                                          await viewModel.marketActivityAdd(
                                            storeID: widget.storeId.toString(),
                                            activityTypeId:
                                                widget.activityTypeId
                                                    .toString(),
                                            activityCategoryId:
                                                widget.activitiCategoryId
                                                    .toString(),
                                            brandId: '1',
                                            activityDescription:
                                                descriptionController.text,
                                            statusId: '1',
                                            quantity: '1',
                                            deployementReason: '1',
                                            beforeActivityPictures:
                                                viewModel.beforeActivityImages,
                                          );
                                          descriptionController.clear();
                                          viewModel.beforeActivityImages
                                              .clear();
                                          setState(() {});

                                          viewModel.notifyListeners();
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: const RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius
                                                  .zero, // Removes rounded corners
                                        ),
                                        backgroundColor: AppColors.secondary,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text(
                                            "Submit",
                                            style: TextStyle(
                                              color: AppColors.whiteColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  GestureDetector(
                    onTap: () {
                      //
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.darkGreyBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Recent Deployement',
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12),
                    child: const Divider(color: AppColors.primary, height: 5),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8,
                          top: 5,
                          bottom: 10,
                        ),
                        child: Text(
                          LabelService().getLabel(56),
                          style: TextStyle(
                            color: AppColors.greyText,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ListView.builder(
                    itemCount: viewModel.marketActivityList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onLongPress: () {
                          _showLogoutDialog(context, () async {
                            NavigationService.goBack();

                            await viewModel.removeActivity(
                              activityId:
                                  viewModel.marketActivityList[index].activityID
                                      .toString(),
                              activityTypeId:
                                  viewModel
                                      .marketActivityList[index]
                                      .activityTypeID
                                      .toString(),
                            );
                            await loadUserAndFetchActivity();
                          });
                        },
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 8),
                                  child: Text(
                                    '${index + 1}.',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: SizedBox(
                                          width: 190,
                                          // color: Colors.red,
                                          child: Text(
                                            '${viewModel.marketActivityList[index].activityTypeName} - ${viewModel.marketActivityList[index].activityCategoryName}',
                                            style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: SizedBox(
                                          width: 190,
                                          // color: Colors.red,
                                          child: Text(
                                            viewModel
                                                .marketActivityList[index]
                                                .activityDescription
                                                .toString(),
                                            style: TextStyle(
                                              color: AppColors.greyText,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 15),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          'Date: ${viewModel.marketActivityList[index].activityDateTime}}',
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 5),

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Text(
                                          'Quantity: ${viewModel.marketActivityList[index].quantity}',
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SizedBox(height: 10),

                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            child: CachedNetworkImage(
                                              //
                                              imageUrl:
                                                  '${ApiConstants.baseUrl}/${viewModel.marketActivityList[index].imageActivity}',
                                              // imageUrl:
                                              //     '${ApiConstants.baseUrl}${viewModel.viewPicture[index].column1 ?? ''}',
                                              height: 120,
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width,

                                              placeholder:
                                                  (context, url) =>
                                                      Shimmer.fromColors(
                                                        baseColor:
                                                            Colors.grey[300]!,
                                                        highlightColor:
                                                            Colors.grey[100]!,
                                                        child: Container(
                                                          height: 120,
                                                          width:
                                                              MediaQuery.of(
                                                                context,
                                                              ).size.width,

                                                          color: Colors.white,
                                                        ),
                                                      ),
                                              errorWidget:
                                                  (context, url, error) => Icon(
                                                    Icons.error,
                                                  ), // optional error widget
                                              fit: BoxFit.cover, // optional fit
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            Divider(
                              color: Colors.grey[300],
                              thickness: 1,
                              indent: 12,
                              endIndent: 12,
                            ),
                          ],
                        ),
                      );
                    },
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

class BarcodeScannerUI extends StatefulWidget {
  const BarcodeScannerUI({super.key});

  @override
  State<BarcodeScannerUI> createState() => _BarcodeScannerUIState();
}

class _BarcodeScannerUIState extends State<BarcodeScannerUI> {
  final TextEditingController _barcodeController = TextEditingController();
  final List<String> scannedCodes = [];

  void _addCode() {
    final code = _barcodeController.text.trim();
    if (code.isNotEmpty) {
      setState(() {
        scannedCodes.add(code);
        _barcodeController.clear();
      });
    }
  }

  void _removeCode(int index) {
    setState(() {
      scannedCodes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Input Row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _barcodeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(),
                  hintText: 'Enter Scan Code',
                ),
              ),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _addCode,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        /// Table Header
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.grey.shade200,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Row(
            children: const [
              Expanded(
                flex: 1,
                child: Text('#', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 4,
                child: Text(
                  'Scan Code',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  'Action',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        /// Table List
        ...List.generate(scannedCodes.length, (index) {
          return Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.black),
                right: BorderSide(color: Colors.black),
                bottom: BorderSide(color: Colors.black),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
            child: Row(
              children: [
                Expanded(flex: 1, child: Text('${index + 1}')),
                Expanded(flex: 4, child: Text(scannedCodes[index])),
                Expanded(
                  flex: 2,
                  child: IconButton(
                    onPressed: () => _removeCode(index),
                    icon: Icon(Icons.cancel, color: Colors.orange),
                  ),
                ),
              ],
            ),
          );
        }),

        /// Table Footer
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black),
            color: Colors.grey.shade100,
          ),
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          child: Row(
            children: [
              const Expanded(
                flex: 5,
                child: Text(
                  'Total Count',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                flex: 2,
                child: Text(
                  '${scannedCodes.length}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
