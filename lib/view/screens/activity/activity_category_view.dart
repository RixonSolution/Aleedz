import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/view/screens/activity/activity_submit_view.dart';
import 'package:aleedz/viewmodel/activity_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityCategoryView extends ConsumerStatefulWidget {
  String checkInTime, storeName, activityTypeName;
  int storeId, divisionId, categoryId;

  ActivityCategoryView({
    Key? key,
    required this.checkInTime,
    required this.storeName,
    required this.storeId,
    required this.activityTypeName,
    required this.divisionId,
    required this.categoryId,
  }) : super(key: key);

  @override
  ConsumerState<ActivityCategoryView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<ActivityCategoryView> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchCoverage();
    });
  }

  Future<void> loadUserAndFetchCoverage() async {
    await ref
        .read(activityModelProvider.notifier)
        .getActivityCategoryId(
          divisionId: widget.divisionId.toString(),
          categoryTypeId: widget.categoryId.toString(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(activityModelProvider);
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body:
            viewModel.loader
                ? Center(child: CircularProgressIndicator())
                : Column(
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
                            'Activity Category',
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
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              widget.activityTypeName,
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
                      padding: const EdgeInsets.symmetric(horizontal: 16),

                      child: TextField(
                        controller: searchController,
                        style: TextStyle(color: AppColors.greyText),
                        decoration: InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: AppColors.greyText),
                          border: UnderlineInputBorder(),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.greyText),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.greyText),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.activityCategoryId.length,
                        shrinkWrap: true,
                        primary: true,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              NavigationService.navigateTo(
                                ActivitySubmitView(
                                  storeName: widget.storeName,
                                  checkInTime: widget.checkInTime,
                                  storeId: widget.storeId,
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        '${index + 1}.  ',
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        viewModel
                                                .activityCategoryId[index]
                                                .activityCategoryName ??
                                            '',
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Divider(height: 5),
                                ],
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
