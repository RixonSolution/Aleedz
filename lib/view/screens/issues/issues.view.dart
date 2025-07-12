import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/constants/assets/app_icons.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/viewmodel/issues_veiwmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class IssuesView extends ConsumerStatefulWidget {
  IssuesView({Key? key}) : super(key: key);

  @override
  ConsumerState<IssuesView> createState() => _MyConsumerState();
}

class _MyConsumerState extends ConsumerState<IssuesView> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      loadUserAndFetchCoverage();
    });
  }

  Future<void> loadUserAndFetchCoverage() async {
    final notifier = ref.read(issuesModelProvider.notifier);
    // await notifier.loadTraining(widget.storeId.toString());
  }

  String? selectedCategory;
  String? selectedSubCategory;

  final List<String> categories = ['Electronics', 'Clothing', 'Furniture'];
  final Map<String, List<String>> subCategories = {
    'Electronics': ['Mobiles', 'Laptops', 'Cameras'],
    'Clothing': ['Men', 'Women', 'Kids'],
    'Furniture': ['Tables', 'Sofas', 'Beds'],
  };

  List<Map<String, dynamic>> items = [
    {"product": "Washing Machine, Top Load", "qty": 2, "total": 25999},
    {"product": "Washing Machine, Top Load", "qty": 1, "total": 25999},
    {"product": "Washing Machine, Top Load", "qty": 1, "total": 25999},
    {"product": "Washing Machine, Top Load", "qty": 1, "total": 25999},
    {"product": "Washing Machine, Top Load", "qty": 1, "total": 25999},
  ];

  int quantity = 1;
  TextEditingController priceController = TextEditingController();
  double totalAmount = 0.0;

  void calculateTotal() {
    double price = double.tryParse(priceController.text) ?? 0;
    totalAmount = quantity * price;
    setState(() {});
    // Call setState if in StatefulWidget
    // setState(() {});
  }

  List<Map<String, dynamic>> invoiceList = [
    {
      "invoice": "Inv-00178",
      "isExpanded": true,
      "products": [
        {
          "name": "EWF1242R8C",
          "description": "Washing Machine\nTop Load",
          "qty": 1,
          "price": 25999,
        },
        {
          "name": "EWF1242R8C",
          "description": "Washing Machine\nTop Load",
          "qty": 1,
          "price": 25999,
        },
        {
          "name": "EWF1242R8C",
          "description": "Washing Machine\nTop Load",
          "qty": 1,
          "price": 25999,
        },
        {
          "name": "EWF1242R8C",
          "description": "Washing Machine\nTop Load",
          "qty": 1,
          "price": 25999,
        },
      ],
    },
    {
      "invoice": "EWF1242R8C",
      "isExpanded": false,
      "products": [
        {"name": "EWF1242R8C", "description": "", "qty": 1, "price": 25999},
      ],
    },
    {
      "invoice": "EWF1242R8C",
      "isExpanded": false,
      "products": [
        {"name": "EWF1242R8C", "description": "", "qty": 1, "price": 25999},
      ],
    },
    {
      "invoice": "EWF1242R8C",
      "isExpanded": false,
      "products": [
        {"name": "EWF1242R8C", "description": "", "qty": 1, "price": 25999},
      ],
    },
    {
      "invoice": "EWF1242R8C",
      "isExpanded": false,
      "products": [
        {"name": "EWF1242R8C", "description": "", "qty": 1, "price": 25999},
      ],
    },
  ];

  String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(issuesModelProvider);

    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.whiteColor,

        body:
            viewModel.loader
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                  // crossAxisAlignment: CrossAxisAlignment.start,
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
                            'Sellout',
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

                    // Center(
                    //   child: Text(
                    //     widget.storeName,
                    //     style: const TextStyle(
                    //       color: AppColors.blackColor,
                    //       fontSize: 18,
                    //       fontWeight: FontWeight.bold,
                    //     ),
                    //   ),
                    // ),
                    WeeklyCalendar(),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Category Dropdown
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: 'Category',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black,
                                ),
                                value: selectedCategory,
                                isExpanded: true,
                                hint: const Center(
                                  child: Text(
                                    'Category',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                items:
                                    categories.map((String category) {
                                      return DropdownMenuItem<String>(
                                        value: category,
                                        child: Center(
                                          child: Text(
                                            category,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedCategory = newValue;
                                    selectedSubCategory =
                                        null; // Reset subcategory when category changes
                                  });
                                },
                              ),
                            ),
                          ),

                          const SizedBox(width: 16), // Space between dropdowns
                          // Subcategory Dropdown
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ), // Optional inner padding
                              child: DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  hintText: 'Sub Category',
                                  hintStyle: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 0,
                                  ),
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Colors.black, // Icon color
                                ), // Dropdown icon on the right
                                value: selectedSubCategory,
                                isExpanded:
                                    true, // Important to expand to full width
                                hint: const Center(
                                  child: Text(
                                    'Sub Category',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                                items:
                                    (subCategories[selectedCategory] ?? []).map(
                                      (String subCategory) {
                                        return DropdownMenuItem<String>(
                                          value: subCategory,
                                          child: Center(
                                            // Center the selected value
                                            child: Text(
                                              subCategory,
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        );
                                      },
                                    ).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedSubCategory = newValue;
                                  });
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      margin: const EdgeInsets.symmetric(horizontal: 14),
                      child: TextField(
                        textAlign:
                            TextAlign
                                .start, // Or remove this for natural alignment
                        decoration: const InputDecoration(
                          hintText:
                              'Search model based on selected subcategory',
                          hintStyle: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          prefixIcon: Icon(Icons.search, color: Colors.black),
                          prefixIconConstraints: BoxConstraints(
                            minWidth:
                                40, // Adjust based on how close you want the icon
                            minHeight: 40,
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // Quantity Selector
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Decrement Button (Grey)
                                GestureDetector(
                                  onTap: () {
                                    if (quantity > 1) {
                                      setState(() {
                                        quantity--;
                                        calculateTotal();
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),

                                // Quantity Text in White Box
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    '$quantity',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),

                                // Increment Button (Green)
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      quantity++;
                                      calculateTotal();
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(8),

                                    decoration: BoxDecoration(
                                      color: Colors.green.shade400,
                                    ),
                                    child: const Icon(
                                      Icons.add,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Price Input
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: TextField(
                                controller: priceController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  calculateTotal();
                                },
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Enter Price',
                                  hintStyle: TextStyle(fontSize: 12),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),

                          // Total Amount Display
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: TextField(
                                enabled: false,
                                keyboardType: TextInputType.number,

                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  hintText:
                                      totalAmount == 0.0
                                          ? 'Total'
                                          : totalAmount.toString(),
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            'Add Product',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Header
                            Container(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade50,
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(12),
                                ),
                              ),
                              child: Row(
                                children: const [
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '#',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 4,
                                    child: Text(
                                      'Product',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Qty',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Total',

                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Divider(height: 1),

                            // List Items
                            ListView.separated(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: items.length,
                              separatorBuilder:
                                  (context, index) => const Divider(height: 1),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text('${index + 1}'),
                                      ),
                                      Expanded(
                                        flex: 4,
                                        child: Text(item['product']),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text('${item['qty']}'),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${item['total'].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              items.removeAt(index);
                                            });
                                          },
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: TextField(
                                // controller: priceController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  // calculateTotal();
                                },
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Customer Number',
                                  hintStyle: TextStyle(fontSize: 12),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: TextField(
                                // controller: priceController,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {},
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Customer Name',
                                  hintStyle: TextStyle(fontSize: 12),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(right: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: TextField(
                                // controller: priceController,
                                keyboardType: TextInputType.number,
                                onChanged: (value) {
                                  // calculateTotal();
                                },
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Customer Email',
                                  hintStyle: TextStyle(fontSize: 12),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 5,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 3,
                              ),
                              child: TextField(
                                // controller: priceController,
                                keyboardType: TextInputType.text,
                                onChanged: (value) {},
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                  hintText: 'Invoice Number',
                                  hintStyle: TextStyle(fontSize: 12),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.lightBlue),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            'Upload attachment',
                            style: TextStyle(
                              color: Colors.lightBlue,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(color: AppColors.secondary),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Center(
                          child: Text(
                            'Submit',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '23June Sales',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Main Container
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Header
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    children: const [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          '#',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Invoice',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Qty',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Price',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          'Total',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(flex: 1, child: SizedBox()),
                                    ],
                                  ),
                                ),

                                const Divider(height: 1),

                                // List
                                ListView.builder(
                                  primary: true,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: invoiceList.length,
                                  itemBuilder: (context, index) {
                                    final invoice = invoiceList[index];
                                    final products =
                                        invoice["products"] as List;

                                    final totalQty = products.fold(
                                      0,
                                      (sum, item) => sum + (item["qty"] as int),
                                    );
                                    final totalAmount = products.fold(
                                      0,
                                      (sum, item) =>
                                          sum +
                                          (item["qty"] as int) *
                                              (item["price"] as int),
                                    );

                                    return Column(
                                      children: [
                                        // Parent Row
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              invoice["isExpanded"] =
                                                  !(invoice["isExpanded"]
                                                      as bool);
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                              horizontal: 8,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child: Text('${index + 1}'),
                                                ),
                                                Expanded(
                                                  flex: 3,
                                                  child: Text(
                                                    invoice["invoice"],
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text('$totalQty'),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text('25,999'),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    formatNumber(totalAmount),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Icon(
                                                    invoice["isExpanded"]
                                                        ? Icons
                                                            .keyboard_arrow_up
                                                        : Icons
                                                            .keyboard_arrow_down,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),

                                        // Child Rows
                                        if (invoice["isExpanded"] == true)
                                          Column(
                                            children:
                                                products.map((product) {
                                                  return Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                          vertical: 10,
                                                          horizontal: 8,
                                                        ),
                                                    child: Row(
                                                      children: [
                                                        const Expanded(
                                                          flex: 1,
                                                          child: SizedBox(),
                                                        ),
                                                        Expanded(
                                                          flex: 3,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                product["name"],
                                                                style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              if ((product["description"]
                                                                      as String)
                                                                  .isNotEmpty)
                                                                Text(
                                                                  product["description"],
                                                                  style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color:
                                                                        Colors
                                                                            .grey,
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            '${product["qty"]}',
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            formatNumber(
                                                              product["price"],
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                            formatNumber(
                                                              product["qty"] *
                                                                  product["price"],
                                                            ),
                                                          ),
                                                        ),
                                                        const Expanded(
                                                          flex: 1,
                                                          child: SizedBox(),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                }).toList(),
                                          ),

                                        const Divider(height: 1),
                                      ],
                                    );
                                  },
                                ),

                                // Footer Row Total
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade50,
                                    borderRadius: const BorderRadius.vertical(
                                      bottom: Radius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Expanded(
                                        flex: 1,
                                        child: SizedBox(),
                                      ),
                                      const Expanded(
                                        flex: 3,
                                        child: Text(
                                          'Total',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          '${invoiceList.fold(0, (sum, item) => sum + (item["products"] as List).fold(0, (s, p) => s + (p["qty"] as int)))}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Expanded(flex: 2, child: Text('')),
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          formatNumber(
                                            invoiceList.fold(
                                              0,
                                              (sum, item) =>
                                                  sum +
                                                          (item["products"]
                                                                  as List)
                                                              .fold(
                                                                0,
                                                                (s, p) =>
                                                                    s +
                                                                    (p["qty"] *
                                                                        p["price"]),
                                                              )
                                                      as int,
                                            ),
                                          ),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const Expanded(
                                        flex: 1,
                                        child: SizedBox(),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
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

class WeeklyCalendar extends StatefulWidget {
  @override
  _WeeklyCalendarState createState() => _WeeklyCalendarState();
}

class _WeeklyCalendarState extends State<WeeklyCalendar> {
  DateTime _startOfWeek = DateTime.now();
  int _selectedDayIndex = 0;

  @override
  void initState() {
    super.initState();
    _startOfWeek = _getStartOfWeek(DateTime.now());
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1)); // Monday as start
  }

  void _goToNextWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.add(Duration(days: 7));
      _selectedDayIndex = 0;
    });
  }

  void _goToPreviousWeek() {
    setState(() {
      _startOfWeek = _startOfWeek.subtract(Duration(days: 7));
      _selectedDayIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDays = List.generate(7, (index) {
      return _startOfWeek.add(Duration(days: index));
    });

    String currentMonth = DateFormat('MMMM').format(_startOfWeek);
    int currentWeek =
        ((DateTime.now().difference(_startOfWeek).inDays) ~/ 7) + 1;

    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // Month and Week Navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                currentMonth,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.chevron_left),
                    onPressed: _goToPreviousWeek,
                  ),
                  Text(
                    'Week ${currentWeek}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.secondary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.chevron_right),
                    onPressed: _goToNextWeek,
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 12),
          // Day Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children:
                weekDays.asMap().entries.map((entry) {
                  int index = entry.key;
                  DateTime date = entry.value;

                  bool isSelected = index == _selectedDayIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDayIndex = index;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 6),
                      decoration: BoxDecoration(
                        color:
                            isSelected
                                ? AppColors.secondary
                                : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('d').format(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('E').format(date),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
          ),
        ],
      ),
    );
  }
}
