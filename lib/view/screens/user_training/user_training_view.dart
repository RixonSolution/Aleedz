import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/models/user_training_type.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/user_training/user_training_stores.dart';
import 'package:aleedz/viewmodel/user_training_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class UserTrainingView extends ConsumerStatefulWidget {
  UserTrainingView({Key? key}) : super(key: key);

  @override
  ConsumerState<UserTrainingView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<UserTrainingView> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchType();
    });
  }

  Future<void> loadUserAndFetchType() async {
    final notifier = ref.read(userTrainingModelProvider.notifier);
    await notifier.userTrainingType();
    filteredTrainingList = notifier.trainingTypeList;
    searchController.addListener(() {
      filterSearchResults();
    });
  }

  List<UserTrainingType> filteredTrainingList = [];

  void filterSearchResults() {
    final viewModel = ref.watch(userTrainingModelProvider);

    String query = searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredTrainingList = viewModel.trainingTypeList;
      } else {
        filteredTrainingList =
            viewModel.trainingTypeList.where((item) {
              return item.trainingTypeName!.toLowerCase().contains(query);
            }).toList();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(userTrainingModelProvider);
    final header = Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
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
              Text(
                LabelService().getLabel(291),
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
            LabelService().getLabel(137),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );

    return SafeArea(
      child: Scaffold(
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
                    header,
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: searchController,
                        style: const TextStyle(color: AppColors.blackColor),
                        decoration: InputDecoration(
                          hintText: LabelService().getLabel(135),
                          hintStyle: TextStyle(color: AppColors.greyText),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.greyText),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                        itemCount: filteredTrainingList.length,
                        itemBuilder: (context, index) {
                          final item = filteredTrainingList[index];
                          return GestureDetector(
                            onTap: () {
                              NavigationService.navigateTo(
                                UserTrainingStores(
                                  trainingName:
                                      item.trainingTypeName.toString(),
                                  trainingId: item.trainingTypeID.toString(),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(16, 5, 16, 5),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(18),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0x14000000),
                                      blurRadius: 14,
                                      offset: Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      left: 0,
                                      top: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 30,
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF111827),
                                              Color(0xFF0B1120),
                                            ],
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                          ),
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(18),
                                            bottomLeft: Radius.circular(18),
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          '${index + 1}',
                                          style: const TextStyle(
                                            color: AppColors.whiteColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        40,
                                        14,
                                        14,
                                        14,
                                      ),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item.trainingTypeName.toString(),
                                              style: const TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                              ),
                                            ),
                                          ),
                                          const Icon(
                                            Icons.chevron_right,
                                            color: Colors.grey,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
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
