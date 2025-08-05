import 'dart:io';
import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/activity_viewmodel.dart';
import 'package:aleedz/viewmodel/issues_veiwmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shimmer/shimmer.dart';

class IssueSubmitView extends ConsumerStatefulWidget {
  String checkInTime, storeName, activityCategoryName;
  int storeId, divisionId, activityTypeId, activitiCategoryId;

  IssueSubmitView({
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
  ConsumerState<IssueSubmitView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<IssueSubmitView> {
  void _showImagePickerDialog() {
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
                title: Text(
                  LabelService().getLabel(113),
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
            title: Text(
              LabelService().getLabel(100),
              style: TextStyle(color: AppColors.whiteColor),
            ),
            content: Text(
              LabelService().getLabel(99),
              style: TextStyle(color: AppColors.whiteColor),
            ),
            actions: [
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
                    'Issues',
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
                '${LabelService().getLabel(14)} ${widget.checkInTime}',
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
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: LabelService().getLabel(118),
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),

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
                                      Expanded(
                                        child: SizedBox(
                                          height: 80,
                                          child: ListView.builder(
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
                                                    margin:
                                                        const EdgeInsets.only(
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
                                                                  BoxShape
                                                                      .circle,
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
                            width: double.infinity,
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
                                            LabelService().getLabel(157),
                                          );
                                        } else if (viewModel
                                            .beforeActivityImages
                                            .isEmpty) {
                                          AppSnackBar.showError(
                                            context,
                                            LabelService().getLabel(115),
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
                                      child: const Text(
                                        "Submit",
                                        style: TextStyle(
                                          color: AppColors.whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
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
                            LabelService().getLabel(124),
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
                                          '${LabelService().getLabel(159)}: ${viewModel.marketActivityList[index].activityDateTime}}',
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
                                          '${LabelService().getLabel(160)}: ${viewModel.marketActivityList[index].quantity}',
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
                                              imageUrl:
                                                  '${ApiConstants.baseUrl}/${viewModel.marketActivityList[index].imageActivity}',

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
