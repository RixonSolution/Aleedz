import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/checklist/checklist_submit.dart';
import 'package:aleedz/view/screens/training/training_promoter.dart';
import 'package:aleedz/viewmodel/checklist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class TrainingStores extends ConsumerStatefulWidget {
  String checkInTime, storeName, trainingName;
  int storeId;

  TrainingStores({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.trainingName,
  }) : super(key: key);

  @override
  ConsumerState<TrainingStores> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<TrainingStores> {
  TextEditingController searchController = TextEditingController();
  final Set<int> selectedIndexes = {};

  final List<Map<String, dynamic>> trainings = [
    {'training': 'Store Name 1', 'address': 'Address Of Store'},
    {'training': 'Store Name 2', 'address': 'Address Of Store'},
    {'training': 'Store Name 3', 'address': 'Address Of Store'},
  ];

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
              NavigationService.navigateTo(
                TrainingPromoter(
                  storeName: widget.storeName,
                  checkInTime: widget.checkInTime,
                  storeId: widget.storeId,
                  trainingName: widget.trainingName,
                  storeCount: selectedIndexes.length,
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
              LabelService().getLabel(145),
              style: TextStyle(fontSize: 14, color: AppColors.whiteColor),
            ),
          ),
        ),

        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                )
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
                          Text(
                            LabelService().getLabel(291),
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
                        '${LabelService().getLabel(14)} ${widget.checkInTime}',
                        style: const TextStyle(
                          color: AppColors.blackColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(vertical: 12),

                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Center(
                        child: Text(
                          widget.trainingName,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey[200], // Light grey background
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          /// Search TextField
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              style: const TextStyle(
                                color: AppColors.blackColor,
                              ),
                              decoration: InputDecoration(
                                hintText: LabelService().getLabel(135),
                                hintStyle: TextStyle(color: AppColors.greyText),
                                border: InputBorder.none, // 🔴 Remove underline
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                              ),
                            ),
                          ),

                          /// Selected Count
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 25,
                              vertical: 15,
                            ),
                            decoration: BoxDecoration(
                              // color: Colors.grey[500],
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: Text(
                              "${selectedIndexes.length}", // <- Use your selected count
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Expanded(
                      child: ListView.builder(
                        physics: ScrollPhysics(),
                        padding: const EdgeInsets.all(5),
                        itemCount: trainings.length,
                        itemBuilder: (context, index) {
                          final training = trainings[index];
                          final isSelected = selectedIndexes.contains(index);

                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Text Info
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${index + 1}.  ',
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 14,
                                                  color: AppColors.blackColor,
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${training['training']}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    training['address'],
                                                    style: const TextStyle(
                                                      fontSize: 12,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// Custom Circular Checkbox
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          if (isSelected) {
                                            selectedIndexes.remove(index);
                                          } else {
                                            selectedIndexes.add(index);
                                          }
                                        });
                                      },
                                      child: Container(
                                        width: 24,
                                        height: 24,
                                        margin: const EdgeInsets.only(
                                          right: 10,
                                          top: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color:
                                              isSelected
                                                  ? Colors.black
                                                  : Colors.grey[400],
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(height: 25),
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
