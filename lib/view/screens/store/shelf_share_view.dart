import 'package:aleedz/core/constants/app_colors.dart';
import 'package:aleedz/core/services/label_services.dart';
import 'package:aleedz/routes/navigation_services.dart';
import 'package:aleedz/models/category_store_share_model.dart';
import 'package:aleedz/view/screens/store/shelf_share_detail_view.dart';
import 'package:aleedz/viewmodel/store_share_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ShelfShareView extends ConsumerStatefulWidget {
  final String storeName;
  final String checkInTime;
  final String address;
  final int storeId;
  final int visitId;

  const ShelfShareView({
    super.key,
    required this.storeName,
    required this.checkInTime,
    required this.address,
    required this.storeId,
    required this.visitId,
  });

  @override
  ConsumerState<ShelfShareView> createState() => _ShelfShareViewState();
}

class _ShelfShareViewState extends ConsumerState<ShelfShareView> {
  int _selectedCategoryFilter = 0;
  bool _loading = true;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    Future.microtask(_loadData);
  }

  Future<void> _loadData() async {
    if (widget.storeId <= 0) {
      if (!mounted) return;
      setState(() {
        _loadError = 'Shelf Share needs an active store';
        _loading = false;
      });
      return;
    }

    final notifier = ref.read(storeShareModelProvider.notifier);
    await notifier.loadUser();
    await notifier.getShelfShareCategoryDropdown();
    await notifier.getShelfShareCategorySummary(
      storeId: widget.storeId,
      productCategoryId: 0,
    );
    if (!mounted) return;
    setState(() {
      _loading = false;
    });
  }

  void _openCategory(CategoryStoreShareModel category) {
    NavigationService.navigateTo(
      ShelfShareDetailView(
        storeName: widget.storeName,
        checkInTime: widget.checkInTime,
        address: widget.address,
        storeId: widget.storeId,
        visitId: widget.visitId,
        productCategoryId: category.productCategoryID ?? 0,
        productCategoryName:
            category.productCategoryName ?? category.brandName ?? '',
      ),
    );
  }

  Widget _buildCategoryTile(
    BuildContext context,
    CategoryStoreShareModel category,
    int displayIndex,
  ) {
    return InkWell(
      onTap: () => _openCategory(category),
      borderRadius: BorderRadius.circular(18),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x16000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                width: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFF0F172A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(18),
                    bottomLeft: Radius.circular(18),
                  ),
                ),
                child: Center(
                  child: Text(
                    '$displayIndex',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        category.productCategoryName ??
                            category.brandName ??
                            '',
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Updated by: ${category.code ?? '--'}',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 64,
                      child: Text(
                        '${category.count ?? 0}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF111827),
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    SizedBox(width: 64, child: const Text('')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(storeShareModelProvider);
    final categories = viewModel.shelfShareCategoryList;
    final summaryItems = viewModel.shelfShareCategorySummaryList;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body:
            _loading
                ? Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Theme.of(context).colorScheme.primary,
                    size: 32,
                  ),
                )
                : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 18,
                      ),
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
                              const Text(
                                'Shelf Share',
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
                            widget.storeName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.address,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check,
                                  color: AppColors.primary,
                                  size: 16,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  '${LabelService().getLabel(14)} ${widget.checkInTime}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_loadError != null)
                      Expanded(
                        child: Center(
                          child: Text(
                            _loadError!,
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(14),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x12000000),
                                blurRadius: 12,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<int>(
                              value: _selectedCategoryFilter,
                              isExpanded: true,
                              icon: const Icon(
                                Icons.keyboard_arrow_down_rounded,
                              ),
                              borderRadius: BorderRadius.circular(14),
                              items: [
                                const DropdownMenuItem<int>(
                                  value: 0,
                                  child: Text('All Categories'),
                                ),
                                ...categories.map(
                                  (category) => DropdownMenuItem<int>(
                                    value: category.productCategoryID ?? 0,
                                    child: Text(
                                      category.productCategoryName ??
                                          category.brandName ??
                                          '',
                                    ),
                                  ),
                                ),
                              ],
                              onChanged: (value) async {
                                if (value == null) return;
                                setState(() {
                                  _selectedCategoryFilter = value;
                                });
                                await ref
                                    .read(storeShareModelProvider.notifier)
                                    .getShelfShareCategorySummary(
                                      storeId: widget.storeId,
                                      productCategoryId: value,
                                    );
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Text(
                                'Category',
                                style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 64,
                              child: Text(
                                'Facing',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 64,
                              child: Text(
                                'Stock',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey.shade900,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child:
                            viewModel.loader && summaryItems.isEmpty
                                ? Center(
                                  child: LoadingAnimationWidget.discreteCircle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    size: 28,
                                  ),
                                )
                                : summaryItems.isEmpty
                                ? Center(
                                  child: Text(
                                    'No shelf share data found',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                                : ListView.builder(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  itemCount: summaryItems.length,
                                  itemBuilder: (context, index) {
                                    final category = summaryItems[index];
                                    return _buildCategoryTile(
                                      context,
                                      category,
                                      index + 1,
                                    );
                                  },
                                ),
                      ),
                    ],
                  ],
                ),
      ),
    );
  }
}
