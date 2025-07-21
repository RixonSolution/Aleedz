import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/user_training/user_training_model_view.dart';
import 'package:aleedz/viewmodel/user_training_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserTrainingPromoter extends ConsumerStatefulWidget {
  final String trainingName, trainingId, storeIds;

  UserTrainingPromoter({
    Key? key,
    required this.trainingName,
    required this.trainingId,
    required this.storeIds,
  }) : super(key: key);

  @override
  ConsumerState<UserTrainingPromoter> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<UserTrainingPromoter> {
  TextEditingController searchController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  final Set<int> selectedIndexes = {};

  List<Promoter> promoterList = [];
  List<Promoter> promoterNames1 = [];

  void addName() {
    if (idController.text.isNotEmpty && nameController.text.isNotEmpty) {
      setState(() {
        promoterList.add(
          Promoter(
            id: idController.text.trim(),
            name: nameController.text.trim(),
          ),
        );
        idController.clear();
        nameController.clear();
      });
    }
  }

  void removeName(int index) {
    setState(() {
      promoterList.removeAt(index);
    });
  }

  void addPromoterName(String name, String id) {
    final existingIndex = promoterNames1.indexWhere(
      (promoter) => promoter.id == id,
    );

    setState(() {
      if (existingIndex != -1) {
        promoterNames1.removeAt(existingIndex);
      } else {
        promoterNames1.add(Promoter(id: id.trim(), name: name.trim()));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchPromoter();
    });
  }

  Future<void> loadUserAndFetchPromoter() async {
    final notifier = ref.read(userTrainingModelProvider.notifier);
    await notifier.getPromoterList(storeId: '1');
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(userTrainingModelProvider);

    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: Container(
          margin: EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          color: Colors.white,
          child: ElevatedButton(
            onPressed: () async {
              NavigationService.navigateTo(
                UserTrainingModelView(
                  storeId: widget.storeIds.toString(),
                  trainingName: widget.trainingName,
                  storeCount: widget.storeIds.length,
                  promotorCount: selectedIndexes.length,
                  promoterNames1: promoterNames1,
                  promoterList: promoterList,
                  trainingId: widget.trainingId,
                  storeIds: widget.storeIds.toString(),
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

                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 8),
                            padding: EdgeInsets.symmetric(vertical: 12),

                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                            ),
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

                          const SizedBox(height: 20),

                          ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            padding: const EdgeInsets.all(5),
                            itemCount: viewModel.promoterList.length,
                            itemBuilder: (context, index) {
                              final isSelected = selectedIndexes.contains(
                                index,
                              );

                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 14,
                                                      color:
                                                          AppColors.blackColor,
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        '${viewModel.promoterList[index].teamMemberName}',
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 14,
                                                          color:
                                                              AppColors
                                                                  .blackColor,
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
                                                              AppColors
                                                                  .blackColor,
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
                                              viewModel
                                                  .promoterList[index]
                                                  .teamMemberID
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
                            decoration: BoxDecoration(
                              color: AppColors.secondary,
                            ),
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

                          Row(
                            children: [
                              /// ID Field
                              Expanded(
                                flex: 2,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: idController,
                                    decoration: InputDecoration(
                                      hintText: 'Promoter ID',
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /// Name Field
                              Expanded(
                                flex: 3,
                                child: Container(
                                  padding: EdgeInsets.only(left: 10),
                                  margin: EdgeInsets.only(left: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: TextField(
                                    controller: nameController,
                                    decoration: InputDecoration(
                                      hintText: 'Promoter Name',
                                      border: InputBorder.none,
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              /// Add Button
                              Container(
                                margin: EdgeInsets.only(left: 10, right: 10),
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
                          SizedBox(height: 10),

                          /// Table Header with Border
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              color: Colors.grey[300],
                            ),
                            child: Row(
                              children: const [
                                Expanded(
                                  flex: 1,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        '#',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'ID',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        ' Name',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text(
                                        'Action',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// List of Entries with Border
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: promoterList.length,
                            itemBuilder: (context, index) {
                              final promoter = promoterList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('${index + 1}'),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(promoter.id),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(promoter.name),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: InkWell(
                                          onTap: () => removeName(index),
                                          child: Container(
                                            padding: EdgeInsets.all(4),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: Colors.orange,
                                                width: 2,
                                              ),
                                            ),
                                            child: Icon(
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
                  ],
                ),
      ),
    );
  }
}

class Promoter {
  final String id;
  final String name;

  Promoter({required this.id, required this.name});
}
