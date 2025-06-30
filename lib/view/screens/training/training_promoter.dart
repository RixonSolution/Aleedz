import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/training/training_model_view.dart';
import 'package:aleedz/viewmodel/training_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainingPromoter extends ConsumerStatefulWidget {
  String checkInTime, storeName, trainingName;
  int storeId, storeCount;

  TrainingPromoter({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.trainingName,
    required this.storeCount,
  }) : super(key: key);

  @override
  ConsumerState<TrainingPromoter> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<TrainingPromoter> {
  TextEditingController searchController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  final Set<int> selectedIndexes = {};

  final List<Map<String, dynamic>> trainings = [
    {'training': 'Promoter Name 1', 'address': 'Store Name'},
    {'training': 'Promoter Name 2', 'address': 'Store Name'},
    {'training': 'Promoter Name 3', 'address': 'Store Name'},
  ];

  List<String> promoterNames = [];
  List<String> promoterNames1 = [];

  void addName() {
    final name = nameController.text.trim();
    if (name.isNotEmpty) {
      setState(() {
        promoterNames.add(name);
        nameController.clear();
      });
    }
    addPromoterName(name);
  }

  void removeName(int index) {
    setState(() {
      promoterNames.removeAt(index);
    });
  }

  void addPromoterName(String name) {
    if (promoterNames1.contains(name)) {
      promoterNames1.remove(name);
      setState(() {});
    } else {
      promoterNames1.add(name);
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchPromoter();
    });
  }

  Future<void> loadUserAndFetchPromoter() async {
    final notifier = ref.read(trainingModelProvider.notifier);
    await notifier.getPromoterList(storeId: widget.storeId.toString());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(trainingModelProvider);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          color: Colors.white,
          child: ElevatedButton(
            onPressed: () async {
              NavigationService.navigateTo(
                TrainingModelView(
                  storeName: widget.storeName,
                  checkInTime: widget.checkInTime,
                  storeId: widget.storeId,
                  trainingName: widget.trainingName,
                  storeCount: widget.storeCount,
                  promotorCount: selectedIndexes.length,
                  promoterNames1: promoterNames1,

                  // checklistName: training['training'],
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
              'Next',
              style: TextStyle(fontSize: 14, color: AppColors.whiteColor),
            ),
          ),
        ),

        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                  child: Column(
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

                      const SizedBox(height: 20),

                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(5),
                        itemCount: viewModel.promoterList.length,
                        itemBuilder: (context, index) {
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
                                                    '${viewModel.promoterList[index].teamMemberName}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                  Text(
                                                    viewModel
                                                        .promoterList[index]
                                                        .storeName
                                                        .toString(),
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
                                        addPromoterName(
                                          viewModel
                                              .promoterList[index]
                                              .teamMemberName
                                              .toString(),
                                        );
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

                      Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(color: AppColors.secondary),
                        child: Row(
                          children: [
                            Text(
                              'Additional Attendese',
                              style: TextStyle(
                                color: AppColors.whiteColor,
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        padding: const EdgeInsets.symmetric(
                          // horizontal: 16,
                          vertical: 8,
                        ),

                        child: Row(
                          children: [
                            /// Search TextField
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.only(left: 10),
                                margin: EdgeInsets.only(left: 10),
                                decoration: BoxDecoration(
                                  color:
                                      Colors.grey[200], // Light grey background
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: TextField(
                                  controller: nameController,
                                  style: const TextStyle(
                                    color: AppColors.blackColor,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Add promoter name',
                                    hintStyle: TextStyle(
                                      color: AppColors.greyText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    border: InputBorder.none,
                                    isDense: true,
                                    contentPadding: EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(right: 10, left: 10),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.blackColor,
                              ),
                              child: InkWell(
                                onTap: addName,
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Icon(
                                    Icons.add,
                                    color: AppColors.whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// Table Header
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black),
                        ),
                        child: Row(
                          children: const [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  '#',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: Text(
                                  'Promoter name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Action',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// List of Entries
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: promoterNames.length,
                        itemBuilder: (context, index) {
                          final name = promoterNames[index];
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                            ),
                            child: Row(
                              children: [
                                /// Index #
                                Expanded(
                                  flex: 1,
                                  child: Center(child: Text('${index + 1}')),
                                ),

                                /// Name
                                Expanded(
                                  flex: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ),

                                /// Action (Remove)
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: InkWell(
                                      onTap: () {
                                        removeName(index);
                                        addPromoterName(name);
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.orange,
                                            width: 2,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          color: Colors.orange,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
