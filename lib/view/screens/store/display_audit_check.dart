import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/audit_model.dart';
import 'package:aleedz/models/product_selection_model.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';

class DisplayAuditCheck extends ConsumerStatefulWidget {
  String storeName, checkInTime, categoryName, lastUpdate, updateBy;
  int storeId, categoryId;
  DisplayAuditCheck({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.categoryId,
    required this.categoryName,
    required this.lastUpdate,
    required this.updateBy,
  }) : super(key: key);

  @override
  ConsumerState<DisplayAuditCheck> createState() => _DisplayAuditCheckState();
}

class _DisplayAuditCheckState extends ConsumerState<DisplayAuditCheck> {
  TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(storeModelProvider.notifier)
          .getDisplayCheckMaster(
            storeId: widget.storeId.toString(),
            categoryId: widget.categoryId.toString(),
          );
      ref
          .read(storeModelProvider.notifier)
          .checkAudit(widget.storeId, widget.categoryId);
      ref.read(storeModelProvider.notifier).loadUser();

      ref.read(storeModelProvider.notifier).clearData();
    });
  }

  // Function to show image picker dialog for Camera or Gallery
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

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        bottomNavigationBar:
            viewModel.loader
                ? Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                )
                : Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () async {
                        await viewModel.auditMediaSubmit(
                          context,
                          widget.storeId,
                          widget.categoryId.toString(),
                          remarksController.text,
                          checkInImgFile1: viewModel.leftImage,
                          checkInImgFile2: viewModel.rightImage,
                        );
                        List<Map<String, dynamic>> dataList =
                            viewModel.selectedProducts
                                .map((product) => product.toJson())
                                .toList();

                        viewModel.addDisplayCheck(
                          dataList,
                          context,
                          widget.storeId,
                          widget.categoryId,
                        );
                        // Your submit logic
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.zero, // Removes rounded corners
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

        body: SingleChildScrollView(
          child: Column(
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
                      'Display Audit',
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

              SizedBox(height: 5),
              viewModel.loader
                  ? Center(
                    child: CircularProgressIndicator(
                      color: AppColors.secondary,
                    ),
                  )
                  : Builder(
                    builder: (context) {
                      // Group audit items by brand name
                      final groupedAudit = <String, List<AuditItem>>{};
                      for (var item in viewModel.auditList) {
                        groupedAudit
                            .putIfAbsent(item.brandName, () => [])
                            .add(item);
                      }

                      final brandNames = groupedAudit.keys.toList();

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: brandNames.length,
                        itemBuilder: (context, brandIndex) {
                          final brandName = brandNames[brandIndex];
                          final brandItems = groupedAudit[brandName]!;

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Brand Header Row
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          brandName,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          widget.lastUpdate,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                widget.updateBy == '1'
                                                    ? AppColors.primary
                                                    : AppColors.blackColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Divider(),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 5,
                                      ),
                                      color: AppColors.lightGreyBackground,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            widget.categoryName,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Row(
                                            children: const [
                                              SizedBox(
                                                width: 60,
                                                child: Text(
                                                  "Available",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 15),
                                              SizedBox(
                                                width: 60,
                                                child: Text(
                                                  "Less than 2?",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
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
                                    const SizedBox(height: 5),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  // Product Rows
                                  ...brandItems.asMap().entries.map((entry) {
                                    int index = entry.key + 1; // Start from 1
                                    var item = entry.value;

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start, // Important for alignment
                                            children: [
                                              // Index + Product Info
                                              Expanded(
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      width:
                                                          24, // Adjust width to fit index cleanly
                                                      child: Text(
                                                        '$index.',
                                                        style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              AppColors
                                                                  .blackColor,
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            item.productModelCode,
                                                            style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 14,
                                                              color:
                                                                  AppColors
                                                                      .blackColor,
                                                            ),
                                                          ),
                                                          Text(
                                                            item.productModelName,
                                                            style: const TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  AppColors
                                                                      .blackColor,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // Availability Check
                                              GestureDetector(
                                                onTap: () {
                                                  final existing = viewModel
                                                      .selectedProducts
                                                      .firstWhereOrNull(
                                                        (e) =>
                                                            e.productId ==
                                                            item.productId,
                                                      );

                                                  if (existing != null) {
                                                    existing.displayCheck =
                                                        existing.displayCheck ==
                                                                1
                                                            ? 0
                                                            : 1;
                                                  } else {
                                                    viewModel.selectedProducts
                                                        .add(
                                                          ProductSelection(
                                                            productId:
                                                                item.productId,
                                                            displayCheck: 1,
                                                            displayCheckCount:
                                                                0,
                                                            token:
                                                                viewModel
                                                                    .user!
                                                                    .apiToken
                                                                    .toString(),
                                                            storeId:
                                                                widget.storeId
                                                                    .toString(),
                                                            teamMemberId:
                                                                viewModel
                                                                    .user!
                                                                    .teamMemberID
                                                                    .toString(),
                                                          ),
                                                        );
                                                  }
                                                  viewModel.notifyListeners();
                                                },
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                        right: 5,
                                                      ),
                                                  child: SizedBox(
                                                    width: 60,
                                                    child: Icon(
                                                      viewModel.selectedProducts.any(
                                                            (e) =>
                                                                e.productId ==
                                                                    item.productId &&
                                                                e.displayCheck ==
                                                                    1,
                                                          )
                                                          ? Icons.check_circle
                                                          : Icons
                                                              .check_circle_outline,
                                                      color:
                                                          viewModel.selectedProducts.any(
                                                                (e) =>
                                                                    e.productId ==
                                                                        item.productId &&
                                                                    e.displayCheck ==
                                                                        1,
                                                              )
                                                              ? Colors.black
                                                              : Colors
                                                                  .grey
                                                                  .shade400,
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              // Less than 2 Check
                                              GestureDetector(
                                                onTap: () {
                                                  final existing = viewModel
                                                      .selectedProducts
                                                      .firstWhereOrNull(
                                                        (e) =>
                                                            e.productId ==
                                                            item.productId,
                                                      );
                                                  // ✅ Check if product is marked as available
                                                  final isAvailable =
                                                      existing?.displayCheck ==
                                                      1;

                                                  if (!isAvailable) {
                                                    // ❌ Show snackbar if not marked as available
                                                    ScaffoldMessenger.of(
                                                      context,
                                                    ).showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                          "Please mark this product as available first.",
                                                        ),
                                                        backgroundColor:
                                                            Colors.red,
                                                      ),
                                                    );
                                                    return;
                                                  }

                                                  if (existing != null) {
                                                    existing.displayCheckCount =
                                                        existing.displayCheckCount ==
                                                                1
                                                            ? 0
                                                            : 1;
                                                  } else {
                                                    viewModel.selectedProducts
                                                        .add(
                                                          ProductSelection(
                                                            productId:
                                                                item.productId,
                                                            displayCheckCount:
                                                                1,
                                                            displayCheck: 0,
                                                            token:
                                                                viewModel
                                                                    .user!
                                                                    .apiToken
                                                                    .toString(),
                                                            storeId:
                                                                widget.storeId
                                                                    .toString(),
                                                            teamMemberId:
                                                                viewModel
                                                                    .user!
                                                                    .teamMemberID
                                                                    .toString(),
                                                          ),
                                                        );
                                                  }
                                                  viewModel.notifyListeners();
                                                },
                                                child: SizedBox(
                                                  width: 60,
                                                  child: Icon(
                                                    viewModel.selectedProducts.any(
                                                          (e) =>
                                                              e.productId ==
                                                                  item.productId &&
                                                              e.displayCheckCount ==
                                                                  1,
                                                        )
                                                        ? Icons.check_circle
                                                        : Icons
                                                            .check_circle_outline,
                                                    color:
                                                        viewModel.selectedProducts.any(
                                                              (e) =>
                                                                  e.productId ==
                                                                      item.productId &&
                                                                  e.displayCheckCount ==
                                                                      1,
                                                            )
                                                            ? Colors.black
                                                            : Colors
                                                                .grey
                                                                .shade400,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(),
                                        ],
                                      ),
                                    );
                                  }).toList(),

                                  Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: TextField(
                                      controller: remarksController,
                                      maxLines: 5,
                                      decoration: InputDecoration(
                                        hintText: 'Enter your comments...',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),

                                  viewModel.checkMaster.isNotEmpty
                                      ? Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            // Camera Icon with Image Picker
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Open a dialog to pick an image from the camera
                                                  _showImagePickerDialog(
                                                    'left',
                                                  );
                                                },
                                                child: Container(
                                                  height: 150,
                                                  color: Colors.grey.shade300,
                                                  child:
                                                      (viewModel.leftImageRemoved ==
                                                              false)
                                                          ? Stack(
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    ApiConstants
                                                                        .baseUrl +
                                                                    viewModel
                                                                        .checkMaster
                                                                        .first
                                                                        .image1,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                                height: 150,
                                                                width:
                                                                    double
                                                                        .infinity,
                                                                placeholder:
                                                                    (
                                                                      context,
                                                                      url,
                                                                    ) => Shimmer.fromColors(
                                                                      baseColor:
                                                                          Colors
                                                                              .grey
                                                                              .shade300,
                                                                      highlightColor:
                                                                          Colors
                                                                              .grey
                                                                              .shade100,
                                                                      child: Container(
                                                                        width:
                                                                            double.infinity,
                                                                        height:
                                                                            150,
                                                                        color:
                                                                            Colors.white,
                                                                      ),
                                                                    ),
                                                                errorWidget:
                                                                    (
                                                                      context,
                                                                      url,
                                                                      error,
                                                                    ) => const Icon(
                                                                      Icons
                                                                          .error,
                                                                    ),
                                                              ),
                                                              Positioned(
                                                                top: 4,
                                                                right: 4,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    viewModel
                                                                            .leftImageRemoved =
                                                                        true;
                                                                    viewModel
                                                                        .notifyListeners();
                                                                  },
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
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
                                                                      Icons
                                                                          .close,
                                                                      size: 16,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                          : viewModel
                                                                  .leftImage !=
                                                              null
                                                          ? Stack(
                                                            children: [
                                                              Image.file(
                                                                viewModel
                                                                    .leftImage!,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                                height: 150,
                                                                width:
                                                                    double
                                                                        .infinity,
                                                              ),
                                                              Positioned(
                                                                top: 4,
                                                                right: 4,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    viewModel
                                                                            .leftImage =
                                                                        null;
                                                                    viewModel
                                                                        .notifyListeners();
                                                                  },
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
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
                                                                      Icons
                                                                          .close,
                                                                      size: 16,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                          : const Center(
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                ),
                                              ),
                                            ),

                                            const SizedBox(width: 10),

                                            // Gallery Icon with Image Picker
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Open a dialog to pick an image from the gallery
                                                  _showImagePickerDialog(
                                                    'right',
                                                  );
                                                },
                                                child: Container(
                                                  height: 150,
                                                  color: Colors.grey.shade300,
                                                  child:
                                                      (viewModel.rightImageRemoved ==
                                                              false)
                                                          ? Stack(
                                                            children: [
                                                              CachedNetworkImage(
                                                                imageUrl:
                                                                    ApiConstants
                                                                        .baseUrl +
                                                                    viewModel
                                                                        .checkMaster
                                                                        .first
                                                                        .image2,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                                height: 150,
                                                                width:
                                                                    double
                                                                        .infinity,
                                                                placeholder:
                                                                    (
                                                                      context,
                                                                      url,
                                                                    ) => Shimmer.fromColors(
                                                                      baseColor:
                                                                          Colors
                                                                              .grey
                                                                              .shade300,
                                                                      highlightColor:
                                                                          Colors
                                                                              .grey
                                                                              .shade100,
                                                                      child: Container(
                                                                        width:
                                                                            double.infinity,
                                                                        height:
                                                                            150,
                                                                        color:
                                                                            Colors.white,
                                                                      ),
                                                                    ),
                                                                errorWidget:
                                                                    (
                                                                      context,
                                                                      url,
                                                                      error,
                                                                    ) => const Icon(
                                                                      Icons
                                                                          .error,
                                                                    ),
                                                              ),
                                                              Positioned(
                                                                top: 4,
                                                                right: 4,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    viewModel
                                                                            .rightImageRemoved =
                                                                        true;
                                                                    viewModel
                                                                        .notifyListeners();
                                                                  },
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
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
                                                                      Icons
                                                                          .close,
                                                                      size: 16,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                          : viewModel
                                                                  .rightImage !=
                                                              null
                                                          ? Stack(
                                                            children: [
                                                              Image.file(
                                                                viewModel
                                                                    .rightImage!,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                                height: 150,
                                                                width:
                                                                    double
                                                                        .infinity,
                                                              ),
                                                              Positioned(
                                                                top: 4,
                                                                right: 4,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    viewModel
                                                                            .rightImage =
                                                                        null;
                                                                    viewModel
                                                                        .notifyListeners();
                                                                  },
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
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
                                                                      Icons
                                                                          .close,
                                                                      size: 16,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                          : const Center(
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                      : Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                        ),
                                        child: Row(
                                          children: [
                                            // Camera Icon with Image Picker
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Open a dialog to pick an image from the camera
                                                  _showImagePickerDialog(
                                                    'left',
                                                  );
                                                },
                                                child: Container(
                                                  height: 150,
                                                  color: Colors.grey.shade300,
                                                  child:
                                                      viewModel.leftImage !=
                                                              null
                                                          ? Stack(
                                                            children: [
                                                              Image.file(
                                                                viewModel
                                                                    .leftImage!,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                                height: 150,
                                                                width:
                                                                    double
                                                                        .infinity,
                                                              ),
                                                              Positioned(
                                                                top: 4,
                                                                right: 4,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    viewModel
                                                                            .leftImage =
                                                                        null;
                                                                    viewModel
                                                                        .notifyListeners(); // If using ChangeNotifier
                                                                  },
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
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
                                                                      Icons
                                                                          .close,
                                                                      size: 16,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                          : const Center(
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(width: 10),

                                            // Gallery Icon with Image Picker
                                            Expanded(
                                              child: GestureDetector(
                                                onTap: () {
                                                  // Open a dialog to pick an image from the gallery
                                                  _showImagePickerDialog(
                                                    'right',
                                                  );
                                                },
                                                child: Container(
                                                  height: 150,
                                                  color: Colors.grey.shade300,
                                                  child:
                                                      viewModel.rightImage !=
                                                              null
                                                          ? Stack(
                                                            children: [
                                                              Image.file(
                                                                viewModel
                                                                    .rightImage!,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                                height: 150,
                                                                width:
                                                                    double
                                                                        .infinity,
                                                              ),
                                                              Positioned(
                                                                top: 4,
                                                                right: 4,
                                                                child: GestureDetector(
                                                                  onTap: () {
                                                                    viewModel
                                                                            .rightImage =
                                                                        null;
                                                                    viewModel
                                                                        .notifyListeners(); // If using ChangeNotifier
                                                                  },
                                                                  child: Container(
                                                                    decoration: const BoxDecoration(
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
                                                                      Icons
                                                                          .close,
                                                                      size: 16,
                                                                      color:
                                                                          Colors
                                                                              .white,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                          : const Center(
                                                            child: Icon(
                                                              Icons.camera_alt,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                  const SizedBox(height: 20),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: LabelService().getLabel(49),
                                        filled: true,
                                        fillColor:
                                            Colors
                                                .grey[200], // Light grey background
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),

                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintText: LabelService().getLabel(50),
                                        filled: true,
                                        fillColor:
                                            Colors
                                                .grey[200], // Light grey background
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
