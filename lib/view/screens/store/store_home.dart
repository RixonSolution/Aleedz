import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/activity/activity_view.dart';
import 'package:aleedz/view/screens/checklist/checklist_view.dart';
import 'package:aleedz/view/screens/price/price_view.dart';
import 'package:aleedz/view/screens/sales/sale_view.dart';
import 'package:aleedz/view/screens/store/display_audit_check_summary.dart';
import 'package:aleedz/view/screens/store/display_picture.dart';
import 'package:aleedz/view/screens/training/training_list_view.dart';
import 'package:aleedz/view/screens/training/training_view.dart';
import 'package:aleedz/view/screens/transfer/transfer_view.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StoreHome extends ConsumerStatefulWidget {
  String grade, address, checkInTime, storeName;
  int storeId;
  StoreHome({
    Key? key,
    required this.grade,
    required this.address,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<StoreHome> createState() => _StoreHomeState();
}

class _StoreHomeState extends ConsumerState<StoreHome> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final notifier = ref.read(storeModelProvider.notifier);

    await notifier.getROSLabels();
    await notifier.getVisiteId(storeId: widget.storeId.toString());
  }

  bool isChecked = false;

  Widget _buildGridItem(
    BuildContext context,
    dynamic ros, {
    bool isFullWidth = false,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.blackColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              '${ApiConstants.baseUrl}${ros.imageLocation}',
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 3),
            Text(
              ros.rosLabelName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFullWidthItem(dynamic ros, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          padding: EdgeInsets.symmetric(vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.blackColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                '${ApiConstants.baseUrl}${ros.imageLocation}',
                height: 60,
                width: 60,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 3),
              Text(
                ros.rosLabelName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, dynamic ros) {
    final viewModel = ref.watch(storeModelProvider);

    final int id = ros.rosLabelID;

    switch (id) {
      case 29:
        NavigationService.navigateTo(
          ChecklistView(
            storeName: widget.storeName,
            checkInTime: widget.checkInTime,
            storeId: widget.storeId,
            visiteId: viewModel.visitId,
          ),
        );
        break;
      case 30:
        NavigationService.navigateTo(
          TrainingListView(
            storeName: widget.storeName,
            checkInTime: widget.checkInTime,
            storeId: widget.storeId,
          ),
        );
        break;
      case 31:
        NavigationService.navigateTo(
          DisplayPicture(
            storeName: widget.storeName,
            checkInTime: widget.checkInTime,
            storeId: widget.storeId,
          ),
        );
        break;
      case 32:
        if (!isChecked) {
          AppSnackBar.showError(
            context,
            'Select the checkbox if you updated the store stock.',
          );
        } else {
          NavigationService.navigateTo(
            DisplayAuditCheckSummary(
              storeName: widget.storeName,
              checkInTime: widget.checkInTime,
              storeId: widget.storeId,
            ),
          );
        }
        break;
      case 33:
        if (widget.checkInTime != '0' && widget.checkInTime != '') {
          NavigationService.navigateTo(
            TransferView(
              storeName: widget.storeName,
              checkInTime: widget.checkInTime,
              storeId: widget.storeId,
            ),
          );
        } else {
          AppSnackBar.showError(
            context,
            'Please check in before transferring the products.',
          );
        }
        break;
      case 35:
        NavigationService.navigateTo(
          ActivityView(
            storeName: widget.storeName,
            checkInTime: widget.checkInTime,
            storeId: widget.storeId,
          ),
        );
        break;
      case 37:
        NavigationService.navigateTo(
          PriceView(
            storeName: widget.storeName,
            checkInTime: widget.checkInTime,
            storeId: widget.storeId,
            visiteId: viewModel.visitId,
          ),
        );
        break;
      case 38:
        NavigationService.navigateTo(
          SaleView(
            storeName: widget.storeName,
            checkInTime: widget.checkInTime,
            storeId: widget.storeId,
          ),
        );
        break;
      default:
        print("Unhandled rosLabelID: $id");
    }
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
                    LabelService().getLabel(26),
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
              padding: EdgeInsets.only(left: 8, top: 8, bottom: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.blackColor),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          LabelService().getLabel(27),
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          margin: EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreyBackground,
                          ),
                          child: Text(
                            widget.grade,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.blackColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 5),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          LabelService().getLabel(28),
                          maxLines: 1,
                          style: TextStyle(
                            color: AppColors.blackColor,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          margin: EdgeInsets.only(right: 10, left: 10),
                          decoration: BoxDecoration(
                            color: AppColors.darkGreyBackground,
                          ),
                          child: Text(
                            widget.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.blackColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // use this button as a grid view return
            SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                setState(() {
                  isChecked = !isChecked;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: isChecked ? Colors.green : Colors.transparent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.grey,
                        ), // Optional border when unchecked
                      ),
                      child:
                          isChecked
                              ? Icon(Icons.check, color: Colors.white, size: 20)
                              : null,
                    ),
                    SizedBox(width: 10),

                    Expanded(
                      child: Text(
                        LabelService().getLabel(54),
                        maxLines: 2,
                        style: TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            viewModel.loader
                ? Center(child: CircularProgressIndicator())
                : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                      itemCount: (viewModel.rosLabels.length / 2).ceil(),
                      itemBuilder: (context, index) {
                        int first = index * 2;
                        int second = first + 1;

                        // If it's the last row and only one item left (odd count)
                        if (second >= viewModel.rosLabels.length) {
                          final ros = viewModel.rosLabels[first];

                          return _buildFullWidthItem(
                            viewModel.rosLabels[first],
                            onTap: () => _handleTap(context, ros),
                          );
                        }
                        // Regular row with two items
                        return Row(
                          children: [
                            Expanded(
                              child: _buildGridItem(
                                onTap:
                                    () => _handleTap(
                                      context,
                                      viewModel.rosLabels[first],
                                    ),

                                context,
                                viewModel.rosLabels[first],
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildGridItem(
                                onTap:
                                    () => _handleTap(
                                      context,
                                      viewModel.rosLabels[second],
                                    ),

                                context,
                                viewModel.rosLabels[second],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),

            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}







// InkWell(
//                           onTap: () {
//                             if (viewModel.rosLabels[index].rosLabelID == 29) {
//                               NavigationService.navigateTo(
//                                 ChecklistView(
//                                   storeName: widget.storeName,
//                                   checkInTime: widget.checkInTime,
//                                   storeId: widget.storeId,
//                                   visiteId: 1,
//                                 ),
//                               );
//                             } else if (viewModel.rosLabels[index].rosLabelID ==
//                                 30) {
//                               NavigationService.navigateTo(
//                                 TrainingListView(
//                                   storeName: widget.storeName,
//                                   checkInTime: widget.checkInTime,
//                                   storeId: widget.storeId,
//                                 ),
//                               );
//                             } else if (viewModel.rosLabels[index].rosLabelID ==
//                                 31) {
//                               NavigationService.navigateTo(
//                                 DisplayPicture(
//                                   storeName: widget.storeName,
//                                   checkInTime: widget.checkInTime,
//                                   storeId: widget.storeId,
//                                 ),
//                               );
//                             } else if (viewModel.rosLabels[index].rosLabelID ==
//                                 32) {
//                               if (isChecked == false) {
//                                 AppSnackBar.showError(
//                                   context,
//                                   'Select the checkbox if you updated the store stock.',
//                                 );
//                               } else {
//                                 NavigationService.navigateTo(
//                                   DisplayAuditCheckSummary(
//                                     storeName: widget.storeName,
//                                     checkInTime: widget.checkInTime,
//                                     storeId: widget.storeId,
//                                   ),
//                                 );
//                               }
//                             } else if (viewModel.rosLabels[index].rosLabelID ==
//                                 33) {
//                               if (widget.checkInTime != '0' &&
//                                   widget.checkInTime != '') {
//                                 NavigationService.navigateTo(
//                                   TransferView(
//                                     storeName: widget.storeName,
//                                     checkInTime: widget.checkInTime,
//                                     storeId: widget.storeId,
//                                   ),
//                                 );
//                               } else {
//                                 AppSnackBar.showError(
//                                   context,
//                                   'Please check in before transferring the products.',
//                                 );
//                               }
//                             } else if (viewModel.rosLabels[index].rosLabelID ==
//                                 35) {
//                               NavigationService.navigateTo(
//                                 ActivityView(
//                                   storeName: widget.storeName,
//                                   checkInTime: widget.checkInTime,
//                                   storeId: widget.storeId,
//                                 ),
//                               );
//                             } else if (viewModel.rosLabels[index].rosLabelID ==
//                                 37) {
//                               NavigationService.navigateTo(
//                                 PriceView(
//                                   storeName: widget.storeName,
//                                   checkInTime: widget.checkInTime,
//                                   storeId: widget.storeId,
//                                   visiteId: 0,
//                                 ),
//                               );
//                             } else if (viewModel.rosLabels[index].rosLabelID ==
//                                 38) {
//                               NavigationService.navigateTo(
//                                 SaleView(
//                                   storeName: widget.storeName,
//                                   checkInTime: widget.checkInTime,
//                                   storeId: widget.storeId,
//                                 ),
//                               );
//                             } else {}
//                           },
//                           child: Container(
//                             margin: EdgeInsets.symmetric(horizontal: 5),
//                             padding: EdgeInsets.only(top: 15, bottom: 15),
//                             decoration: BoxDecoration(
//                               border: Border.all(color: AppColors.blackColor),
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.network(
//                                   '${ApiConstants.baseUrl}${viewModel.rosLabels[index].imageLocation}',
//                                   height: 60,
//                                   width: 60,
//                                   fit: BoxFit.cover,
//                                 ),
//                                 SizedBox(height: 3),
//                                 Text(
//                                   viewModel.rosLabels[index].rosLabelName,
//                                   style: TextStyle(
//                                     color: AppColors.blackColor,
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         );
                  