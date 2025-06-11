import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceSubmit extends ConsumerStatefulWidget {
  String storeName, checkInTime;
  int storeId;
  PriceSubmit({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
  }) : super(key: key);

  @override
  ConsumerState<PriceSubmit> createState() => _DisplayAuditCheckSummaryState();
}

class _DisplayAuditCheckSummaryState extends ConsumerState<PriceSubmit> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Removes focus from any text field
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.whiteColor,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0), // Optional padding
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(color: AppColors.secondary),
              width: double.infinity,
              height: 50,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Submit',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          body: Column(
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
                      'Price Promotions',
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

              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppColors.secondary),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Logitec',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'B2C Headsets',
                          style: TextStyle(
                            color: AppColors.whiteColor,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '1  ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            'Zone Vibe 100 wireless headphones – GRAPHITE',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          color: AppColors.lightGreyBackground,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              hintText: 'RRP',
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              fillColor:
                                                  AppColors.lightGreyBackground,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 100,
                                          color: AppColors.lightGreyBackground,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              hintText: 'Net Price',
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              fillColor:
                                                  AppColors.lightGreyBackground,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreyBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.camera_alt, size: 32),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Promotions field
                          Container(
                            color: AppColors.lightGreyBackground,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Promotions',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: AppColors.lightGreyBackground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(indent: 15, endIndent: 15),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '2  ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            'Zone Vibe 100 wireless headphones – GRAPHITE',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          color: AppColors.lightGreyBackground,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              hintText: 'RRP',
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              fillColor:
                                                  AppColors.lightGreyBackground,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 100,
                                          color: AppColors.lightGreyBackground,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              hintText: 'Net Price',
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              fillColor:
                                                  AppColors.lightGreyBackground,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreyBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.camera_alt, size: 32),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Promotions field
                          Container(
                            color: AppColors.lightGreyBackground,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Promotions',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: AppColors.lightGreyBackground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(indent: 15, endIndent: 15),

                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '3  ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 200,
                                          child: Text(
                                            'Zone Vibe 100 wireless headphones – GRAPHITE',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),

                                    Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          color: AppColors.lightGreyBackground,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              hintText: 'RRP',
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              fillColor:
                                                  AppColors.lightGreyBackground,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 100,
                                          color: AppColors.lightGreyBackground,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.zero,
                                              hintText: 'Net Price',
                                              border: OutlineInputBorder(),
                                              filled: true,
                                              fillColor:
                                                  AppColors.lightGreyBackground,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: AppColors.lightGreyBackground,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(Icons.camera_alt, size: 32),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          // Promotions field
                          Container(
                            color: AppColors.lightGreyBackground,
                            child: TextField(
                              decoration: InputDecoration(
                                labelText: 'Promotions',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: AppColors.lightGreyBackground,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(indent: 15, endIndent: 15),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
