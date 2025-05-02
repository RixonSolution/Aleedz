import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
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
      ref.read(coverageModelProvider.notifier).getLatLong();
      ref.read(coverageModelProvider.notifier).getCoverageCount(context);
      ref.read(coverageModelProvider.notifier).getCoverageDropDown();
      ref.read(coverageModelProvider.notifier).getCoverageList(context);
    });
  }

  Future<void> showCustomPopup({
    required BuildContext context,
    required String title,
    required String checkStatus,

    required void Function(String value) onSubmit,
  }) {
    final TextEditingController _controller = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 10,
          ), // Remove default dialog padding
          backgroundColor:
              Colors
                  .transparent, // Make dialog transparent to handle full custom layout
          child: Align(
            alignment: Alignment.center, // Position to top if needed
            child: Material(
              color: AppColors.whiteColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(16), // Optional internal padding
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AppColors.blackColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      height: 200,
                      decoration: BoxDecoration(color: AppColors.blackColor),
                      child: Center(
                        child: Text(
                          'Camera will open and taken image will\nappear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _controller,
                      style: TextStyle(color: AppColors.blackColor),
                      decoration: InputDecoration(
                        hintText: '@21 ${checkStatus} Remarks',
                        hintStyle: TextStyle(color: AppColors.blackColor),
                        border: UnderlineInputBorder(),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.blackColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: AppColors.blackColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        onSubmit(_controller.text);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          color: AppColors.secondary,
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.primary,
                              width: 4.0,
                            ),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '@14 ${checkStatus}',
                            style: TextStyle(
                              color: AppColors.whiteColor,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
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
                    LabelService().getLabel(17),
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
                  hintText: LabelService().getLabel(18),
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
                  hintText: LabelService().getLabel(19),
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
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          showCustomPopup(
                            context: context,
                            title: viewModel.stores[index].storeName,
                            checkStatus:
                                viewModel.stores[index].visitStatusId == 0
                                    ? 'Check In'
                                    : 'Check Out',
                            onSubmit: (value) {
                              if (viewModel.stores[index].visitStatusId == 0) {
                                viewModel.coverageCheckIn(
                                  context,
                                  viewModel.stores[index].storeId,
                                  remarks: value,
                                );
                              } else {
                                viewModel.coverageCheckout(
                                  context,
                                  viewModel.stores[index].visitStatusId,
                                  remarks: value,
                                );
                              }
                            },
                          );
                        },
                        child: Container(
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
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          Text(
                                            'Last Visted: ${viewModel.stores[index].lastVisitedDate}',
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
                              ),
                              viewModel.stores[index].visitStatusId == 0
                                  ? Center(
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
                                  : InkWell(
                                    onTap: () {},
                                    child: Column(
                                      children: [
                                        Text(
                                          '14@In : ${viewModel.stores[index].checkInTime}',
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
                            ],
                          ),
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
