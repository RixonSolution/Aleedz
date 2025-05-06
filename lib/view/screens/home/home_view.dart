import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/app_text_style.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/core/utils/store_local_data.dart';
import 'package:aleedz/models/user_model.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> {
  UserModel? user;

  @override
  void initState() {
    super.initState();
    loadUserAndFetchCoverage();
  }

  Future<void> loadUserAndFetchCoverage() async {
    await loadUserFromPrefs(); // Make sure user is ready
    ref
        .read(coverageModelProvider.notifier)
        .getCoverageCount(context); // Now call
  }

  Future<void> loadUserFromPrefs() async {
    final localData = StoreLocalData();
    final fetchedUser = await localData.getUserFromPrefs();
    setState(() {
      user = fetchedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(coverageModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.blackColor,
                            width: 1,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          size: 70,
                          color: AppColors.blackColor,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${user?.teamMemberName ?? ""}',
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${user?.teamTypeName ?? ""}',
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            '${user?.divisionName ?? ""}',
                            style: const TextStyle(
                              color: AppColors.blackColor,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const Divider(color: AppColors.primary, height: 5),
                  const SizedBox(height: 5),

                  // Stats
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 110,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AppIcons.coverageNetwork,
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 85,
                                    child: Text(
                                      LabelService().getLabel(11),
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.labelStyle,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                "${viewModel.storeCount ?? 0}",
                                style: AppTextStyles.bigTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 110,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    AppIcons.toddayPlan,
                                    height: 20,
                                    width: 20,
                                  ),
                                  SizedBox(
                                    width: 85,
                                    child: Text(
                                      LabelService().getLabel(12),
                                      style: AppTextStyles.labelStyle,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '10-Jan-2025',
                                style: AppTextStyles.subLabelStyle,
                              ),
                              Text('6', style: AppTextStyles.bigTextStyle),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // Coverage List
                  ListView.builder(
                    itemCount: 1,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final isEven = index % 2 == 0;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 15,
                        ),
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        AppIcons.locationRecent,
                                        height: 25,
                                        width: 25,
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 3,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                LabelService().getLabel(13),
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                'Emax Mall Of The Emirates, Dubai UAE',
                                                style: TextStyle(
                                                  color: AppColors.blackColor,
                                                  fontSize: 13,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: () {},
                              child: Column(
                                children: [
                                  if (isEven)
                                    Text(
                                      '${LabelService().getLabel(14)} : 10:11',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  Text(
                                    isEven
                                        ? LabelService().getLabel(15)
                                        : LabelService().getLabel(14),
                                    style: TextStyle(
                                      color:
                                          isEven
                                              ? AppColors.secondary
                                              : AppColors.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
