import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/checklist_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingSubmit extends ConsumerStatefulWidget {
  String checkInTime, storeName, trainingName;
  int storeId, storeCount;

  TrainingSubmit({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.trainingName,
    required this.storeCount,
  }) : super(key: key);

  @override
  ConsumerState<TrainingSubmit> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<TrainingSubmit> {
  TextEditingController searchController = TextEditingController();
  final Set<int> selectedIndexes = {};

  final List<Map<String, dynamic>> trainings = [
    {'training': 'Promoter Name 1', 'address': 'Store Name'},
    {'training': 'Promoter Name 2', 'address': 'Store Name'},
    {'training': 'Promoter Name 3', 'address': 'Store Name'},
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
            onPressed: () async {},
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              ),
            ),
            child: Text(
              'Submit',
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
                            'Trainings',
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

                    Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      padding: EdgeInsets.symmetric(vertical: 12),

                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              'Training ID : 3030',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Center(
                            child: Text(
                              widget.trainingName,
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                '#   ',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              Text(
                                'Attendese Details',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            'Score %',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.whiteColor,
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

                                    SizedBox(
                                      width: 50,
                                      height: 24,
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: AppColors.blackColor,
                                        ),
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                vertical: 0,
                                                horizontal: 4,
                                              ),
                                          hintText: '0',
                                          hintStyle: const TextStyle(
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ), // Circular like checkbox
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              5,
                                            ),
                                            borderSide: const BorderSide(
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        keyboardType: TextInputType.number,
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
