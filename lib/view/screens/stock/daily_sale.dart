import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:flutter/material.dart';

class DailySale extends StatefulWidget {
  String storeName, checkInTime;
  int storeId, visitId;
  DailySale({
    Key? key,
    required this.storeName,
    required this.checkInTime,
    required this.storeId,
    required this.visitId,
  }) : super(key: key);

  @override
  State<DailySale> createState() => _DailySaleState();
}

class _DailySaleState extends State<DailySale> {
  final List<ProductSale> sales = [
    ProductSale(
      sku: '981-001219',
      category: 'Category',
      name: 'Zone Vibe 100 wireless headphones - OFF WHITE',
      quantity: 1,
      unitPrice: 1521,
      total: 2400,
    ),
    ProductSale(
      sku: '981-001219',
      category: 'Category',
      name: 'Zone Vibe 100 wireless headphones - OFF WHITE',
      quantity: 1,
      unitPrice: 1521,
      total: 2400,
    ),
    ProductSale(
      sku: '981-001219',
      category: 'Category',
      name: 'Zone Vibe 100 wireless headphones - OFF WHITE',
      quantity: 1,
      unitPrice: 1521,
      total: 2400,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,

        // appBar: AppBar(title: Text("Product Category")),
        body: Column(
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
                    'Daily Sale',
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
                '${LabelService().getLabel(14)} ${widget.checkInTime}',
                style: TextStyle(
                  color: AppColors.blackColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),

            /// Table Header
            Container(
              color: AppColors.secondary,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
              child: Row(
                children: const [
                  Expanded(flex: 1, child: Text("#", style: headerStyle)),
                  Expanded(
                    flex: 5,
                    child: Text("Sales Description", style: headerStyle),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text("Quantity", style: headerStyle),
                  ),
                  Expanded(flex: 2, child: Text("Total", style: headerStyle)),
                ],
              ),
            ),

            /// Table Rows
            ...sales.asMap().entries.map((entry) {
              int index = entry.key + 1;
              ProductSale sale = entry.value;

              return Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 8,
                ),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 1, child: Text("$index")),
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${sale.sku} - ${sale.category}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(sale.name),
                          SizedBox(height: 4),
                          Text(
                            "Price: ${sale.unitPrice}",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    Expanded(flex: 2, child: Text("${sale.quantity}")),
                    Expanded(
                      flex: 2,
                      child: Text(
                        "${sale.total}",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class ProductSale {
  final String sku;
  final String category;
  final String name;
  final int quantity;
  final int unitPrice;
  final int total;

  ProductSale({
    required this.sku,
    required this.category,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.total,
  });
}

const headerStyle = TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
