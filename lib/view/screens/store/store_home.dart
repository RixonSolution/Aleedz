import 'package:aleedz/core/constants/api_constants.dart';
import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/app_snackbar.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/activity/activity_view.dart';
import 'package:aleedz/view/screens/checklist/checklist_view.dart';
import 'package:aleedz/view/screens/delployement/deployment_view.dart';
import 'package:aleedz/view/screens/issues/issues_list.dart';
import 'package:aleedz/view/screens/price/price_view.dart';
import 'package:aleedz/view/screens/sales/sale_view.dart';
import 'package:aleedz/view/screens/stock/stock_summary_view.dart';
import 'package:aleedz/view/screens/store/display_audit_check_summary.dart';
import 'package:aleedz/view/screens/store/display_picture.dart';
import 'package:aleedz/view/screens/store_share/store_share_view.dart';
import 'package:aleedz/view/screens/training/training_list_view.dart';
import 'package:aleedz/view/screens/transfer/transfer_view.dart';
import 'package:aleedz/viewmodel/store_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

    // await notifier.getROSLabels();
    await notifier.getVisiteId(storeId: widget.storeId.toString());
  }

  bool isChecked = false;

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
          AppSnackBar.showError(context, LabelService().getLabel(190));
        } else {
          NavigationService.navigateTo(
            DisplayAuditCheckSummary(
              storeName: widget.storeName,
              checkInTime: widget.checkInTime,
              address: widget.address,
              storeId: widget.storeId,
              visitId: viewModel.visitId,
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
              visiteId: viewModel.visitId,
            ),
          );
        } else {
          AppSnackBar.showError(
            context,
            'Please check in before transferring the products.',
          );
        }
        break;
      case 34:
        NavigationService.navigateTo(
          DeploymentView(
            storeName: widget.storeName,
            checkInTime: widget.checkInTime,
            storeId: widget.storeId,
          ),
        );
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
      case 36:
        NavigationService.navigateTo(
          IssuesList(
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

      case 39:
        NavigationService.navigateTo(
          StockSummaryView(
            storeName: widget.storeName,
            checkInTime: widget.checkInTime,
            storeId: widget.storeId,
            visitId: viewModel.visitId,
          ),
        );
        break;
      case 40:
        NavigationService.navigateTo(
          StoreShareView(
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

  Color _accentColor(int id) {
    switch (id) {
      case 29:
        return Colors.blue;
      case 32:
        return Colors.blueGrey;
      case 31:
        return Colors.purple;
      case 33:
        return Colors.green;
      case 35:
        return Colors.amber;
      case 37:
        return Colors.red;
      case 38:
        return Colors.indigo;
      case 39:
        return Colors.teal;
      case 34:
        return Colors.pink;
      case 40:
        return Colors.orange;
      case 36:
        return Colors.red.shade400;
      case 30:
        return Colors.cyan;
      default:
        return Colors.blueGrey;
    }
  }

  String? _assetForRos(int id) {
    const Map<int, String> assetMap = {
      29: 'assets/icons/actions/checklist.svg', // Checklist
      30: 'assets/icons/actions/trainings.svg', // Trainings
      31: 'assets/icons/actions/store_pictures.svg', // Store Pictures
      32: 'assets/icons/actions/display_check.svg', // Display Check
      33: 'assets/icons/actions/transfer.svg', // Transfer
      34: 'assets/icons/actions/deployment.svg', // Deployment
      35: 'assets/icons/actions/activity.svg', // Activity
      36: 'assets/icons/actions/issues.svg', // Issues
      37: 'assets/icons/actions/price_promo.svg', // Price & Promo
      38: 'assets/icons/actions/sales.svg', // Sales
      39: 'assets/icons/actions/stock_track.svg', // Stock Track
      40: 'assets/icons/actions/investment.svg', // Investment
    };
    return assetMap[id];
  }

  Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (_) {
      return false;
    }
  }

  Widget _buildGridItem(
    BuildContext context,
    dynamic ros, {
    required VoidCallback onTap,
  }) {
    final accent = _accentColor(ros.rosLabelID);
    final assetPath = _assetForRos(ros.rosLabelID);

    Widget iconWidget;
    if (assetPath != null) {
      iconWidget = FutureBuilder<bool>(
        future: _assetExists(assetPath),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == true) {
            return SvgPicture.asset(
              assetPath,
              width: 26,
              height: 26,
              colorFilter: ColorFilter.mode(accent, BlendMode.srcIn),
            );
          }
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.data == false) {
            return Icon(Icons.grid_view_rounded, color: accent, size: 24);
          }
          return SizedBox(width: 26, height: 20);
        },
      );
    } else {
      iconWidget = Image.network(
        '${ApiConstants.baseUrl}${ros.imageLocation}',
        width: 28,
        height: 28,
        fit: BoxFit.contain,
        errorBuilder:
            (_, __, ___) =>
                Icon(Icons.grid_view_rounded, color: accent, size: 24),
      );
    }

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(child: iconWidget),
            ),
            const SizedBox(height: 10),
            Text(
              ros.rosLabelName,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.blackColor,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body:
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
                                'Store Actions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
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
                          const SizedBox(height: 4),
                          Text(
                            widget.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
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
                                const Icon(
                                  Icons.check,
                                  color: Colors.greenAccent,
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
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isChecked = !isChecked;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color:
                                    isChecked
                                        ? Colors.green
                                        : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey),
                              ),
                              child:
                                  isChecked
                                      ? const Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 20,
                                      )
                                      : null,
                            ),
                            const SizedBox(width: 10),
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
                    const SizedBox(height: 16),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 1,
                                mainAxisSpacing: 1,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: viewModel.rosLabels.length,
                          itemBuilder: (context, index) {
                            final ros = viewModel.rosLabels[index];
                            return _buildGridItem(
                              context,
                              ros,
                              onTap: () => _handleTap(context, ros),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
