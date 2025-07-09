import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/pending_deployment_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PendingDeplomentView extends ConsumerStatefulWidget {
  PendingDeplomentView({Key? key}) : super(key: key);

  @override
  ConsumerState<PendingDeplomentView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<PendingDeplomentView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchCoverage();
    });
  }

  Future<void> loadUserAndFetchCoverage() async {
    final notifier = ref.read(pendingModelProvider.notifier);
    await notifier.loadPending();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(pendingModelProvider);

    return SafeArea(
      child: Scaffold(
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
                            'Pending Deployment',
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: TextField(
                        onChanged: (value) {},
                        decoration: InputDecoration(
                          hintText: 'Search',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.secondary),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 0,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 5),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: DropdownButtonFormField<int>(
                        value: viewModel.selectedChannel?.channelId,
                        decoration: InputDecoration(
                          hintText: 'Activity Category',
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.secondary),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 0,
                            vertical: 12,
                          ),
                        ),

                        items:
                            viewModel.channelList.map((channel) {
                              return DropdownMenuItem<int>(
                                value: channel.channelId,
                                child: Text(channel.channelName),
                              );
                            }).toList(),
                        onChanged: (int? channelId) {
                          final selected = viewModel.channelList.firstWhere(
                            (c) => c.channelId == channelId,
                          );
                          viewModel.selectChannel(
                            selected,
                            context,
                            forceRefresh: true,
                          );
                        },
                      ),
                    ),

                    SizedBox(height: 10),

                    Expanded(
                      child: ListView.builder(
                        itemCount: viewModel.pendingList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              // NavigationService.navigateTo(
                              //   TrainingSubmit(
                              //     storeName: widget.storeName,
                              //     checkInTime: widget.checkInTime,
                              //     storeId: widget.storeId,
                              //     trainingName: '',
                              //     storeCount: 0,
                              //   ),
                              // );
                            },

                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: Colors.grey.shade300,
                                  ),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${index + 1} ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 3,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${viewModel.pendingList[index].activityCategoryName}',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          viewModel.pendingList[index].storeName
                                              .toString(),
                                          style: TextStyle(
                                            // fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          viewModel
                                              .pendingList[index]
                                              .taskDeploymentCategoryName
                                              .toString(),
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        SizedBox(height: 4),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        '${viewModel.pendingList[index].planDateTime.toString()}',
                                        textAlign: TextAlign.end,
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
