import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/viewmodel/coverage_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CoverageView extends ConsumerStatefulWidget {
  const CoverageView({super.key});

  @override
  ConsumerState<CoverageView> createState() => _CoverageViewState();
}

class _CoverageViewState extends ConsumerState<CoverageView> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(coverageModelProvider.notifier).loadUser();
      ref.read(coverageModelProvider.notifier).getCoverageCount(context);
      ref.read(coverageModelProvider.notifier).getCoverageDropDown();
      ref.read(coverageModelProvider.notifier).getCoverageList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(coverageModelProvider);
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
                  Image.asset(AppIcons.backArrow, height: 30, width: 30),
                  Text(
                    '@16 Screen Title',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Image.asset(AppIcons.locationIcon, height: 30, width: 30),
                ],
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Divider(color: AppColors.primary, height: 0),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '@17 Total Coverage Stores',
                    style: TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Center(
                        child: Text(
                          "${viewModel.storeCount ?? 0}",
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextField(
                onChanged: (value) {
                  viewModel.getCoverageList(context, searchKeyword: value);
                },
                decoration: InputDecoration(
                  hintText: '@18 Search Store...',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
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
                  hintText: '@19 Filter by (Dropdown)',
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
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
                  viewModel.selectChannel(selected, context);
                },
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10),
            //   child: DropdownButtonFormField<ChannelModel>(
            //     value: viewModel.selectedChannel,
            //     decoration: InputDecoration(
            //   hintText: '@19 Filter by (Dropdown)',
            //   border: UnderlineInputBorder(
            //     borderSide: BorderSide(color: Colors.grey),
            //   ),
            //   enabledBorder: UnderlineInputBorder(
            //     borderSide: BorderSide(color: Colors.grey),
            //   ),
            //   focusedBorder: UnderlineInputBorder(
            //     borderSide: BorderSide(color: Colors.blue),
            //   ),
            //   contentPadding: EdgeInsets.symmetric(
            //     horizontal: 0,
            //     vertical: 12,
            //   ),
            // ),
            //     items:
            //         viewModel.channelList
            //             .map(
            //               (channel) => DropdownMenuItem(
            //                 value: channel,
            //                 child: Text(channel.channelName),
            //               ),
            //             )
            //             .toList(),
            //     onChanged: (channel) {
            //       viewModel.selectChannel(
            //         channel,
            //         context,
            //       ); // <-- Call API here
            //     },
            //   ),
            // ),
            SizedBox(height: 5),
            viewModel.loader
                ? Center(
                  child: CircularProgressIndicator(color: AppColors.secondary),
                )
                : Flexible(
                  child: ListView.separated(
                    physics: ScrollPhysics(),
                    itemCount: viewModel.stores.length,
                    padding: EdgeInsets.symmetric(vertical: 0),
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 15,
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                              ),
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: AppColors.blackColor,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    viewModel.stores[index].storeName,
                                    style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 3),
                                  Text(
                                    viewModel.stores[index].address,
                                    style: TextStyle(
                                      color: AppColors.blackColor,
                                      fontSize: 13,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Image.asset(
                                        AppIcons.locationIcon,
                                        height: 20,
                                        width: 20,
                                      ),
                                      Text(
                                        'Distance: 12KM',
                                        style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            viewModel.stores[index].visitStatusId == 0
                                ? Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Column(
                                      children: [
                                        Text(
                                          'Check In',
                                          style: TextStyle(
                                            color: AppColors.blackColor,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : Padding(
                                  padding: const EdgeInsets.only(top: 20),
                                  child: InkWell(
                                    onTap: () {},
                                    child: Column(
                                      children: [
                                        Text(
                                          '14@In : 10:11',
                                          style: TextStyle(
                                            color: AppColors.secondary,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Check Out',
                                          style: TextStyle(
                                            color: AppColors.secondary,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder:
                        (context, index) => Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          color: Colors.grey,
                          height: 1,
                        ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
