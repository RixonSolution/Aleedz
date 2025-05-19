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

  TextEditingController remarksControll = TextEditingController();

  bool deleteLoader = false;

  void _showImagePickerDialog(String directiion) {
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
                title: const Text(
                  'From Gallery',
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
                onPressed: () async {
                  await ref
                      .read(storeModelProvider.notifier)
                      .deleteDisplayPicture(
                        storeId: widget.storeId.toString(),
                        pictureId: pictureId,
                        pictureName: pictureName,
                      );

                  NavigationService.goBack();
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(color: AppColors.whiteColor),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);

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
                    'Display Pictures',
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
            SizedBox(height: 20),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100, // Light grey background
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<int>(
                        value: viewModel.selectedBrand?.brandId,
                        decoration: const InputDecoration(
                          hintText: 'Select Brands',
                          border: InputBorder.none, // Removes underline
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 12,
                          ),
                        ),
                        items:
                            viewModel.brandList.map((brand) {
                              return DropdownMenuItem<int>(
                                value: brand.brandId,
                                child: Text(brand.brandName),
                              );
                            }).toList(),
                        onChanged: (int? branddlId) {
                          final selected = viewModel.brandList.firstWhere(
                            (c) => c.brandId == branddlId,
                          );
                          viewModel.selectBrand(
                            widget.storeId,
                            selected,
                            context,
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100, // Light grey background
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: DropdownButtonFormField<int>(
                        value: viewModel.selectedPictureModel?.pictureElementId,
                        decoration: const InputDecoration(
                          hintText: 'Select Display Type',
                          border: InputBorder.none, // Removes underline
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 12,
                          ),
                        ),
                        items:
                            viewModel.pictureList.map((brand) {
                              return DropdownMenuItem<int>(
                                value: brand.pictureElementId,
                                child: Text(brand.pictureElementName),
                              );
                            }).toList(),
                        onChanged: (int? picListId) {
                          final selected = viewModel.pictureList.firstWhere(
                            (c) => c.pictureElementId == picListId,
                          );
                          viewModel.selectPictureDrop(selected, context);
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Multiline TextField
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: TextField(
                              controller: remarksControll,
                              maxLines: 3,
                              minLines: 2,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Remarks',
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        GestureDetector(
                          onTap: () {
                            _showImagePickerDialog('left');
                          },
                          child: Container(
                            height: 70,
                            width: 80,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:
                                viewModel.leftImage != null
                                    ? Stack(
                                      children: [
                                        Image.file(
                                          viewModel.leftImage!,
                                          fit: BoxFit.cover,
                                          height: 70,
                                          width: 80,
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () {
                                              viewModel.leftImage = null;
                                              viewModel
                                                  .notifyListeners(); // If using ChangeNotifier
                                            },
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color: AppColors.secondary,
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
                                    : const Center(
                                      child: Icon(
                                        Icons.camera_alt,
                                        color: Colors.grey,
                                      ),
                                    ),
                          ),
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
                                  if (viewModel.selectedPictureModel == null) {
                                    AppSnackBar.showError(
                                      context,
                                      'Please select brand',
                                    );
                                  } else if (viewModel.selectedBrand == null) {
                                    AppSnackBar.showError(
                                      context,
                                      'Please select display type',
                                    );
                                  } else if (remarksControll.text.isEmpty) {
                                    AppSnackBar.showError(
                                      context,
                                      'Please add remarks',
                                    );
                                  } else if (viewModel.leftImage == null) {
                                    AppSnackBar.showError(
                                      context,
                                      'Please add image',
                                    );
                                  } else {
                                    await viewModel.submitDisplayPicture(
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
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      LabelService().getLabel(53),
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
            Expanded(
              child: ListView.builder(
                itemCount: viewModel.viewPicture.length,
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        '${ApiConstants.baseUrl}${viewModel.viewPicture[index].column1 ?? ''}',
                                    height: 70,
                                    width: 80,
                                    placeholder:
                                        (context, url) => Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            height: 70,
                                            width: 80,
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
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: SizedBox(
                                        width: 190,
                                        // color: Colors.red,
                                        child: Text(
                                          viewModel
                                                  .viewPicture[index]
                                                  .brandName ??
                                              '',
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
                                                  .viewPicture[index]
                                                  .storePictureElementName ??
                                              '',
                                          style: TextStyle(
                                            color: AppColors.greyText,
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
                                                  .viewPicture[index]
                                                  .remarks ??
                                              '',
                                          style: TextStyle(
                                            color: AppColors.greyText,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Text(
                                        viewModel
                                                .viewPicture[index]
                                                .creationDateTime ??
                                            '',
                                        style: TextStyle(
                                          color: AppColors.greyText,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                deleteLoader = true;
                              });
                              _showLogoutDialog(
                                context,
                                viewModel.viewPicture[index].pictureID
                                    .toString(),
                                viewModel.viewPicture[index].pictureName
                                    .toString(),
                              );
                              setState(() {
                                deleteLoader = false;
                              });
                            },
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
